//
//  Result+Extensions.swift
//  Archiy
//
//  Created by Ahmed Guedmioui on 2/1/2026.
//

import Foundation

extension Result {
    /// Maps the success value to a new type
    func map<NewSuccess>(_ transform: (Success) -> NewSuccess) -> Result<NewSuccess, Failure> {
        switch self {
        case .success(let value):
            return .success(transform(value))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// Executes an action on success and returns the original result
    func onSuccess(_ action: (Success) -> Void) -> Result<Success, Failure> {
        if case .success(let value) = self {
            action(value)
        }
        return self
    }
    
    /// Executes an action on failure and returns the original result
    func onError(_ action: (Failure) -> Void) -> Result<Success, Failure> {
        if case .failure(let error) = self {
            action(error)
        }
        return self
    }
    
    /// Converts to an empty result (Unit type)
    func asEmptyResult() -> Result<Void, Failure> {
        return map { _ in () }
    }
}

typealias EmptyResult<Failure: Error> = Result<Void, Failure>
