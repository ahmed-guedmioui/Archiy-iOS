//
//  CoreModule.swift
//  Archiy
//
//  Created by Ahmed Guedmioui on 3/1/2026.
//

import Foundation

let coreModule: () = module { m in
    // Register HttpClientProtocol (so repositories can inject it)
    m.single(HttpClientProtocol.self) {
        let baseURL = getBaseURL()
        return HttpClientFactory.build(
            baseURL: baseURL,
            timeoutInterval: 30.0
        )
    }
    
    // Register ExampleRepository
    m.single(ExampleRepository.self) {
        ExampleRepositoryImpl(httpClient: m.get())
    }
}

private func getBaseURL() -> String {
    #if DEBUG
    return "https://api.example.com"
    #else
    return "https://api.production.com"
    #endif
}
