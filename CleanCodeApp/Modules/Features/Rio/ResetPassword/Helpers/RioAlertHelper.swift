//
//  RioAlertHelper.swift
//  CleanCode
//
//  Created by thaisa on 17/02/25.
//

import Foundation
import UIKit

class RioAlertHelper {
    
    static func showErrorAlert(on viewController: UIViewController, message: String) {
        let alert = UIAlertController(title: "Ops...", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
}
