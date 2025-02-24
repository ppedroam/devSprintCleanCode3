import UIKit

final class LuzLoginViewModel {
    func setupDebugConfiguration(
        for emailTextField: UITextField,
        passwordTextField: UITextField
    ) {
        #if DEBUG
        emailTextField.text = "clean.code@devpass.com"
        passwordTextField.text = "111111"
        #endif
    }

    func validateSession(completion: @escaping () -> Void) {
        guard UserDefaultsManager.UserInfos.shared.readSesion() != nil else { return }
        completion()
    }

    func checkConnectionInternet(
        completion: @escaping (UIAlertController) -> Void
    ) {
        if !ConnectivityManager.shared.isConnected {
            let alertController = UIAlertController(
                title: "Sem conexão",
                message: "Conecte-se à internet para tentar novamente",
                preferredStyle: .alert
            )
            let alertAction = UIAlertAction(
                title: "Ok",
                style: .default
            )
            alertController.addAction(alertAction)
            completion(alertController)
        }
    }

    func login(
        email: String?,
        password: String?
    ) async throws -> Data {
        return await withCheckedContinuation { continuation in
            AF.shared.request(
                Endpoints.Auth.login,
                method: .get,
                parameters: makeParams(email: email, password: password),
                headers: nil
            ) { result in
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(with: .failure(error as! Never))
                }
            }
        }
    }

    func makeParams(
        email: String?,
        password: String?
    ) -> [String: String] {
        guard
            let email,
            let password
        else { return [:] }

        return [
            "email": email,
            "password": password
        ]
    }

    func handleLoginSuccess(data: Data) throws {
        let session = try JSONDecoder().decode(Session.self, from: data)
        UserDefaultsManager.UserInfos.shared.save(session: session, user: nil)
    }

    func validateButton(
        email: String?,
        enable: @escaping () -> Void,
        disable: @escaping () -> Void
    ) {
        do {
            try LuzLoginEmailValidator.validate(email)
            enable()
        } catch {
            disable()
        }
    }
}
