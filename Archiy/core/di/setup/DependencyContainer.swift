//
//  DependencyContainer.swift
//  Archiy
//
//  Created by Ahmed Guedmioui on 2/1/2026.
//

import Foundation

/// Thread-safe dependency injection container
/// Supports both singleton and factory-based registration patterns
final class DependencyContainer {
    static let shared = DependencyContainer()
    
    private var dependencies: [String: Any] = [:]
    private var factories: [String: () -> Any] = [:]
    private let queue = DispatchQueue(label: "com.archiy.dependencycontainer", attributes: .concurrent)
    
    private init() {}
    
    // MARK: - Singleton Registration
    
    /// Register a singleton instance for a type
    /// - Parameters:
    ///   - type: The protocol or type to register
    ///   - instance: The instance to register
    func register<T>(_ type: T.Type, instance: T) {
        let key = String(describing: type)
        queue.async(flags: .barrier) {
            self.dependencies[key] = instance
        }
    }
    
    /// Register a singleton instance for a protocol
    /// - Parameters:
    ///   - type: The protocol type
    ///   - instance: The concrete instance conforming to the protocol
    func register<T>(_ type: T.Type, instance: T, as protocolType: T.Type) {
        let key = String(describing: protocolType)
        queue.async(flags: .barrier) {
            self.dependencies[key] = instance
        }
    }
    
    // MARK: - Factory Registration
    
    /// Register a factory closure that creates a new instance each time
    /// - Parameters:
    ///   - type: The type to register
    ///   - factory: Closure that returns a new instance
    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        queue.async(flags: .barrier) {
            self.factories[key] = factory
        }
    }
    
    /// Register a factory closure for a protocol
    /// - Parameters:
    ///   - type: The protocol type
    ///   - factory: Closure that returns a concrete instance
    func register<T>(_ type: T.Type, factory: @escaping () -> T, as protocolType: T.Type) {
        let key = String(describing: protocolType)
        queue.async(flags: .barrier) {
            self.factories[key] = factory
        }
    }
    
    // MARK: - Resolution
    
    /// Resolve a dependency (throws if not found)
    /// - Parameter type: The type to resolve
    /// - Returns: The registered instance or factory-created instance
    /// - Throws: DependencyError if not found
    func resolveOrThrow<T>(_ type: T.Type) throws -> T {
        let key = String(describing: type)
        
        return try queue.sync {
            // First check for singleton
            if let instance = dependencies[key] as? T {
                return instance
            }
            
            // Then check for factory
            if let factory = factories[key] {
                if let instance = factory() as? T {
                    return instance
                }
            }
            
            throw DependencyError.notRegistered(type: String(describing: type))
        }
    }
    
    /// Resolve a dependency with optional return
    /// - Parameter type: The type to resolve
    /// - Returns: The registered instance or nil if not found
    func resolveOptional<T>(_ type: T.Type) -> T? {
        try? resolveOrThrow(type)
    }
    
    // MARK: - Cleanup
    
    /// Remove a registered dependency
    /// - Parameter type: The type to remove
    func remove<T>(_ type: T.Type) {
        let key = String(describing: type)
        queue.async(flags: .barrier) {
            self.dependencies.removeValue(forKey: key)
            self.factories.removeValue(forKey: key)
        }
    }
    
    /// Clear all registered dependencies
    func clear() {
        queue.async(flags: .barrier) {
            self.dependencies.removeAll()
            self.factories.removeAll()
        }
    }
}

// MARK: - DependencyError

enum DependencyError: LocalizedError {
    case notRegistered(type: String)
    
    var errorDescription: String? {
        switch self {
        case .notRegistered(let type):
            return "Dependency of type \(type) is not registered"
        }
    }
}
