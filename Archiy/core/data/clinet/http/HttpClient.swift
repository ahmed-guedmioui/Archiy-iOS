//
//  HttpClient.swift
//  Archiy
//
//  Created by Ahmed Guedmioui on 2/1/2026.
//

import Foundation

/// Production HTTP client implementation using URLSession
/// Uses Swift's built-in Result type for type-safe error handling
final class HttpClient: HttpClientProtocol {
    private let session: URLSession
    private let baseURL: String
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let authTokenProvider: (() -> String?)?
    
    init(
        session: URLSession = .shared,
        baseURL: String,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder(),
        authTokenProvider: (() -> String?)? = nil
    ) {
        self.session = session
        self.baseURL = baseURL
        self.decoder = decoder
        self.encoder = encoder
        self.authTokenProvider = authTokenProvider
    }
    
    // MARK: - HttpClientProtocol
    
    func get<Response: Decodable>(
        route: String,
        headers: [String: String]? = nil
    ) async -> Result<Response, DataError.Remote> {
        await safeCall(decoder: decoder) {
            let request = try buildRequest(
                route: route,
                method: "GET",
                body: nil,
                headers: headers
            )
            return try await session.data(for: request)
        }
    }
    
    func post<Response: Decodable>(
        route: String,
        body: [String: Any]? = nil,
        headers: [String: String]? = nil
    ) async -> Result<Response, DataError.Remote> {
        await safeCall(decoder: decoder) {
            let request = try buildRequest(
                route: route,
                method: "POST",
                body: body,
                headers: headers
            )
            return try await session.data(for: request)
        }
    }
    
    func post<Response: Decodable, Body: Encodable>(
        route: String,
        body: Body,
        headers: [String: String]? = nil
    ) async -> Result<Response, DataError.Remote> {
        await safeCall(decoder: decoder) {
            let request = try buildRequest(
                route: route,
                method: "POST",
                body: body,
                headers: headers
            )
            return try await session.data(for: request)
        }
    }
    
    func put<Response: Decodable>(
        route: String,
        body: [String: Any]? = nil,
        headers: [String: String]? = nil
    ) async -> Result<Response, DataError.Remote> {
        await safeCall(decoder: decoder) {
            let request = try buildRequest(
                route: route,
                method: "PUT",
                body: body,
                headers: headers
            )
            return try await session.data(for: request)
        }
    }
    
    func put<Response: Decodable, Body: Encodable>(
        route: String,
        body: Body,
        headers: [String: String]? = nil
    ) async -> Result<Response, DataError.Remote> {
        await safeCall(decoder: decoder) {
            let request = try buildRequest(
                route: route,
                method: "PUT",
                body: body,
                headers: headers
            )
            return try await session.data(for: request)
        }
    }
    
    func patch<Response: Decodable>(
        route: String,
        body: [String: Any]? = nil,
        headers: [String: String]? = nil
    ) async -> Result<Response, DataError.Remote> {
        await safeCall(decoder: decoder) {
            let request = try buildRequest(
                route: route,
                method: "PATCH",
                body: body,
                headers: headers
            )
            return try await session.data(for: request)
        }
    }
    
    func patch<Response: Decodable, Body: Encodable>(
        route: String,
        body: Body,
        headers: [String: String]? = nil
    ) async -> Result<Response, DataError.Remote> {
        await safeCall(decoder: decoder) {
            let request = try buildRequest(
                route: route,
                method: "PATCH",
                body: body,
                headers: headers
            )
            return try await session.data(for: request)
        }
    }
    
    func getFileBytes(
        route: String,
        headers: [String: String]? = nil
    ) async throws -> Data {
        let request = try buildRequest(
            route: route,
            method: "GET",
            body: nil,
            headers: headers
        )
        let (data, _) = try await session.data(for: request)
        return data
    }
    
    func postFormData<Response: Decodable>(
        route: String,
        file: ArchiyFile,
        body: [String: Any] = [:],
        headers: [String: String] = [:]
    ) async -> Result<Response, DataError.Remote> {
        await safeCall(decoder: decoder) {
            let request = try buildMultipartRequest(
                route: route,
                file: file,
                body: body,
                headers: headers
            )
            return try await session.data(for: request)
        }
    }
    
    // MARK: - Private Methods
    
    private func buildRequest(
        route: String,
        method: String,
        body: [String: Any]? = nil,
        headers: [String: String]? = nil
    ) throws -> URLRequest {
        let urlString = constructRoute(route: route, baseURL: baseURL)
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Add auth token if available
        if let token = authTokenProvider?(), !token.isEmpty {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        // Add custom headers (these can override auth token if needed)
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Set body
        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        
        return request
    }
    
    private func buildRequest<Body: Encodable>(
        route: String,
        method: String,
        body: Body,
        headers: [String: String]? = nil
    ) throws -> URLRequest {
        let urlString = constructRoute(route: route, baseURL: baseURL)
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Add auth token if available
        if let token = authTokenProvider?(), !token.isEmpty {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        // Add custom headers (these can override auth token if needed)
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Set body
        request.httpBody = try encoder.encode(body)
        
        return request
    }
    
    private func buildMultipartRequest(
        route: String,
        file: ArchiyFile,
        body: [String: Any],
        headers: [String: String]
    ) throws -> URLRequest {
        let urlString = constructRoute(route: route, baseURL: baseURL)
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Create boundary for multipart form data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Add auth token if available
        if let token = authTokenProvider?(), !token.isEmpty {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        // Add custom headers
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Build multipart body
        var bodyData = Data()
        
        // Add file
        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.name).\(file.extension)\"\r\n".data(using: .utf8)!)
        bodyData.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
        bodyData.append(file.bytes)
        bodyData.append("\r\n".data(using: .utf8)!)
        
        // Add additional body fields
        for (key, value) in body {
            bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
            bodyData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            if let stringValue = value as? String {
                bodyData.append(stringValue.data(using: .utf8)!)
            } else {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                bodyData.append(jsonData)
            }
            bodyData.append("\r\n".data(using: .utf8)!)
        }
        
        // Close boundary
        bodyData.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = bodyData
        
        return request
    }
}
