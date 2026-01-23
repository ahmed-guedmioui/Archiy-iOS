//
//  DependencyInjection.swift
//  Archiy
//
//  Created by Ahmed Guedmioui on 2/1/2026.
//

import SwiftUI

// MARK: - Property Wrapper

/// Property wrapper for dependency injection
/// Usage: @Inject var someClass: SomeClass
@propertyWrapper
struct Inject<T> {
    private let container: DependencyContainer
    private var value: T?
    
    var wrappedValue: T {
        mutating get {
            if let value = value {
                return value
            }
            guard let resolved = try? container.resolveOrThrow(T.self) else {
                fatalError("Failed to resolve dependency of type \(String(describing: T.self)). Make sure it's registered in DependencyRegistry.")
            }
            value = resolved
            return resolved
        }
    }
    
    init(container: DependencyContainer = .shared) {
        self.container = container
    }
}

// MARK: - SwiftUI Environment

/// Environment key for dependency container
private struct DependencyContainerKey: EnvironmentKey {
    static let defaultValue = DependencyContainer.shared
}

extension EnvironmentValues {
    var dependencyContainer: DependencyContainer {
        get { self[DependencyContainerKey.self] }
        set { self[DependencyContainerKey.self] = newValue }
    }
}

/// View modifier to inject dependencies into the environment
extension View {
    func injectDependencies(_ container: DependencyContainer = .shared) -> some View {
        self.environment(\.dependencyContainer, container)
    }
}

// MARK: - Convenience Extensions

extension DependencyContainer {
    /// Convenience method to resolve dependencies in views
    func resolve<T>(_ type: T.Type) -> T {
        do {
            return try resolveOrThrow(type)
        } catch {
            fatalError("Failed to resolve dependency of type \(String(describing: T.self)): \(error.localizedDescription)")
        }
    }
}
