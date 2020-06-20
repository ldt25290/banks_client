//
//  AppDependencies.swift
//  Banks
//
//  Created by Nikita Ivanchikov on 21.06.2020.
//

import Swinject
import SwinjectAutoregistration

struct AppDependencies {
    static func setup() -> Container {
        var container = Container()
        
        return container
    }
    
    static func reset(container: Container, scope: ObjectScope) {
        container.resetObjectScope(scope)
    }
}
