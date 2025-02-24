import UIKit

protocol LuzResetPasswordViewModelDelegate: AnyObject {
    func showError(_ message: String)
    func showSuccess()
}

final class LuzResetPasswordViewModel {
    weak var delegate: LuzResetPasswordViewModelDelegate?

    func recoverPassword(
        from viewController: UIViewController,
        email: String
    ) {
        do {
            try FormValidator.validateEmail(email)
            try ConnectivityValidator.checkInternetConnection()

        } catch {
            handleError(error)
            return
        }

        BadNetworkLayer.shared.resetPassword(
            viewController,
            parameters: ["email": email]
        ) { success in
            success ? self.delegate?.showSuccess() : self.delegate?.showError(
                "Algo de errado aconteceu. Tente novamente mais tarde."
            )
        }
    }

    private func handleError(_ error: Error) {
        let errorMessage: String
        switch error {
        case ValidationError.emptyEmail:
            errorMessage = "E-mail não pode estar vazio"
        case ValidationError.invalidFormat:
            errorMessage = "Verifique o email informado"
        case ConnectivityError.noInternet:
            errorMessage = "Sem conexão com a internet"
        default:
            errorMessage = "Ocorreu um erro inesperado"
        }
        delegate?.showError(errorMessage)
    }
}
