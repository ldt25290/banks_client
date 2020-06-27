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

        collectionView.dataSource = self
        collectionView.delegate = self

        viewModel.onDataSourceChange = { [weak collectionView] in
            DispatchQueue.main.async {
                collectionView?.reloadData()
            }
        }
    }

    static func transactionCellProvider(collectionView: UICollectionView,
                                        indexPath: IndexPath,
                                        model: TransactionCellModel) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.transaction_cell,
                                                      for: indexPath)
        cell?.setup(with: model)
        return cell
    }

    static func transactionHeaderProvider(collectionView: UICollectionView,
                                          kind: String,
                                          indexPath: IndexPath) -> UICollectionReusableView? {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return nil
        }

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: R.reuseIdentifier.transactions_list_header,
                                                                     for: indexPath)

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
            let identifier = R.reuseIdentifier.transaction_cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
            let model = viewModel.cellModelForItem(at: indexPath)
            cell?.setup(with: model)
            return cell!
        case .loading:
            let identifier = R.reuseIdentifier.loading_cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
            return cell!
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
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
                        forItemAt indexPath: IndexPath) {
        guard case .loading = viewModel.sectionType(for: indexPath.section) else {
            return
        }
        viewModel.loadMoreTransactions()
    }
}

extension TransactionsMediatorImpl: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout _: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch viewModel.sectionType(for: indexPath.section) {
        case .data:
            return CGSize(width: collectionView.bounds.width - 30.0, height: 100)
        case .loading:
            return CGSize(width: collectionView.bounds.width, height: 40)
        }
    }

    func collectionView(_: UICollectionView,
                        layout _: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        switch viewModel.sectionType(for: section) {
        case .data:
            return UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        case .loading:
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout _: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch viewModel.sectionType(for: section) {
        case .data:
            return CGSize(width: collectionView.bounds.width, height: 40)
        default:
            return .zero
        }
    }
}
