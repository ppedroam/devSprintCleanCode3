//
//  APITarget.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 15/02/25.
//

import Foundation

public protocol LuaAPIEndpointProtocol {
    var baseURL: URL { get }
    var path: String { get }
    var method: String { get }
    var parameters: [String: Any] { get }
    var headers: [String: String] { get }
    var dummyData: Data { get }
}

extension LuaAPIEndpointProtocol {
    var url: URL {
        baseURL.appendingPathComponent(path)
    }
}


enum LuaContactUsAPITarget: LuaAPIEndpointProtocol {
    case getContactUsData
    case sendContactUsMessage([String: Any])
    
    var baseURL: URL {
        URL(string: "https://www.apiQualquer.com")!
    }
    
    var path: String {
        switch self {
        case .getContactUsData: return "/contactUs"
        case .sendContactUsMessage: return "/sendMessage"
        }
    }
    
    var method: String {
        switch self {
        case .getContactUsData: return "GET"
        case .sendContactUsMessage: return "POST"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .getContactUsData: return [:]
        case .sendContactUsMessage(let params): return params
        }
    }
    
    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }
    
    var dummyData: Data {
        switch self {
        case .getContactUsData:
            let contact = ContactUsModel(
                whatsapp: "37998988822",
                phone: "08001234567",
                mail: "cleanCode@devPass.com"
            )
            return try! JSONEncoder().encode(contact)
            
        case .sendContactUsMessage(let params):
            let response = [
                "status": "success",
                "email": params["email"] as? String ?? "",
                "message": params["message"] as? String ?? ""
            ]
            return try! JSONEncoder().encode(response)
        }
    }
}

enum LuaAuthAPITarget: LuaAPIEndpointProtocol {
    case login
    case createUser([String: String?])
    case resetPassword([String: String])
    case loginWithSession(Session)
    
    var baseURL: URL {
        switch self {
        case .login, .createUser, .loginWithSession:
            return URL(string: "https://www.authService.com")!
        case .resetPassword:
            return URL(string: "https://www.passwordService.com")!
        }
    }
    
    var path: String {
        switch self {
        case .login: return "/login"
        case .createUser: return "/create"
        case .resetPassword: return "/reset"
        case .loginWithSession: return "/session-login"
        }
    }
    
    var method: String {
        return "POST"
    }
    
    var parameters: [String: Any] {
        switch self {
        case .login: return [:]
        case .createUser(let params):
            return params.compactMapValues { $0 }
        case .resetPassword(let params):
            return params
        case .loginWithSession(let session):
            return [
                "session_id": session.id,
                "session_token": session.token
            ]
        }
    }
    
    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }
    
    var dummyData: Data {
        switch self {
        case .login, .createUser, .loginWithSession:
            return try! JSONEncoder().encode(
                Session(id: UUID().uuidString, token: UUID().uuidString)
            )
        case .resetPassword:
            return try! JSONEncoder().encode(
                ["status": "password_reset_email_sent"]
            )
        }
    }
}


//public enum LuaAPIAuthTarget {
//    case login
//    case createUser([String:String?])
//    case resetPassword([String:String])
//}

//public enum LuaAPITarget: LuaAPIUrlTargetProtocol {
//    case authTarget(LuaAPIAuthTarget)
//    case getContactUsData
//    case sendContactUsMessage([String: Any])
//
//    internal var baseURL: URL! {
//        switch self {
//        case .sendContactUsMessage, .getContactUsData:
//            return URL(string: "www.apiQualquer.com")
//        case .authTarget(let authTarget):
//            switch authTarget{
//            case .createUser, .login:
//                return URL(string: "www.aplicandoCleanCode.muito.foda")
//            case .resetPassword:
//                return URL(string: "www.aplicandocleancodedemaneirafodastico.com")
//            }
//        }
//    }
//
//    internal var path: String {
//        switch self {
//        case .getContactUsData:
//            return "/contactUs"
//        case .sendContactUsMessage:
//            return "/sendMessage"
//        case .authTarget(let authTarget):
//            switch authTarget{
//            case .createUser:
//                return "/create"
//            case .login:
//                return "/login"
//            case .resetPassword:
//                return "/resetPassword"
//            }
//        }
//    }
//
//    internal var method: String {
//        switch self {
//        case .getContactUsData:
//            return "GET"
//        case .sendContactUsMessage:
//            return "POST"
//        default:
//            return "GET"
//        }
//    }
//
//    internal var parameters: [String: Any] {
//        switch self {
//
//        case .sendContactUsMessage(let params):
//            return params
//        default:
//            return [:]
//        }
//    }
//
//    internal var headers: [String: String] {
//        return ["Content-Type": "application/json"]
//    }
//
//    var url: URL {
//        return baseURL.appendingPathComponent(path)
//    }
//
//    var dummyData: Data {
//        switch self {
//        case .authTarget(.login):
//            let session = Session(id: UUID().uuidString, token: UUID().uuidString)
//            return try! JSONEncoder().encode(session)
//
//        case .authTarget(.createUser):
//            let session = Session(id: UUID().uuidString, token: UUID().uuidString)
//            return try! JSONEncoder().encode(session)
//
//        case .authTarget(.resetPassword):
//            return Data()
//
//        case .getContactUsData:
//            let contact = ContactUsModel(
//                whatsapp: "37998988822",
//                phone: "08001234567",
//                mail: "cleanCode@devPass.com"
//            )
//            return try! JSONEncoder().encode(contact)
//
//        case .sendContactUsMessage(let params):
//
//            let email = params["email"] as? String ?? "email_nao_informado"
//            let mensagem = params["mensagem"] as? String ?? "mensagem_nao_informada"
//
//            let response = [
//                "message": "sucesso",
//                "email": email,
//                "mensagem": mensagem
//            ]
//
//            return try! JSONEncoder().encode(response)
//        }
//    }
//}

