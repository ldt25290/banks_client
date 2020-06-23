//
//  AppDependencies.swift
//  Banks
//
//  Created by Nikita Ivanchikov on 21.06.2020.
//

import Swinject
import SwinjectAutoregistration

extension ObjectScope {
    static let sessionScope = ObjectScope(storageFactory: PermanentStorage.init)
}

struct AppDependencies {
    static func setup() -> (Assembler, Container) {
        let container = Container()
        
        let assembler = Assembler(container: container)
        
        assembler.apply(assemblies: [
            CoreDependencies()
        ])
        
        return (assembler, container)
    }
    
    static func reset(container: Container, scope: ObjectScope) {
        container.resetObjectScope(scope)
    }
}

// swiftlint:disable force_try
struct CoreDependencies: Assembly {
    func assemble(container: Container) {
        container.register(DatabaseService.self, factory: { _ in
            try! DatabaseServiceImpl()
        }).inObjectScope(.sessionScope)
    }
}
