//
//  HttpClientProtocol.swift
//  Archiy
//
//  Created by Ahmed Guedmioui on 2/1/2026.
//

import Foundation

protocol HttpClient {
    func get<Response: Decodable>(
        route: String,
        headers: [String: String]?
    ) async -> Result<Response, DataError.Remote>
    
    func post<Response: Decodable>(
        route: String,
        body: [String: Any]?,
        headers: [String: String]?
    ) async -> Result<Response, DataError.Remote>
    
    func post<Response: Decodable, Body: Encodable>(
        route: String,
        body: Body,
        headers: [String: String]?
    ) async -> Result<Response, DataError.Remote>
    
    func put<Response: Decodable>(
        route: String,
        body: [String: Any]?,
        headers: [String: String]?
    ) async -> Result<Response, DataError.Remote>
    
    func put<Response: Decodable, Body: Encodable>(
        route: String,
        body: Body,
        headers: [String: String]?
    ) async -> Result<Response, DataError.Remote>
    
    func patch<Response: Decodable>(
        route: String,
        body: [String: Any]?,
        headers: [String: String]?
    ) async -> Result<Response, DataError.Remote>
    
    func patch<Response: Decodable, Body: Encodable>(
        route: String,
        body: Body,
        headers: [String: String]?
    ) async -> Result<Response, DataError.Remote>
    
    func getFileBytes(
        route: String,
        headers: [String: String]?
    ) async throws -> Data
    
    func postFormData<Response: Decodable>(
        route: String,
        file: ArchiyFile,
        body: [String: Any],
        headers: [String: String]
    ) async -> Result<Response, DataError.Remote>
}
