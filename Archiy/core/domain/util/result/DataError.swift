//
//  DataError.swift
//  Archiy
//
//  Created by Ahmed Guedmioui on 2/1/2026.
//

import Foundation

enum DataError: Error {
    enum Remote: Error {
        case badRequest
        case requestTimeout
        case unauthorized
        case forbidden
        case notFound
        case conflict
        case tooManyRequests
        case noInternet
        case payloadTooLarge
        case serverError
        case serviceUnavailable
        case serialization
        case unknown
    }
    
    enum Local: Error {
        case diskFull
        case notFound
        case unknown
    }
    
    case connection(Connection)
    
    enum Connection: Error {
        case notConnected
    }
}
