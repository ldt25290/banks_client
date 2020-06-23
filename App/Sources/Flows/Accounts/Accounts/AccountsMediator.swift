import UIKit

protocol AccountsMediator: class {
    
}

final class AccountsMediatorImpl: NSObject, AccountsMediator {
    
    private let viewModel: AccountsViewModel
    private let collectionView: UICollectionView
    
    init(collectionView: UICollectionView, viewModel: AccountsViewModel) {
        self.collectionView = collectionView
        self.viewModel = viewModel
        
        super.init()
        
        collectionView.register(R.nib.accountCell)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        viewModel.onDataSourceChange = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}

extension AccountsMediatorImpl: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.account_cell, for: indexPath)!
        
        let cellModel = viewModel.cellModelForItem(at: indexPath)
        cell.setup(model: cellModel)
        return cell
    }
}

extension AccountsMediatorImpl: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 30.0, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
    }
}
