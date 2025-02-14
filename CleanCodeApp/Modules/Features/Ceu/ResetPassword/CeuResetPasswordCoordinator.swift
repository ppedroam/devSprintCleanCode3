//
//  CeuResetPasswordCoordinator.swift
//  CleanCodeApp
//
//  Created by Jorge de Carvalho on 10/02/25.
//

import UIKit
struct CeuResetPasswordCoordinator {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func showContactUsViewController() {
        let ceuContactUsViewController = CeuContactUsViewController()
        ceuContactUsViewController.modalPresentationStyle = .fullScreen
        ceuContactUsViewController.modalTransitionStyle = .coverVertical
        self.viewController?.present(ceuContactUsViewController, animated: true, completion: nil)
    }

    func showCreateAccountViewController() {
        let ceuCreateAccountViewController = CeuCreateAccountViewController()
        ceuCreateAccountViewController.modalPresentationStyle = .fullScreen
        self.viewController?.present(ceuCreateAccountViewController, animated: true)
    }

    func showAlert() {
        let alertController = UIAlertController(title: "Ops..", message: "Algo de errado aconteceu. Tente novamente mais tarde.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        self.viewController?.present(alertController, animated: true)
    }
}
