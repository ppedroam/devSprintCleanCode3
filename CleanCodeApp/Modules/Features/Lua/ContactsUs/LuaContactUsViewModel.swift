//
//  LuaContactUsViewModel.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 15/02/25.
//


final class LuaContactUsViewModel {
    
    private let networkManager = LuaNetworkManager()
    
    
    func sendMessage(message: String, mail: String) throws {
        
        Task {
            do {
                let params = makeSendParams(message: message, mail: mail)
                let response: [String: String] = try await  networkManager.request(.sendContactUsMessage(params))
            } catch {
                throw error
            }
        }
    }
    
    private func makeSendParams(message: String, mail: String) -> [String:String] {
        let params: [String: String] = [
            "email": mail,
            "mensagem": message
        ]
        return params
    }
}
