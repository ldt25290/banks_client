import GRDB

struct Migrations {
    static func migrate(with db: DatabaseWriter) throws {
        var migrator = DatabaseMigrator()

        migrator.registerMigration("v1", migrate: v1_setupSchema)

        try migrator.migrate(db)
    }

    static func v1_setupSchema(db: Database) throws {
        try db.create(table: BankAccount.databaseTableName, body: { def in
            def.column(BankAccount.CodingKeys.id, .text).primaryKey()
            def.column(BankAccount.CodingKeys.bank, .text)
            def.column(BankAccount.CodingKeys.name, .text)
            def.column(BankAccount.CodingKeys.number, .text)
            def.column(BankAccount.CodingKeys.balance, .integer)
            def.column(BankAccount.CodingKeys.currency, .text)
            def.column(BankAccount.CodingKeys.limit, .integer)
            def.column(BankAccount.CodingKeys.isCredit, .boolean)
        })
    }
}

extension TableDefinition {
    @discardableResult
    public func column<T>(_ name: T, _ type: Database.ColumnType? = nil) -> ColumnDefinition where T: RawRepresentable, T.RawValue == String {
        column(name.rawValue, type)
    }
}

extension TableAlteration {
    @discardableResult
    public func add<T>(column name: T, _ type: Database.ColumnType? = nil) -> ColumnDefinition where T: RawRepresentable, T.RawValue == String {
        add(column: name.rawValue, type)
    }
}

extension ColumnDefinition {
    @discardableResult
    public func references<T>(
        _ table: String,
        column: T? = nil,
        onDelete deleteAction: Database.ForeignKeyAction? = nil,
        onUpdate updateAction: Database.ForeignKeyAction? = nil,
        deferred: Bool = false
    ) -> ColumnDefinition where T: RawRepresentable, T.RawValue == String {
        references(table, column: column?.rawValue,
                   onDelete: deleteAction, onUpdate: updateAction,
                   deferred: deferred)
    }
}
