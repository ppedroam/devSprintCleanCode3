//
//  RioResetPasswordViewModel.swift
//  CleanCode
//
//  Created by thaisa on 17/02/25.
//

import Foundation

class RioResetPasswordViewModel {
    
    weak var delegate: RioResetPasswordViewModelDelegate?
    private let service: RioResetPasswordService
    
    init(service: RioResetPasswordService = RioResetPasswordService()) {
        self.service = service
    }
    
    func validateEmail(_ email: String) throws {
        guard !email.isEmpty,
              email.contains("@"),
              email.contains("."),
              email.count > 5 else {
            throw RioCommonErrors.invalidEmail
        }
    }
    
    func validateInternetConnection() throws {
        guard ConnectivityManager.shared.isConnected else {
            throw RioCommonErrors.noInternet
        }
    }
    
    func attemptPasswordReset(email: String) {
        do {
            try validateEmail(email)
            try validateInternetConnection()
            
            service.resetPassword(email: email) { [weak self] success in
                DispatchQueue.main.async {
                    if success {
                        self?.delegate?.didResetPasswordSuccess(email: email)
                    } else {
                        self?.delegate?.didFailWithError(.noInternet)
                    }
                }
            }
        } catch let error as RioCommonErrors {
            delegate?.didFailWithError(error)
        } catch {
            delegate?.didFailWithError(.noInternet)
        }
    }
}
