//
//  Untitled.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 10/02/25.
//

import UIKit

class LuaResetPasswordViewModel {
    
    private let alertHandler: LuaAlertErrorHandlerProtocol
    
    init(alertHandler: LuaAlertErrorHandlerProtocol) {
        self.alertHandler = alertHandler
    }
    
    func startPasswordResetRequest(targetViewController: UIViewController, emailInputted: String) {
        do {
            try validateConnectivity(emailInputted: emailInputted)
           
            let passwordParameters = makePasswordResetParams(inputedEmail: emailInputted)
            sendPasswordResetRequest(targetViewController: targetViewController, parameters: passwordParameters)
        } catch let error as LuaConnectivityError {
            alertHandler.handle(error: error, from: targetViewController, alertTitle: error.errorTitle)
        } catch {
            alertHandler.handle(error: error, from: targetViewController, alertTitle: "Algo de errado aconteceu. Tente novamente mais tarde.")
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
}

