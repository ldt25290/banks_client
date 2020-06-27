import Swinject

protocol AccountsModuleFactory {
    func makeAccountsModuleOutput(container: Container) -> (AccountsModuleOutput, Presentable)

    func makeTransactionsModuleOutput(accountID: String?, container: Container) -> (TransactionsModuleOutput, Presentable)
}
