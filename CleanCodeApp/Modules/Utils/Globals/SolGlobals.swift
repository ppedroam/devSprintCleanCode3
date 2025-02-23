//
//  SolGlobals.swift
//  CleanCode
//
//  Created by Ely Assumpcao Ndiaye on 23/02/25.
//

import UIKit

protocol SolGlobalsAlertableProtocol {
    func showAlertMessage(title: String, message: String, targetVC: UIViewController, action: (() -> Void)?)
    func showNoInternetCOnnection(controller: UIViewController)
}

extension SolGlobalsAlertableProtocol {
    func showAlertMessage(title: String, message: String, targetVC: UIViewController, action: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: CeuResetPasswordStrings.ok.localized(), style: .default, handler: { _ in
            action?()
        }))
        targetVC.present(alert, animated: true, completion: nil)
    }

    func showNoInternetCOnnection(controller: UIViewController) {
        let alertController = UIAlertController(title: CeuResetPasswordStrings.noConnection.localized(), message: CeuResetPasswordStrings.connectToInternetErroMessage.localized(), preferredStyle: .alert)
        let action = UIAlertAction(title: CeuResetPasswordStrings.ok.localized(), style: .default)
        alertController.addAction(action)
        controller.present(alertController, animated: true)
    }
}

