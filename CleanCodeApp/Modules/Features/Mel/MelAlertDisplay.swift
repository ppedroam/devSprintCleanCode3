//
//  MelAlertDisplay.swift
//  CleanCodeApp
//
//  Created by Bruno Moura on 23/02/25.
//

import UIKit

protocol MelAlertDisplayProtocol: AnyObject {
    func displaySuccessAlert(on viewController: UIViewController, completion: (() -> Void)?)
    func displayErrorAlert(on viewController: UIViewController, mustDismiss: Bool)
}

final class MelAlertDisplay: MelAlertDisplayProtocol {
    func displaySuccessAlert(on viewController: UIViewController, completion: (() -> Void)?) {
        let alert = UIAlertController(
            title: MelContactUsStrings.successAlertTitle.rawValue,
            message: MelContactUsStrings.successAlertMessage.rawValue,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        
        alert.addAction(okAction)
        viewController.present(alert, animated: true)
    }
    
    func displayErrorAlert(on viewController: UIViewController, mustDismiss: Bool) {
        let alert = UIAlertController(
            title: MelContactUsStrings.errorAlertTitle.rawValue,
            message: MelContactUsStrings.errorAlertMessage.rawValue,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            if mustDismiss {
                viewController.dismiss(animated: true)
            }
        }
        
        alert.addAction(okAction)
        viewController.present(alert, animated: true)
    }
}
