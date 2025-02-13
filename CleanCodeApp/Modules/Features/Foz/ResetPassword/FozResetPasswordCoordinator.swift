//
//  FozResetPasswordCoordinator.swift
//  CleanCodeApp
//
//  Created by Alexandre César Brandão de Andrade on 11/02/25.
//

import UIKit
import Foundation

final class FozResetPasswordCoordinator: Coordinating {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }


    func make(){
        let resetPasswordVC = FozResetPasswordFactory().createResetPasswordViewController()
        resetPasswordVC.coordinator = self
        navigationController.pushViewController(resetPasswordVC, animated: true)
        
    }

    func showContactUs() {
        let contactUsVC = FozContactUsViewController()
        contactUsVC.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(contactUsVC, animated: true)
    }

    func showCreateAccount() {
        let createAccountVC = FozCreateAccountViewController()
        createAccountVC.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(createAccountVC, animated: true)
    }
}
