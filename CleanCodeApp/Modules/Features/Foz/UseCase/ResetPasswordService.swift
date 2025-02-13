//
//  ResetPasswordService.swift
//  CleanCodeApp
//
//  Created by Alexandre César Brandão de Andrade on 11/02/25.
//
import Foundation
import UIKit


class ResetPasswordService: ResetPasswordServicing {

    private weak var presenter: UIViewController?

    init(presenter: UIViewController) {
        self.presenter = presenter
    }

    func performPasswordReset(with parameters: [String: String], completion: @escaping (Bool) -> Void) {
        guard let presenter = presenter else {
            completion(false)
            return
        }

        BadNetworkLayer.shared.resetPassword(presenter, parameters: parameters, completionHandler: completion)
    }
}
