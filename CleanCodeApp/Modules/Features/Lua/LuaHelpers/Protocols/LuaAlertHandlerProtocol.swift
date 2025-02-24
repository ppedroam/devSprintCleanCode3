//
//  LuaAlert.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 11/02/25.
//

import UIKit

public protocol LuaAlertHandlerProtocol {
    func showAlert(alertTitle: String?, message: String, style: UIAlertController.Style)
    func showAlertError(error: Error, alertTitle: String?, style: UIAlertController.Style)
}

extension LuaAlertHandlerProtocol where Self: UIViewController {
    
    public func showAlertError(error: Error, alertTitle: String? = "Error", style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(
            title: alertTitle,
            message: error.localizedDescription,
            preferredStyle: style
        )
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
    
    public func showAlert(alertTitle: String?, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(
            title: alertTitle,
            message: message,
            preferredStyle: style
        )
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
}
