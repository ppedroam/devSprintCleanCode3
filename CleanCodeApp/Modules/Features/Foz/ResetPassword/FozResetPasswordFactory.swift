//
//  FozResetPasswordFactory.swift
//  CleanCodeApp
//
//  Created by Alexandre César Brandão de Andrade on 11/02/25.
//

import UIKit


final class FozResetPasswordFactory: ResetPasswordFactorying {

    func createResetPasswordViewController() -> FozResetPasswordViewController {
        let storyboard = UIStoryboard(name: "FozUser", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "FozResetPasswordViewController") as? FozResetPasswordViewController else {
            fatalError("FozResetPasswordViewController não encontrado no Storyboard.")
        }

        let resetPasswordService = ResetPasswordService(presenter: viewController)
        let emailValidator = EmailValidatorUseCase()
        let viewModel = FozResetPasswordViewModel(resetPasswordService: resetPasswordService, emailValidator: emailValidator)
        viewController.viewModel = viewModel

        return viewController
    }
    
}


