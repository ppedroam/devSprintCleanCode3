//
//  CeuResetPasswordViewModel.swift
//  CleanCodeApp
//
//  Created by Jorge de Carvalho on 10/02/25.
//
import UIKit

class CeuResetPasswordViewModel {
    weak var viewController: CeuResetPasswordViewController?
    private let minimunCharactersQuantityForEmail = 5

    init(viewController: CeuResetPasswordViewController) {
        self.viewController = viewController
    }

    func verifyEmailValidation(email: String?) -> Bool {
        guard let email = email else { return false }
        let emailIsEmpty = email.isEmpty
        let emailDoestContainsDot = !email.contains(".")
        let emailDoestContainsAtSymbol = !email.contains("@")
        let emailDoesntHaveMinimunLength = email.count <= minimunCharactersQuantityForEmail

        let isEmailInvalid = emailIsEmpty || emailDoestContainsDot || emailDoestContainsAtSymbol || emailDoesntHaveMinimunLength

        return isEmailInvalid
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
