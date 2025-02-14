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
        let ceuResetPasswordViewController = storyboard.instantiateViewController(withIdentifier: "CeuResetPasswordViewController") as! CeuResetPasswordViewController
        ceuResetPasswordViewController.modalPresentationStyle = .fullScreen

        let ceuResetPasswordViewModel = CeuResetPasswordViewModel()
        ceuResetPasswordViewModel.viewController = ceuResetPasswordViewController

        var ceuResetPasswordCoordinator = CeuResetPasswordCoordinator()
        ceuResetPasswordCoordinator.viewController = ceuResetPasswordViewController

        ceuResetPasswordViewController.ceuResetPasswordViewModel = ceuResetPasswordViewModel
        ceuResetPasswordViewController.ceuResetPasswordCoordinator = ceuResetPasswordCoordinator

        return ceuResetPasswordViewController
    }
}
