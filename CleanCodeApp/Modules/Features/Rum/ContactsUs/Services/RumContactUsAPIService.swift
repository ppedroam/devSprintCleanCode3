//
//  RumContactUsAPIService .swift
//  CleanCode
//
//  Created by Rayana Prata Neves on 11/02/25.
//

import Foundation

protocol RumContactUsAPIServiceDelegate: AnyObject {
    func showAlertMessage(title: String, message: String, shouldDismiss: Bool)
}

protocol RumContactAPIServicing {
    func fetchContactUsData() async throws -> ContactUsModel
    func sendMessage(parameters: [String: String]) async throws
}

final class RumContactUsAPIService: RumContactAPIServicing {
    weak var delegate: RumContactUsAPIServiceDelegate?
    private let network: Networking
    
    init(delegate: RumContactUsAPIServiceDelegate? = nil, network: Networking = AF.shared) {
        self.delegate = delegate
        self.network = network
    }
    
    func fetchContactUsData() async throws -> ContactUsModel {
        let url = Endpoints.contactUs
        return await withCheckedContinuation { continuation in
            network.request(url, method: .get, parameters: nil, headers: nil) { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success(let data):
                    if let contactUsModel = self.decodeContactUsData(data) {
                        continuation.resume(returning: contactUsModel)
                    } else {
                        self.handleError(.decodingError)
                    }
                case .failure(_):
                    handleError(.networkError)
                }
            }
        }
    }
    
    private func decodeContactUsData(_ data: Data) -> ContactUsModel? {
        do {
            let decoder = JSONDecoder()
            let model = try decoder.decode(ContactUsModel.self, from: data)
            return model
        } catch {
            logError(error: .decodingError)
            return nil
        }
    }
    
    func sendMessage(parameters: [String: String]) async throws {
        let url = Endpoints.sendMessage
        return await withCheckedContinuation { continuation in
            network.request(url, method: .post, parameters: parameters, headers: nil) { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success:
                    self.handleSuccess()
                case .failure(_):
                    self.handleError(.networkError)
                }
            }
        }
    }
    
    private func handleError(_ error: RumContactUsError) {
        logError(error: error)
        
        let alertTitle = "Ops..."
        let alertMessage = error.localizedDescription
        let shouldDismiss = error.shouldDismiss
        
        delegate?.showAlertMessage(
            title: alertTitle,
            message: alertMessage,
            shouldDismiss: shouldDismiss
        )
    }
    
    private func handleSuccess() {
        let alertTitle = "Sucesso..."
        let alertMessage = "Sua mensagem foi enviada"
        let shouldDismiss = true
        
        delegate?.showAlertMessage(
            title: alertTitle,
            message: alertMessage,
            shouldDismiss: shouldDismiss
        )
    }
    
    private func logError(error: RumContactUsError) {
        print("Log error: \(error.logMessage)")
    }
}
