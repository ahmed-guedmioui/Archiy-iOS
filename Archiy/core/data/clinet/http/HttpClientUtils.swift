//
//  HttpClientUtils.swift
//  Archiy
//
//  Created by Ahmed Guedmioui on 2/1/2026.
//

import Foundation

func constructRoute(route: String, baseURL: String) -> String {
    if route.contains(baseURL) {
        return route
    } else if route.hasPrefix("/") {
        return "\(baseURL)\(route)"
    } else {
        return "\(baseURL)/\(route)"
    }
}

func responseToResult<T: Decodable>(
    response: HTTPURLResponse?,
    data: Data?,
    decoder: JSONDecoder
) -> Result<T, DataError.Remote> {
    guard let response = response else {
        return .failure(.unknown)
    }
    
    let statusCode = response.statusCode
    
    switch statusCode {
    case 200...299:
        guard let data = data else {
            return .failure(.serialization)
        }
        
        do {
            let decoded = try decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch {
            print("Serialization error: \(error)")
            return .failure(.serialization)
        }
        
    case 400:
        return .failure(.badRequest)
    case 401:
        return .failure(.unauthorized)
    case 403:
        return .failure(.forbidden)
    case 404:
        return .failure(.notFound)
    case 408:
        return .failure(.requestTimeout)
    case 409:
        return .failure(.conflict)
    case 413:
        return .failure(.payloadTooLarge)
    case 429:
        return .failure(.tooManyRequests)
    case 500:
        return .failure(.serverError)
    case 503:
        return .failure(.serviceUnavailable)
    default:
        return .failure(.unknown)
    }
}

func safeCall<T: Decodable>(
    decoder: JSONDecoder,
    execute: () async throws -> (Data, URLResponse)
) async -> Result<T, DataError.Remote> {
    do {
        let (data, response) = try await execute()
        let httpResponse = response as? HTTPURLResponse
        return responseToResult(response: httpResponse, data: data, decoder: decoder)
    } catch let error as URLError {
        print("URLError: \(error)")
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost, .cannotFindHost, .cannotConnectToHost:
            return .failure(.noInternet)
        case .timedOut:
            return .failure(.requestTimeout)
        default:
            return .failure(.unknown)
        }
    } catch let error as DecodingError {
        print("Decoding error: \(error)")
        return .failure(.serialization)
    } catch {
        print("Unknown error: \(error)")
        return .failure(.unknown)
    }
}
