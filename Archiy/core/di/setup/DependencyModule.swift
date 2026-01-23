//
//  DependencyModule.swift
//  Archiy
//
//  Created by Ahmed Guedmioui on 2/1/2026.
//

import Foundation

/// Dependency injection module
struct DependencyModule {
    private let container: DependencyContainer
    
    init(container: DependencyContainer = .shared) {
        self.container = container
    }
    
    /// Register a singleton instance
    /// Usage: single { SomeClass(...) }
    func single<T>(_ factory: @escaping () -> T) {
        let instance = factory()
        container.register(T.self, instance: instance)
    }
    
    /// Register a singleton for a protocol
    /// Usage: single(MyRepositoryProtocol.self) { MyRepository(get()) }
    func single<T>(_ type: T.Type, _ factory: @escaping () -> T) {
        let instance = factory()
        container.register(T.self, instance: instance, as: type)
    }
    
    /// Register a factory (creates new instance each time)
    /// Usage: factory { MyViewModel(get()) }
    func factory<T>(_ factory: @escaping () -> T) {
        container.register(T.self, factory: factory)
    }
    
    /// Register a factory for a protocol
    /// Usage: factory(MyRepositoryProtocol.self) { MyRepository(get()) }
    func factory<T>(_ type: T.Type, _ factory: @escaping () -> T) {
        container.register(T.self, factory: factory, as: type)
    }
    
    /// Get a dependency
    /// Usage: let httpClient: HttpClient= get()
    func get<T>() -> T {
        do {
            return try container.resolveOrThrow(T.self)
        } catch {
            fatalError("Failed to resolve \(String(describing: T.self)). Make sure it's registered.")
        }
    }
}

func module(_ configure: @escaping (DependencyModule) -> Void) {
    let module = DependencyModule()
    configure(module)
}
