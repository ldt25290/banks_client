import UIKit

protocol TransactionsMediator: AnyObject {
    init(collectionView: UICollectionView, viewModel: TransactionsViewModel)
}

final class TransactionsMediatorImpl: NSObject, TransactionsMediator {
    private let viewModel: TransactionsViewModel

    init(collectionView: UICollectionView, viewModel: TransactionsViewModel) {
        self.viewModel = viewModel

        collectionView.register(R.nib.transactionCell)
        collectionView.register(R.nib.loadingCell)
        collectionView.register(R.nib.transactionsListHeader,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)

        super.init()

        collectionView.setCollectionViewLayout(layout(), animated: false)

        collectionView.dataSource = self
        collectionView.delegate = self

        viewModel.onDataSourceChange = { [weak collectionView] in
            DispatchQueue.main.async {
                collectionView?.reloadData()
            }
        }
    }

    private func layout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] (section, _) -> NSCollectionLayoutSection? in
            guard let self = self else {
                return nil
            }

            let sectionType = self.viewModel.sectionType(for: section)

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize: NSCollectionLayoutSize
            let sectionInsets: NSDirectionalEdgeInsets
            var supplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []

            switch sectionType {
            case .data:
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(120.0))
                sectionInsets = .init(top: 0.0, leading: 15.0, bottom: 0.0, trailing: 15.0)
                supplementaryItems = [self.listHeader()]
            case .loading:
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(40.0))
                sectionInsets = .zero
            }

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = sectionInsets

            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryItems

            return section
        }
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

extension TransactionsMediatorImpl: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        viewModel.numberOfSections
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sectionType(for: indexPath.section)

        switch sectionType {
        case .data:
            let rows = viewModel.numberOfItems(in: indexPath.section)

            let identifier = R.reuseIdentifier.transaction_cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
            let model = viewModel.cellModelForItem(at: indexPath)
            cell?.setup(with: model, showSeparator: indexPath.row < rows - 1)
            return cell!
        case .loading:
            let identifier = R.reuseIdentifier.loading_cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
            return cell!
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView
    {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        let identifier = R.reuseIdentifier.transactions_list_header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: identifier,
                                                                     for: indexPath)!

        let title = viewModel.titleForHeader(in: indexPath.section)
        header.setTitle(title)

        return header
    }
}

extension TransactionsMediatorImpl: UICollectionViewDelegate {
    func collectionView(_: UICollectionView,
                        willDisplay _: UICollectionViewCell,
                        forItemAt indexPath: IndexPath)
    {
        guard case .loading = viewModel.sectionType(for: indexPath.section) else {
            return
        }
        viewModel.loadMoreTransactions()
    }
}
