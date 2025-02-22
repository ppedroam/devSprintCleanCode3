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
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchData() {
        self.viewController?.callLoadingView()
        let url = Endpoints.contactUs
        let solContactUsRequest: NetworkRequest = SolContactUsRequest()
        networkManager.request(solContactUsRequest) { [weak self] (result: Result<Data, Error>) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.viewController?.callRemoveLoadingView()
            }
            switch result {
            case .success(let data):
                self.decodeData(data: data)
            case .failure(_):
                DispatchQueue.main.async {
                    self.viewController?.displayAlertMessage(title: "Ops..", message: "Ocorreu algum erro", dissmiss: true)
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
        let solContactSendMessageRequest: NetworkRequest = SolContactSendMessageRequest()
        networkManager.request(solContactSendMessageRequest) { [weak self] (result: Result<Data, Error>) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.viewController?.callRemoveLoadingView()
            }
            switch result {
            case .success:
                self.viewController?.displayAlertMessage(title: "Sucesso..", message: "Sua mensagem foi enviada", dissmiss: true)
            case .failure(let error):
                print("error api: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.viewController?.displayGlobalAlertMessage()
                }
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
