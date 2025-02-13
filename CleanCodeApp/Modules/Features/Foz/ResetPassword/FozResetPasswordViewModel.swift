//
//  FozResetPasswordVM.swift
//  CleanCodeApp
//
//  Created by Alexandre César Brandão de Andrade on 11/02/25.
//

import Foundation

class FozResetPasswordViewModel: ResetPasswordManaging {

    var onPasswordResetSuccess: ((String) -> Void)?
    var onPasswordResetFailure: ((String) -> Void)?

    private let resetPasswordService: ResetPasswordServicing
    private let emailValidator: EmailValidating

    init(resetPasswordService: ResetPasswordServicing, emailValidator: EmailValidating) {
        self.resetPasswordService = resetPasswordService
        self.emailValidator = emailValidator
    }

    func performPasswordReset(withEmail email: String?) {
        guard let email = email?.trimmingCharacters(in: .whitespaces), !email.isEmpty else {
             onPasswordResetFailure?("Informe um e-mail válido")
             return
         }

        if !isEmailValid(email){
            onPasswordResetFailure?("E-mail inválido")
            return
        }

        guard ConnectivityManager.shared.isConnected else {
            onPasswordResetFailure?("Sem conexão com a internet")
            return
        }

        let parameters = ["email": email]

        resetPasswordService.performPasswordReset(with: parameters) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.onPasswordResetSuccess?(email)
                } else {
                    self?.onPasswordResetFailure?("Falha ao recuperar a senha.")
                }
            }
        }
    }
    

    func isEmailValid(_ email: String?) -> Bool {
        return emailValidator.isValid(email)
    }
}
