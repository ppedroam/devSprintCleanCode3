//
//  CeuResetPasswordViewModel.swift
//  CleanCodeApp
//
//  Created by Jorge de Carvalho on 10/02/25.
//
import UIKit

class CeuResetPasswordViewModel {
    weak var viewController: CeuResetPasswordViewController?

    init(viewController: CeuResetPasswordViewController) {
        self.viewController = viewController
    }

    func setupStatus(text: String?) -> Bool {
        guard let text = text else { return false }
        let status = text.isEmpty ||
        !text.contains(".") ||
        !text.contains("@") ||
        text.count <= 5

        return status
    }

    func startRecoverPassword() {
        guard let viewController = viewController else { return }

        do {
            try viewController.validateForm()
            try verifyInternet()

            let parameters = try setupResetPasswordRequestParameters(text: viewController.emailTextfield?.text)
            makeResetPasswordRequest(parameters: parameters)
        } catch CeuCommonsErrors.invalidEmail {
            showAlert(message: "Verifique o e-mail informado.")
        } catch {
            showAlert(message: "Algo de errado aconteceu. Tente novamente mais tarde.")
        }
    }

    func setupResetPasswordRequestParameters(text: String?) throws -> [String: String] {
        guard let text = text else { throw CeuCommonsErrors.invalidData }

        let emailUser = text.trimmingCharacters(in: .whitespaces)
        let parameters = [
            "email": emailUser
        ]

        return parameters
    }

    func showAlert(message: String) {
        guard let viewController = viewController else { return }
        return Globals.alertMessage(title: "Ops...", message: message, targetVC: viewController)
    }

    func verifyInternet() throws {
        guard let viewController = viewController else { return }
        if !ConnectivityManager.shared.isConnected {
            Globals.showNoInternetCOnnection(controller: viewController)
            throw CeuCommonsErrors.networkError
        }
    }

    func makeResetPasswordRequest(parameters: [String : String]) {
        guard let viewController = viewController else { return }
        BadNetworkLayer.shared.resetPassword(viewController, parameters: parameters) { (success) in
            if success {
                return viewController.handleResetPasswordRequestSuccess()
            }
            viewController.handleResetPasswordRequestError()
        }
    }
}
