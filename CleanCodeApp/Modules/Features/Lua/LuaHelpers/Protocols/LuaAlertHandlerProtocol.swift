//
//  LuaAlert.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 11/02/25.
//

import UIKit

public protocol LuaAlertHandlerProtocol {
    func showAlertError(error: Error, from viewController: UIViewController, alertTitle: String?, style: UIAlertController.Style?)
}

extension LuaAlertHandlerProtocol {
    public func showAlertError(error: Error, from viewController: UIViewController, alertTitle: String?, style: UIAlertController.Style? = nil) {
        let alertController = UIAlertController(title: alertTitle, message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        viewController.present(alertController, animated: true)
    }
}
