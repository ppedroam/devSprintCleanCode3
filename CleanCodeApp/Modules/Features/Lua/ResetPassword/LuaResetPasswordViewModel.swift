//
//  Untitled.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 10/02/25.
//

import UIKit

protocol LuaResetPasswordViewModelProtocol {
    func validateEmailFormat(inputedEmail: String) -> Bool
    func startPasswordResetRequest(targetViewController: UIViewController, emailInputted: String) async throws
}

final class LuaResetPasswordViewModel: LuaResetPasswordViewModelProtocol {

    func startPasswordResetRequest(targetViewController: UIViewController, emailInputted: String) async throws {
        do {
            try validateConnectivity(emailInputted: emailInputted)
            let passwordParameters = makePasswordResetParams(inputedEmail: emailInputted)
            sendPasswordResetRequest(targetViewController: targetViewController, parameters: passwordParameters)
        } catch _ as LuaNetworkError {
            throw LuaNetworkError.noInternetConnection
        } catch {
            throw LuaNetworkError.unknown
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
            throw LuaNetworkError.noInternetConnection
        }
    }
    
    func validateEmailFormat(inputedEmail: String) -> Bool {
        let isEmailFormatValid = inputedEmail.contains(".") &&
        inputedEmail.contains("@") &&
        inputedEmail.count > 5
        return isEmailFormatValid
    }
}

