//
//  Untitled.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 10/02/25.
//

import UIKit

protocol LuaResetPasswordViewModelProtocol {
    func validateEmailFormat(inputtedEmail: String) -> Bool
    func startPasswordReseting(targetViewController: UIViewController, emailInputted: String) async throws
}

final class LuaResetPasswordViewModel: LuaResetPasswordViewModelProtocol {
    
    private let networkManager: LuaNetworkManagerProtocol
    
    init(networkManager: LuaNetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func startPasswordReseting(targetViewController: UIViewController, emailInputted: String) async throws {
        do {
            try validateConnectivity()
            let passwordParameters = makePasswordResetParams(inputedEmail: emailInputted)
            let _: Data = try await networkManager.request(LuaAuthAPITarget.resetPassword(passwordParameters))
        } catch _ as LuaNetworkError {
            throw LuaNetworkError.noInternetConnection
        } catch {
            throw error
        }
    }
    
    private func makePasswordResetParams(inputedEmail: String) -> [String : String] {
        let passwordResetParameters = [
            "email": inputedEmail
        ]
        return passwordResetParameters
    }
    
    private func validateConnectivity() throws {
        guard ConnectivityManager.shared.isConnected else {
            throw LuaNetworkError.noInternetConnection
        }
    }
    
    func validateEmailFormat(inputtedEmail: String) -> Bool {
        let isEmailFormatValid = inputtedEmail.contains(".") &&
        inputtedEmail.contains("@") &&
        inputtedEmail.count > 5
        return isEmailFormatValid
    }
}

