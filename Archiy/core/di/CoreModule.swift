//
//  CoreModule.swift
//  Archiy
//
//  Created by Ahmed Guedmioui on 3/1/2026.
//

import Foundation

let coreModule: () = module { m in
    m.single(HttpClient.self) {
        let baseURL = getBaseURL()
        return HttpClientFactory.build(
            baseURL: baseURL,
            timeoutInterval: 30.0,
            authTokenProvider: {return ""}
        )
    }
    
    m.single(ExampleRepository.self) {
        ExampleRepositoryImpl(httpClient: m.get())
    }
}

private func getBaseURL() -> String {
    #if DEBUG
    return ProcessInfo.processInfo.environment["API_BASE_URL"] ?? "https://api.example.com"
    #else
    return ProcessInfo.processInfo.environment["API_BASE_URL"] ?? "https://api.production.com"
    #endif
}
