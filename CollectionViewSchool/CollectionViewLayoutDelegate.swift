import Foundation

public protocol CollectionViewLayoutDelegate: AnyObject {
    
    func supplementaryKind(forIndexPath: IndexPath) -> String?
}
