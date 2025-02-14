//
//  LuaPasswordRecoveryError.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 10/02/25.
//

import Foundation

enum LuaUserAccountError: Error {
    case invalidEmail
}

extension LuaUserAccountError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "O e-mail informado é inválido. Verifique e tente novamente."
        }
    }
}
