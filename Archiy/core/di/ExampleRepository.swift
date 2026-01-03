//
//  ExampleRepository.swift
//  Archiy
//
//  Created by Ahmed Guedmioui on 2/1/2026.
//
//  This is an example repository showing how to use dependency injection
//  You can delete this file once you understand the pattern

import Foundation

/// Example repository protocol
protocol ExampleRepositoryProtocol {
    func fetchData() async -> Result<String, DataError.Remote>
}

/// Example repository implementation using dependency injection
final class ExampleRepository: ExampleRepositoryProtocol {
    private let httpClient: HttpClientProtocol
    
    // Inject HttpClientProtocol using @Inject property wrapper
    init(httpClient: HttpClientProtocol) {
        self.httpClient = httpClient
    }
    
    func fetchData() async -> Result<String, DataError.Remote> {
        // Use the injected httpClient
        return await httpClient.get(route: "/api/data", headers: nil)
    }
}

// MARK: - Alternative: Using @Inject Property Wrapper

/// Alternative example showing how to use @Inject property wrapper directly in a class
final class ExampleRepositoryWithInject {
    @Inject var httpClient: HttpClientProtocol
    
    func fetchData() async -> Result<String, DataError.Remote> {
        return await httpClient.get(route: "/api/data", headers: nil)
    }
}

// MARK: - Registration Example

/*
 To register this repository, add this to startDI() in DependencyRegistry.swift:
 
 m.single(ExampleRepositoryProtocol.self) { 
     ExampleRepository(httpClient: m.get())
 }
 */
