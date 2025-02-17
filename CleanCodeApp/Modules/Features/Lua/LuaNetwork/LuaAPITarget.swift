//
//  APITarget.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 15/02/25.
//

import Foundation

public enum LuaAPIAuthTarget {
    case login
    case createUser
    case resetPassword
}

public enum LuaAPITarget {
    case authTarget(LuaAPIAuthTarget)
    case getContactUsData
    case sendContactUsMessage([String: Any])
    
    private var baseURL: URL! {
        switch self {
        case .sendContactUsMessage, .getContactUsData:
            return URL(string: "www.apiQualquer.com")
        case .authTarget(let authTarget):
            switch authTarget{
            case .createUser, .login:
                return URL(string: "www.aplicandoCleanCode.muito.foda")
            case .resetPassword:
                return URL(string: "www.aplicandocleancodedemaneirafodastico.com")
            }
        }
    }
    
    private var path: String {
        switch self {
        case .getContactUsData:
            return "/contactUs"
        case .sendContactUsMessage:
            return "/sendMessage"
        case .authTarget(let authTarget):
            switch authTarget{
            case .createUser:
                return "/create"
            case .login:
                return "/login"
            case .resetPassword:
                return "/resetPassword"
            }
        }
    }
    
    var method: String {
        switch self {
        case .getContactUsData:
            return "GET"
        case .sendContactUsMessage:
            return "POST"
        default:
            return "GET"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
            
        case .sendContactUsMessage(let params):
            return params
        default:
            return [:]
        }
    }
    
    var headers: [String: String] {
        return ["Content-Type": "application/json"]
    }
    
    public var url: URL {
        return baseURL.appendingPathComponent(path)
    }
    
    var dummyData: Data {
        switch self {
        case .authTarget(.login):
            let session = Session(id: UUID().uuidString, token: UUID().uuidString)
            return try! JSONEncoder().encode(session)
            
        case .authTarget(.createUser):
            let session = Session(id: UUID().uuidString, token: UUID().uuidString)
            return try! JSONEncoder().encode(session)
            
        case .authTarget(.resetPassword):
            return Data()
            
        case .getContactUsData:
            let contact = ContactUsModel(
                whatsapp: "37998988822",
                phone: "08001234567",
                mail: "cleanCode@devPass.com"
            )
            return try! JSONEncoder().encode(contact)
            
        case .sendContactUsMessage(let params):
            
            let email = params["email"] as? String ?? "email_nao_informado"
            let mensagem = params["mensagem"] as? String ?? "mensagem_nao_informada"
            
            let response = [
                "message": "sucesso",
                "email": email,
                "mensagem": mensagem
            ]
            
            return try! JSONEncoder().encode(response)
        }
    }
}

