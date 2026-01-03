//
//  ExampleRepository.swift
//  Archiy
//
//  Created by Ahmed Guedmioui on 2/1/2026.
//

protocol ExampleRepository {
    func fetchData() async -> Result<String, DataError.Remote>
}

final class ExampleRepositoryImpl: ExampleRepository {
    private let httpClient: HttpClient
    
    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
    
    func fetchData() async -> Result<String, DataError.Remote> {
        return await httpClient.get(route: "/api/data", headers: nil)
    }
}
