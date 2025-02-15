//
//  LuaNetworkManager.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 15/02/25.
//

public enum APITarget {
    
}

private protocol LuaNetworkingProtocol {
    func request<T: Decodable>(_ target: APITarget) async throws -> T
}

extension LuaNetworkingProtocol {
   
}
