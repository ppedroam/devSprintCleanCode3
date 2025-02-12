//
//  Untitled.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 10/02/25.
//

import UIKit

protocol LuaResetPasswordViewModelProtocol {
    func validateEmailFormat(inputedEmail: String) -> Bool
    func presentLuaContactUSViewController(viewController: UIViewController)
    func presentLuaCreateAccountViewController(viewController: UIViewController)
}

final class LuaResetPasswordViewModel: LuaResetPasswordViewModelProtocol {
    
    private let alertHandler: LuaAlertErrorHandlerProtocol
    private var luaBasicCoordinator: LuaCoordinatorProtocol // need to refactor
    
    init(alertHandler: LuaAlertErrorHandlerProtocol, luaBasicCoordinator: LuaCoordinatorProtocol) {
        self.alertHandler = alertHandler
        self.luaBasicCoordinator = luaBasicCoordinator
    }
    
    func startPasswordResetRequest(targetViewController: UIViewController, emailInputted: String, completion: @escaping (Bool) -> Void) {
        do {
            try validateConnectivity(emailInputted: emailInputted)
            
            let passwordParameters = makePasswordResetParams(inputedEmail: emailInputted)
            sendPasswordResetRequest(targetViewController: targetViewController, parameters: passwordParameters)
            completion(true)
        } catch let error as LuaConnectivityError {
            alertHandler.handle(error: error, from: targetViewController, alertTitle: error.errorTitle)
            completion(false)
        } catch {
            alertHandler.handle(error: error, from: targetViewController, alertTitle: "Algo de errado aconteceu. Tente novamente mais tarde.")
            completion(false)
        }
    }
    
    private func sendPasswordResetRequest(targetViewController: UIViewController, parameters: [String : String]) {
        BadNetworkLayer.shared.resetPassword(targetViewController, parameters: parameters) { succes in // need to refactor
            if succes {
                
            }
            // show alert
        }
    }
    
    private func makePasswordResetParams(inputedEmail: String) -> [String : String] {
        let passwordResetParameters = [
            "email": inputedEmail
        ]
        return passwordResetParameters
    }
    
    private func validateConnectivity(emailInputted: String) throws {
        guard ConnectivityManager.shared.isConnected else {
            throw LuaConnectivityError.noInternetConnection
        }
    }
    
    func validateEmailFormat(inputedEmail: String) -> Bool {
        let isEmailFormatValid = inputedEmail.contains(".") &&
        inputedEmail.contains("@") &&
        inputedEmail.count > 5
        return isEmailFormatValid
    }
    
    func presentLuaContactUSViewController(viewController: UIViewController) {
        luaBasicCoordinator.viewController = viewController
        luaBasicCoordinator.openLuaContactUsScreen()
    }
    
    func presentLuaCreateAccountViewController(viewController: UIViewController) {
        luaBasicCoordinator.viewController = viewController
        luaBasicCoordinator.openLuaCreateAccountScreen()
    }
}

