//
//  LuaNetworkError.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 10/02/25.
//

import Foundation

enum LuaNetworkError: Error {
    case decodeError
    case noData
    case invalidURL
    case invalidStatusCode
    case networkError
    case noInternetConnection
}

extension LuaNetworkError: LocalizedError {
    
    
    var errorTitle: String? {
        switch self {
        case .noInternetConnection:
            return "Sem Conexão com a Internet."
        default:
            return ""
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .decodeError:
            return "Error during data decoding"
        case .noData:
            return "Data error"
        case .invalidURL:
            return "Invalid URL"
        case .invalidStatusCode:
            return "Invalid status code"
        case .networkError:
            return "An error has occurred. Please verify your connection."
        case .noInternetConnection:
            return "Você não está conectado à internet. Verifique sua conexão e tente novamente."
        }
    }
    
}
