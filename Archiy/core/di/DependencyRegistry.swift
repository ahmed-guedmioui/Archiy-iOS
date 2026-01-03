//
//  DependencyRegistry.swift
//  Archiy
//
//  Created by Ahmed Guedmioui on 2/1/2026.
//

import Foundation

/// Simple dependency registration
func startDI() {
    module { m in
        // Register HttpClient
        m.single(HttpClientProtocol.self) {
            let baseURL = getBaseURL()
            return HttpClientFactory.build(
                baseURL: baseURL,
                timeoutInterval: 30.0,
                authTokenProvider: {return ""}
            )
        }
        
        // Register your repositories here
        // Example:
        // m.single(MyRepositoryProtocol.self) { MyRepository(m.get()) }
    }
}

// MARK: - Configuration Helpers

private func getBaseURL() -> String {
    #if DEBUG
    return ProcessInfo.processInfo.environment["API_BASE_URL"] ?? "https://api.example.com"
    #else
    return ProcessInfo.processInfo.environment["API_BASE_URL"] ?? "https://api.production.com"
    #endif
}
