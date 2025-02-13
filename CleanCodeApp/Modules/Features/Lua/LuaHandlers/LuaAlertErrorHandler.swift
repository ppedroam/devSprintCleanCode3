//
//  LuaAlert.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 11/02/25.
//

import UIKit

public protocol LuaAlertErrorHandlerProtocol {
    func handle(error: Error, from viewController: UIViewController, alertTitle: String?)
}

extension LuaAlertErrorHandlerProtocol {
    public func handle(error: Error, from viewController: UIViewController, alertTitle: String?) {
        let alertController = UIAlertController(title: alertTitle, message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        viewController.present(alertController, animated: true)
    }
}
