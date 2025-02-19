//
//  CeuResetPasswordCoordinator.swift
//  CleanCodeApp
//
//  Created by Jorge de Carvalho on 10/02/25.
//

import UIKit

protocol CeuResetPasswordCoordinatorProtocol {
    var viewController: UIViewController? { get set }
    func showContactUsViewController()
    func showCreateAccountViewController()
    func showAlert()
    func showAlertWith(message: String)
    func showNoInternetConnectionAlert()
}

struct CeuResetPasswordCoordinator: CeuResetPasswordCoordinatorProtocol, CeuGlobalsProtocol {
    weak var viewController: UIViewController?

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

    func showAlertWith(message: String) {
        guard let viewController = viewController else { return }
        return self.alertMessage(title: "Ops...", message: message, targetVC: viewController, action: nil)
    }

    func showNoInternetConnectionAlert() {
        guard let viewController = viewController else { return }
        self.showNoInternetCOnnection(controller: viewController)
    }
}
