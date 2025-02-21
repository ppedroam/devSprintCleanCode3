//
//  LuaNetworkError.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 10/02/25.
//

import Foundation

enum LuaNetworkError: Error {
    case badRequest // 400
    case unauthorized // 401
    case forbidden // 403
    case notFound // 404
    case serverError // 500
    case unknown
    case noInternetConnection
    case anyUnintendedResponse
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
        case .noInternetConnection:
            return "Você não está conectado à internet. Verifique sua conexão e tente novamente."
        default:
            return ""
        }
    }
}
