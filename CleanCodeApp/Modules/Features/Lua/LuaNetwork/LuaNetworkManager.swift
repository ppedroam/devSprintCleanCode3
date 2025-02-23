//
//  LuaNetworkManager.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 15/02/25.
//

import Foundation



public protocol LuaNetworkSessionProtocol {
    func customDataTaskPublisher(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: LuaNetworkSessionProtocol {
    public func customDataTaskPublisher(for request: URLRequest) async throws -> (Data, URLResponse) {
        let (data, response) = try await self.data(for: request)
        return (data, response)
    }
}

public protocol LuaNetworkManagerProtocol {
    func request<T: Decodable>(_ target: LuaAPIEndpointProtocol) async throws -> T
}

final class LuaNetworkManager: LuaNetworkManagerProtocol {
    
    private let session: LuaNetworkSessionProtocol
    private let useMockData: Bool
    
    init(session: LuaNetworkSessionProtocol = URLSession.shared, useMockData: Bool = true) {
        self.session = session
        self.useMockData = useMockData
    }
    
    public func request<T: Decodable>(_ target: LuaAPIEndpointProtocol) async throws -> T {
        
        if useMockData {
            let data = target.dummyData
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        }
        
        var request = URLRequest(url: target.url)
        request.httpMethod = target.method
        request.allHTTPHeaderFields = target.headers
        
        if target.method == "POST" {
            request.httpBody = try? JSONSerialization.data(withJSONObject: target.parameters, options: .prettyPrinted)
        }
        
        let (data, response) = try await session.customDataTaskPublisher(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw LuaNetworkError.unknown
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        case 400:
            throw LuaNetworkError.badRequest
        case 401:
            throw LuaNetworkError.unauthorized
        case 403:
            throw LuaNetworkError.forbidden
        case 404:
            throw LuaNetworkError.notFound
        case 500:
            throw LuaNetworkError.serverError
        default:
            throw LuaNetworkError.unknown
        }
    }
}
