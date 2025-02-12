//
//  CeuResetPasswordCoordinator.swift
//  CleanCodeApp
//
//  Created by Jorge de Carvalho on 10/02/25.
//

import UIKit
struct CeuResetPasswordCoordinator {
    weak var viewController: UIViewController?

    func setupContactUsViewController() {
        let viewController = CeuContactUsViewController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .coverVertical
        viewController.present(viewController, animated: true, completion: nil)
    }

    func setupCreateAccountViewController() {
        let viewController = CeuCreateAccountViewController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.present(viewController, animated: true)
    }

    func showAlert() {
        let alertController = UIAlertController(title: "Ops..", message: "Algo de errado aconteceu. Tente novamente mais tarde.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        self.viewController?.present(alertController, animated: true)
    }
}
