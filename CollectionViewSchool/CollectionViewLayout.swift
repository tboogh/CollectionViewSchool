import Foundation
import UIKit

class CollectionViewLayout: UICollectionViewLayout {
    
    private var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    private var cachedSize: CGSize = .zero
    
    override func prepare() {
        guard let collectionView else { return }
        
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
}
