//
//  CeuResetPasswordViewModel.swift
//  CleanCodeApp
//
//  Created by Jorge de Carvalho on 10/02/25.
//
import UIKit

protocol CeuResetPasswordViewModelDelegate where Self: UIViewController {
    func handleResetPasswordRequestSuccess()
    func handleResetPasswordRequestError()
    func validateForm() throws
    func showAlertWith(message: String)
    func showNoInternetConnectionAlert()
}

protocol CeuResetPasswordViewModelProtocol {
    var delegate: CeuResetPasswordViewModelDelegate? { get set }
    func startRecoverPasswordWith(email: String?)
}

class CeuResetPasswordViewModel: CeuResetPasswordViewModelProtocol {
    weak var delegate: CeuResetPasswordViewModelDelegate?
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    func startRecoverPasswordWith(email: String?) {
        do {
            try delegate?.validateForm()
            try verifyInternetConnection()

            let parameters = try setupResetPasswordRequestParameters(email: email)
            makeResetPasswordRequest(parameters: parameters)
        } catch CeuCommonsErrors.invalidEmail {
            delegate?.showAlertWith(message: "Verifique o e-mail informado.")
        } catch {
            delegate?.showAlertWith(message: "Algo de errado aconteceu. Tente novamente mais tarde.")
        }
    }
}

private extension CeuResetPasswordViewModel {
    func setupResetPasswordRequestParameters(email: String?) throws -> [String: String] {
        guard let email = email else { throw CeuCommonsErrors.invalidData }

        let emailUser = email.trimmingCharacters(in: .whitespaces)
        let parameters = [
            "email": emailUser
        ]

        return parameters
    }

    func verifyInternetConnection() throws {
        if !ConnectivityManager.shared.isConnected {
            delegate?.showNoInternetConnectionAlert()
            throw CeuCommonsErrors.networkError
        }
    }

    func makeResetPasswordRequest(parameters: [String : String]) {
        guard let delegate = delegate else { return }
        var resetPasswordRequest: NetworkRequest = ResetPasswordRequest()

        networkManager.request(resetPasswordRequest) { (result: Result<ResetPasswordResponse, Error>) in
            switch result {
            case .success(_):
                self.delegate?.handleResetPasswordRequestSuccess()
            case .failure(_):
                self.delegate?.handleResetPasswordRequestError()
            }
        }
//        networkLayer.resetPassword(delegate, parameters: parameters) { (success) in
//            if success {
//                self.delegate?.handleResetPasswordRequestSuccess()
//                return
//            }
//            self.delegate?.handleResetPasswordRequestError()
//        }
    }
}

struct ResetPasswordResponse: Decodable {
    let success: Bool
    let message: String?
}

class ResetPasswordRequest: NetworkRequest {
    var pathURL: String = ""
    var method: HTTPMethod = .get
}
