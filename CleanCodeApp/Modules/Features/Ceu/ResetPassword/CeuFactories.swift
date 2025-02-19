//
//  CeuFactories.swift
//  CleanCodeApp
//
//  Created by Jorge de Carvalho on 13/02/25.
//
import UIKit

enum CeuResetPasswordFactory {
    static func make() -> UIViewController {
        let storyboard = UIStoryboard(name: "CeuUser", bundle: nil)

        let ceuResetPasswordViewModel = CeuResetPasswordViewModel()
        let ceuResetPasswordCoordinator = CeuResetPasswordCoordinator()

        let ceuResetPasswordViewController = storyboard.instantiateViewController(identifier: "CeuResetPasswordViewController") { coder in
            CeuResetPasswordViewController(
                coder: coder,
                ceuResetPasswordViewModel: ceuResetPasswordViewModel,
                ceuResetPasswordCoordinator: ceuResetPasswordCoordinator
            )
        }
        ceuResetPasswordViewController.modalPresentationStyle = .fullScreen

        ceuResetPasswordCoordinator.viewController = ceuResetPasswordViewController
        ceuResetPasswordViewModel.delegate = ceuResetPasswordViewController

        return ceuResetPasswordViewController
    }
}
