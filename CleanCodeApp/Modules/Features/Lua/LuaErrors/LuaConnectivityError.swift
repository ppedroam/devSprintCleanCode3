//
//  LuaConnecti.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 10/02/25.
//

import Foundation

enum LuaConnectivityError: Error {
    case noInternetConnection
}

extension LuaConnectivityError: LocalizedError {
    
    var errorTitle: String? {
        switch self {
        case .noInternetConnection:
            return "Sem Conexão com a Internet."
        }
    }

    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "Você não está conectado à internet. Verifique sua conexão e tente novamente."
        }
    }
}
