//
//  RumContactUsError.swift
//  CleanCode
//
//  Created by Rayana Prata Neves on 15/02/25.
//

import Foundation

enum RumContactUsError: Error {
    case networkError
    case decodingError
    case invalidResponse
    
    var localizedDescription: String {
        switch self {
        case .networkError:
            return "Erro de rede."
        case .decodingError:
            return "Falha ao decodificar os dados."
        case .invalidResponse:
            return "Resposta inválida."
        }
    }
    
    var shouldDismiss: Bool {
        switch self {
        case .networkError, .decodingError:
            return false
        case .invalidResponse:
            return true
        }
    }
    
    var logMessage: String {
        switch self {
        case .networkError:
            return "Network error."
        case .decodingError:
            return "Decoding error: Failed to decode data."
        case .invalidResponse:
            return "Invalid response from server."
        }
    }
}
