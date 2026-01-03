//
//  HttpClientFactory.swift
//  Archiy
//
//  Created by Ahmed Guedmioui on 2/1/2026.
//

import Foundation

/// Factory for creating configured HTTP clients
/// Follows iOS best practices with protocol-oriented design
enum HttpClientFactory {
    static func build(
        baseURL: String,
        timeoutInterval: TimeInterval = 30.0,
        additionalHeaders: [String: String]? = nil,
        authTokenProvider: (() -> String?)? = nil
    ) -> HttpClientProtocol {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInterval
        configuration.timeoutIntervalForResource = timeoutInterval
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        
        let session = URLSession(configuration: configuration)
        
        return HttpClient(
            session: session,
            baseURL: baseURL,
            decoder: decoder,
            encoder: encoder,
            authTokenProvider: authTokenProvider
        )
    }
}
