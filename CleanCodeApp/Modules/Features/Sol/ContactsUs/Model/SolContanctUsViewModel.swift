//
//  SolContanctUsViewModel.swift
//  CleanCode
//
//  Created by Ely Assumpcao Ndiaye on 03/02/25.
//

import Foundation
// TODO
protocol SolContactUsProtocol: AnyObject {
    func showLoadingView2()
    func removeLoadingView2()
    func showMessageModel(result: ContactUsModel)
    func showAnyErrorOcurres()
    func errorMessage(message: String)
}

class SolContactUsViewModel {
    
    weak var viewController: SolContactUsProtocol?
    
    func fetchData() {
        self.viewController?.showLoadingView2()
        let url = Endpoints.contactUs
        AF.shared.request(url, method: .get, parameters: nil, headers: nil) { [weak self] result in
            self?.viewController?.removeLoadingView2()
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let returned = try? decoder.decode(ContactUsModel.self, from: data) {
                    self?.viewController?.showMessageModel(result: returned)
                } else {
                    self?.viewController?.showAnyErrorOcurres()

                    }
            case .failure(let error):
                print("error api: \(error.localizedDescription)")
                self?.viewController?.errorMessage(message: error.localizedDescription)
            }
        }
    }
    
    
}
