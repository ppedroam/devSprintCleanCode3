//
//  SolContanctUsViewModel.swift
//  CleanCode
//
//  Created by Ely Assumpcao Ndiaye on 03/02/25.
//

import Foundation
protocol SolContactUsViewModelProtocol: AnyObject {
    func fetchData()
    func requestSendMessage(parameters:[ String: String])
}

class SolContactUsViewModel: SolContactUsViewModelProtocol {
    
    weak var viewController: SolContactUsProtocol?
    private let networkManager: Networking
    
    init(networkManager: Networking = SolNetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchData() {
        self.viewController?.callLoadingView()
        Task {
            let _: () = await fetchContactUsData()
        }
        
    }
    
    private func fetchContactUsData() async -> () {
        let url = Endpoints.contactUs
        return await withCheckedContinuation{ continuation in
            networkManager.request(url, method: .get, parameters: nil, headers: nil) { [weak self] result in
                guard let self = self else {return}
                self.viewController?.callRemoveLoadingView()
                switch result {
                case .success(let data):
                    continuation.resume(returning: self.decodeData(data: data))
                case .failure(let error):
                    print("error api: \(error.localizedDescription)")
                    continuation.resume(returning: self.viewController?.displayAlertMessage(
                        title: "Ops..",
                        message: "Ocorreu algum erro",
                        dissmiss: true) ?? ())
                }
            }
        }
    }
    
    private func decodeData(data: Data) {
        do {
            let decoder = JSONDecoder()
            let returned = try decoder.decode(ContactUsModel.self, from: data)
            viewController?.showMessageReturnModel(result: returned)
        } catch {
            self.viewController?.displayAlertMessage(title: "Ops..", message: "Ocorreu algum erro", dissmiss: true)
        }
    }
    
    func requestSendMessage(parameters:[ String: String]) {
        let url = Endpoints.sendMessage
        networkManager.request(url, method: .post, parameters: parameters, headers: nil) { [weak self]  result in
            guard let self = self else {return}
            self.viewController?.callRemoveLoadingView()
            switch result {
            case .success:
                self.viewController?.displayAlertMessage(title: "Sucesso..", message: "Sua mensagem foi enviada", dissmiss: true)
            case .failure:
                self.viewController?.displayGlobalAlertMessage()
            }
        }
    }
}

struct SolContactUsRequest: NetworkRequest {
    var baseURL: String = "www.apiQualquer.com"
    var pathURL: String = "contactUs"
    var method: HTTPMethod = .get
    
}

struct SolContactSendMessageRequest: NetworkRequest {
    var baseURL: String = "www.apiQualquer.com"
    var pathURL: String = "sendMessage"
    var method: HTTPMethod = .post
    
}
