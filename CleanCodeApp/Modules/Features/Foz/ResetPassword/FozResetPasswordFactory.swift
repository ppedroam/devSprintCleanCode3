//
//  FozResetPasswordFactory.swift
//  CleanCodeApp
//
//  Created by Alexandre César Brandão de Andrade on 11/02/25.
//

import UIKit


final class FozResetPasswordFactory: FozResetPasswordFactorying {

    func make() -> UIViewController {
         let resetPasswordVC = FozResetPasswordFactory().createResetPasswordViewController()

        let coordinator = FozResetPasswordCoordinator()
        coordinator.viewController = resetPasswordVC

        return resetPasswordVC
     }

    func createResetPasswordViewController() -> UIViewController {

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


