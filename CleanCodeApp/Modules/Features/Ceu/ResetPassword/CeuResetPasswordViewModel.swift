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

    func setupStatusFor(email: String?) -> Bool {
        guard let email = email else { return false }
        let emailIsEmpty = email.isEmpty
        let status = emailIsEmpty ||
        !email.contains(".") ||
        !email.contains("@") ||
        email.count <= 5

        return status
    }

    func startRecoverPassword() {
        guard let viewController = viewController else { return }

        do {
            try viewController.validateForm()
            try verifyInternetConnection()

            let parameters = try setupResetPasswordRequestParameters(email: viewController.emailTextfield?.text)
            makeResetPasswordRequest(parameters: parameters)
        } catch CeuCommonsErrors.invalidEmail {
            showAlertWith(message: "Verifique o e-mail informado.")
        } catch {
            showAlertWith(message: "Algo de errado aconteceu. Tente novamente mais tarde.")
        }
    }

    func setupResetPasswordRequestParameters(email: String?) throws -> [String: String] {
        guard let email = email else { throw CeuCommonsErrors.invalidData }

        let emailUser = email.trimmingCharacters(in: .whitespaces)
        let parameters = [
            "email": emailUser
        ]

        return parameters
    }

    func showAlertWith(message: String) {
        guard let viewController = viewController else { return }
        return Globals.alertMessage(title: "Ops...", message: message, targetVC: viewController)
    }

    func verifyInternetConnection() throws {
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
