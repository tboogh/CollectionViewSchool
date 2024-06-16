import UIKit
import SwiftUI

class ViewController: UIViewController, CollectionViewLayoutDelegate {
    
    enum Section: Int {
        
        case main
    }
    
    typealias ModelDataSource = UICollectionViewDiffableDataSource<Section, Model>
    typealias ModelDataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Model>
    
    private lazy var dataSource: ModelDataSource = {
        let dataSource = ModelDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
        }
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: self.supplementaryViewRegistration, for: indexPath)
        }
        return dataSource
    }()
    
    typealias ModelCellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Model>
    typealias SupplementaryViewRegistration = UICollectionView.SupplementaryRegistration<SupplementaryView>
    private let cellRegistration = ModelCellRegistration { cell, indexPath, model in
        cell.contentConfiguration = UIHostingConfiguration(content: {
            ModelView(model: model)
        })
    }
    private let supplementaryViewRegistration = SupplementaryViewRegistration(elementKind: "SupplemetaryKind") { supplementaryView, elementKind, indexPath in
        supplementaryView.backgroundColor = .red
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        let constraints = [
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        return collectionView
    }()
    
    private lazy var collectionViewLayout = CollectionViewLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewLayout.delegate = self
        var snapShot = ModelDataSourceSnapshot()
        snapShot.appendSections([.main])
        let models = (0...30).map { index in Model(id: index, heightChangeAction: { [collectionViewLayout, collectionView] size in
            collectionViewLayout.resizeElement(
                atIndexPath: IndexPath(item: index, section: 0),
                toSize: CGSize(width: collectionView.bounds.size.width, height: size))
        }) }
        snapShot.appendItems(models, toSection: .main)
        dataSource.apply(snapShot)
    }
    
    func supplementaryKind(forIndexPath indexPath: IndexPath) -> String? {
        if indexPath.item % 3 == 0 {
            return "SupplemetaryKind"
        }
        return nil
    }
}

#Preview {
    ViewController()
}
