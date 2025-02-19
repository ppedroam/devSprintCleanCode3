//
//  RioCommonErrors.swift
//  CleanCode
//
//  Created by thaisa on 17/02/25.
//

import Foundation

enum RioCommonErrors: Error {
    case noInternet
    case invalidEmail
    
    var alertDescription: String {
        switch self {
        case .noInternet:
            return "Você não tem conexão no momento."
        case .invalidEmail:
            return "O e-mail informado é inválido."
        }
    }
}
