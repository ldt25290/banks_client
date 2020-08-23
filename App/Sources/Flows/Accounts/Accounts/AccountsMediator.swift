import UIKit

protocol AccountsMediator: AnyObject {}

final class AccountsMediatorImpl: NSObject, AccountsMediator {
    private let viewModel: AccountsViewModel
    private let collectionView: UICollectionView

    init(collectionView: UICollectionView, viewModel: AccountsViewModel) {
        self.collectionView = collectionView
        self.viewModel = viewModel

        super.init()

        collectionView.register(R.nib.accountCell)
        collectionView.register(R.nib.accountOverviewCell)
        collectionView.register(R.nib.transactionsListHeader, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.setCollectionViewLayout(layout(), animated: false)

        viewModel.onDataSourceChange = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    private func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (section, _) -> NSCollectionLayoutSection? in
            guard let self = self else {
                return nil
            }

            if case .account = self.viewModel.sectionType(for: section) {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(100.0))
                let sectionInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 15.0, bottom: 0.0, trailing: 15.0)
                let supplementaryItems = [self.listHeader()]

                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.contentInsets = sectionInsets

                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = supplementaryItems

                return section
            }

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))

            let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
            layoutItem.contentInsets = .init(top: 0.0, leading: 5.0, bottom: 15.0, trailing: 5.0)

            let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
                                                         heightDimension: .absolute(150))

            let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize,
                                                                 subitem: layoutItem,
                                                                 count: 1)
            
            
            let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
            layoutSection.orthogonalScrollingBehavior = .continuous

            layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 15.0, bottom: 20.0, trailing: 15.0)

            return layoutSection
        }
        
//        let config = UICollectionViewCompositionalLayoutConfiguration()
//        config.interSectionSpacing = 20
//        layout.configuration = config
        
        return layout
    }

    private func listHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(40.0))

        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)

        return header
    }
}

extension AccountsMediatorImpl: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        viewModel.numberOfSections()
    }

    func collectionView(_: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int
    {
        viewModel.numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let sectionType = viewModel.sectionType(for: indexPath.section)

        switch sectionType {
        case .account:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.account_cell, for: indexPath)!

            let cellModel = viewModel.accountCellModelForItem(at: indexPath)
            cell.setup(model: cellModel)
            return cell
        case .overview:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.account_overview_cell, for: indexPath)!
            
            let cellModel = viewModel.balanceCellModelForItem(at: indexPath)
            cell.setup(model: cellModel)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView
    {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError()
        }

        let reuseIdentifier = R.reuseIdentifier.transactions_list_header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: reuseIdentifier,
                                                                     for: indexPath)

        let title = viewModel.title(for: indexPath.section)
        header?.setTitle(title)
        return header!
    }
}

extension AccountsMediatorImpl: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard case .account = viewModel.sectionType(for: indexPath.section) else {
            return
        }

        viewModel.showTransactionsForAccount(at: indexPath)
    }
}

// extension AccountsMediatorImpl: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView,
//                        layout _: UICollectionViewLayout,
//                        sizeForItemAt _: IndexPath) -> CGSize
//    {
//        CGSize(width: collectionView.bounds.width - 30.0, height: 100)
//    }
//
//    func collectionView(_: UICollectionView,
//                        layout _: UICollectionViewLayout,
//                        insetForSectionAt _: Int) -> UIEdgeInsets
//    {
//        UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout _: UICollectionViewLayout,
//                        referenceSizeForHeaderInSection _: Int) -> CGSize
//    {
//        CGSize(width: collectionView.bounds.width, height: 40)
//    }
// }
