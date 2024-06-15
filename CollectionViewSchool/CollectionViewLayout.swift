import Foundation
import UIKit

class CollectionViewLayout: UICollectionViewLayout {
    
    class InvalidationContext: UICollectionViewLayoutInvalidationContext {
        
        var newSize: CGSize?
        var updatedIndexPath: IndexPath?
    }
    
    override class var invalidationContextClass: AnyClass { InvalidationContext.self }
    
    private var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    private var cachedSize: CGSize = .zero
    
    override func prepare() {
        guard 
            layoutAttributes.isEmpty,
            let collectionView
        else { return }
        
        let defaultSize = CGSize(width: collectionView.bounds.width, height: 100)
        
        var newAttributes = [UICollectionViewLayoutAttributes]()
        let sectionCount = collectionView.dataSource?.numberOfSections?(in: collectionView) ?? 0
        for sectionIndex in 0..<sectionCount {
            let itemCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: sectionIndex) ?? 0
            var currentHeight: CGFloat = 0
            for itemIndex in 0..<itemCount {
                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attribute.frame = CGRect(x: 0, y: currentHeight, width: defaultSize.width, height: defaultSize.height)
                currentHeight += defaultSize.height
                newAttributes.append(attribute)
            }
        }
        self.layoutAttributes = newAttributes
        cachedSize = layoutAttributes.reduce(into: CGRect.zero, { partialResult, next in
            partialResult = partialResult.union(next.frame)
        }).size
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        layoutAttributes.reduce(into: [UICollectionViewLayoutAttributes]()) { partialResult, attributes in
            if attributes.frame.intersects(rect) {
                partialResult.append(attributes)
            }
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        layoutAttributes[indexPath.item]
    }
    
    override var collectionViewContentSize: CGSize {
        cachedSize
    }
    
    // MARK - Custom methods
    
    func resizeElement(atIndexPath indexPath: IndexPath, toSize size: CGSize) {
        let attribute = layoutAttributes[indexPath.item]
        guard let updatedAttribute = attribute.copy() as? UICollectionViewLayoutAttributes else { return }
        updatedAttribute.frame.size.height = size.height
        
        guard let invalidationContext: InvalidationContext = invalidationContext(
            forPreferredLayoutAttributes: updatedAttribute,
            withOriginalAttributes: attribute) as? InvalidationContext else { return }
        invalidationContext.newSize = size
        invalidationContext.updatedIndexPath = indexPath
        let indexes = (indexPath.item..<layoutAttributes.count)
        let invalidatedIndexpaths = indexes.map { IndexPath(row: $0, section: 0)}
        invalidationContext.invalidateItems(at: invalidatedIndexpaths)
        invalidateLayout(with: invalidationContext)
    }
    
    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        guard let invalidationContext = context as? InvalidationContext else { return super.invalidateLayout(with: context) }
        if
            let updatedIndexPath = invalidationContext.updatedIndexPath,
            let size = invalidationContext.newSize {
            let attribute = layoutAttributes[updatedIndexPath.item]
            attribute.frame.size = size
            
            var bottom = attribute.frame.maxY
            for index in updatedIndexPath.item..<layoutAttributes.count {
                if index == updatedIndexPath.item { continue }
                let nextAttribute = layoutAttributes[index]
                nextAttribute.frame.origin.y = bottom
                bottom = nextAttribute.frame.maxY
            }
        }
        cachedSize = layoutAttributes.reduce(into: CGRect.zero, { partialResult, next in
            partialResult = partialResult.union(next.frame)
        }).size
        super.invalidateLayout(with: context)
    }
}
