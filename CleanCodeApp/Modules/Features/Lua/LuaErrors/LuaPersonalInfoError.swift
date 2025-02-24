//
//  LuaPersonalInfoError.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 15/02/25.
//

public enum LuaPersonalInfoError: Error {
    case invalidPhoneNumber
    case invalidMail
}

extension LuaPersonalInfoError {
    var errorTitle: String? {
        switch self {
        case .invalidMail:
            return "Email inválido"
        case .invalidPhoneNumber:
            return "Número de telefone inválido"
        }
    }
}
