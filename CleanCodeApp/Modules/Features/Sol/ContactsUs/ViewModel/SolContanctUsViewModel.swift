//
//  SolContanctUsViewModel.swift
//  CleanCode
//
//  Created by Ely Assumpcao Ndiaye on 03/02/25.
//

import Foundation
// TODO


protocol SolContactUsViewModelProtocol: AnyObject {
 func fetchData()
 func requestSendMessage(parameters:[ String: String])
}

class SolContactUsViewModel: SolContactUsViewModelProtocol {
    
     weak var viewController: SolContactUsProtocol?
    
    func fetchData() {
        self.viewController?.callLoadingView()
        let url = Endpoints.contactUs
        AF.shared.request(url, method: .get, parameters: nil, headers: nil) { [weak self] result in
            guard let self = self else {return}
            self.viewController?.callRemoveLoadingView()
            switch result {
            case .success(let data):
                self.decodeData(data: data)
            case .failure(let error):
                print("error api: \(error.localizedDescription)")
                self.viewController?.displayAlertMessage(title: "Ops..", message: "Ocorreu algum erro", dissmiss: true)
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
        AF.shared.request(url, method: .post, parameters: parameters, headers: nil) { [weak self]  result in
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
