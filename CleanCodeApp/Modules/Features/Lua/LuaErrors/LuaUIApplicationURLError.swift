//
//  LuaUIApplicationURLError.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 15/02/25.
//

public enum LuaUIApplicationURLError: Error {
    case unableToOpenAppURL
    case invalidAppURL
}

extension LuaUIApplicationURLError {
    var errorTitle: String? {
        switch self {
        case .invalidAppURL, .unableToOpenAppURL:
            return "Error ao abrir link externo"
        }
    }
}
