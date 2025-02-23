//
//  SolNetworkManager.swift
//  CleanCode
//
//  Created by Ely Assumpcao Ndiaye on 22/02/25.
//

import Foundation

class SolNetworkManager: Networking {
    func request(_ url: String, method: Methods, parameters: [String: String]?, headers: [String: String]?, completion: @escaping ((Result<Data, Error>) -> Void)) {
        switch url {
        case Endpoints.Auth.login:
            if let email = parameters?["email"],
               let password = parameters?["password"],
               email == "clean.code@devpass.com" && password == "123456" {

                let session = Session(id: UUID.init().uuidString, token: UUID.init().uuidString)
                let data = try? JSONEncoder().encode(session)
                if let data = data {
                    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                        completion(.success(data))
                    }
                } else {
                    completion(.failure(ServiceErros.invalidData))
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    completion(.failure(ServiceErros.invalidData))
                }
            }

        case Endpoints.contactUs:
            let contacUsModel = ContactUsModel(whatsapp: "37998988822",
                                               phone: "08001234567",
                                               mail: "cleanCode@devPass.com")
            let data = try? JSONEncoder().encode(contacUsModel)
            if let data = data {
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    completion(.success(data))
                }
            } else {
                completion(.failure(ServiceErros.invalidData))
            }

        case Endpoints.sendMessage:
            if let data = "sucesso".data(using: .utf8) {
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    completion(.success(data))
                }
            } else {
                completion(.failure(ServiceErros.invalidData))
            }
        case Endpoints.Auth.resetPassword:
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                completion(.success(Data()))
            }
        case Endpoints.Auth.createUser:
            let session = Session(id: UUID.init().uuidString, token: UUID.init().uuidString)
            let data = try? JSONEncoder().encode(session)
            if let data = data {
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    completion(.success(data))
                }
            } else {
                completion(.failure(ServiceErros.invalidData))
            }

        default:
            completion(.failure(ServiceErros.failure))
        }
    }
}
