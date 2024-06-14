import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    enum Section: Int {
        
        case main
    }
    
    typealias ModelDataSource = UICollectionViewDiffableDataSource<Section, Model>
    typealias ModelDataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Model>
    
    private lazy var dataSource: ModelDataSource = {
        ModelDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }()
    
    typealias ModelCellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Model>
    private let cellRegistration = ModelCellRegistration { cell, indexPath, model in
        cell.contentConfiguration = UIHostingConfiguration(content: {
            ModelView(model: model)
        })
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
        var snapShot = ModelDataSourceSnapshot()
        snapShot.appendSections([.main])
        let models = (0...30).map { Model(id: $0) }
        snapShot.appendItems(models, toSection: .main)
        dataSource.apply(snapShot)
    }
}

#Preview {
    ViewController()
}
