//
//  MelNetworkManager.swift
//  CleanCodeApp
//
//  Created by Bruno Moura on 22/02/25.
//

import Foundation

protocol MelNetworking {
    func request(_ url: String, method: Methods, parameters: [String: String]?, headers: [String: String]?) async throws -> Data
}

extension MelNetworking {
    func request(_ url: String, method: Methods, parameters: [String: String]?, headers: [String: String]? = nil) async throws -> Data {
        return try await request(url, method: method, parameters: parameters, headers: headers)
    }
}

final class MelNetworkManager: MelNetworking {
    func request(_ url: String, method: Methods, parameters: [String: String]?, headers: [String: String]?) async throws -> Data {
        switch url {
        case Endpoints.Auth.login:
            if let email = parameters?["email"],
               let password = parameters?["password"],
               email == "clean.code@devpass.com" && password == "123456" {
                
                let session = Session(id: UUID.init().uuidString, token: UUID.init().uuidString)
                guard let data = try? JSONEncoder().encode(session) else {
                    throw ServiceErros.invalidData
                }
                try await Task.sleep(nanoseconds: 2_000_000_000)
                return data
            } else {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                throw ServiceErros.invalidData
            }
            
        case Endpoints.contactUs:
            let contactUsModel = ContactUsModel(whatsapp: "37998988822",
                                                phone: "08001234567",
                                                mail: "cleanCode@devPass.com")
            guard let data = try? JSONEncoder().encode(contactUsModel) else {
                throw ServiceErros.invalidData
            }
            
            try await Task.sleep(nanoseconds: 2_000_000_000)
            return data
            
        case Endpoints.sendMessage:
            guard let data = "sucesso".data(using: .utf8) else {
                throw ServiceErros.invalidData
            }
            
            try await Task.sleep(nanoseconds: 2_000_000_000)
            return data
            
        case Endpoints.Auth.resetPassword:
            try await Task.sleep(nanoseconds: 2_000_000_000)
            return Data()
            
        case Endpoints.Auth.createUser:
            let session = Session(id: UUID().uuidString, token: UUID().uuidString)
            guard let data = try? JSONEncoder().encode(session) else {
                throw ServiceErros.invalidData
            }
            
            try await Task.sleep(nanoseconds: 2_000_000_000)
            return data
            
        default:
            throw ServiceErros.failure
        }
    }
}
