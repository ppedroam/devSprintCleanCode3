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
    private let networkLayer: CeuBadNetworkLayerProtocol

    init(networkLayer: CeuBadNetworkLayerProtocol = CeuBadNetworkLayer()) {
        self.networkLayer = networkLayer
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
        networkLayer.resetPassword(delegate, parameters: parameters) { (success) in
            if success {
                self.delegate?.handleResetPasswordRequestSuccess()
                return
            }
            self.delegate?.handleResetPasswordRequestError()
        }
    }
}

