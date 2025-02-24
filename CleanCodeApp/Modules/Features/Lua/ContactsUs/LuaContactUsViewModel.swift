//
//  LuaContactUsViewModel.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 15/02/25.
//

protocol LuaContactUsViewModelProtocol {
    var contactUsModel: ContactUsModel? { get }
    func sendMessage(message: String, mail: String) async throws
    func fetchContactUsData() async throws
}

final class LuaContactUsViewModel: LuaContactUsViewModelProtocol {
    
    private let networkManager: LuaNetworkManager
    public var contactUsModel: ContactUsModel?
    
    init(networkManager: LuaNetworkManager) {
        self.networkManager = networkManager
    }
    
    public func sendMessage(message: String, mail: String) async throws {
        do {
            let params = makeSendMessageParams(message: message, mail: mail)
            let response: [String: String] = try await networkManager.request(.sendContactUsMessage(params))
            print(response)
        } catch {
            print(error.localizedDescription)
            throw LuaNetworkError.anyUnintendedResponse
        }
    }
    
    public func fetchContactUsData() async throws {
        Task {
            do {
                contactUsModel = try await networkManager.request(.getContactUsData)
                print(contactUsModel)
            } catch {
                print(error.localizedDescription)
                throw LuaNetworkError.anyUnintendedResponse
            }
        }
    }
    
    private func makeSendMessageParams(message: String, mail: String) -> [String:String] {
        let params: [String: String] = [
            "email": mail,
            "mensagem": message
        ]
        return params
    }
}
