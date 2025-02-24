//
//  RioResetPasswordViewConfigurator.swift
//  CleanCode
//
//  Created by thaisa on 17/02/25.
//

import Foundation
import UIKit

class RioResetPasswordViewConfigurator {
    
    func setupView(for viewController: RioResetPasswordViewController) {
        setupButtons(for: viewController)
        setupTextField(for: viewController)
        setupEmail(for: viewController)
        updateRecoverPasswordButtonState(for: viewController)
        viewController.viewSuccess.isHidden = true
    }
    
    private func setupButtons(for vc: RioResetPasswordViewController) {
        styleButton(vc.recoverPasswordButton, backgroundColor: .blue, titleColor: .white, borderWidth: 0)
        styleButton(vc.loginButton, backgroundColor: .white, titleColor: .blue, borderWidth: 1)
        styleButton(vc.helpButton, backgroundColor: .white, titleColor: .blue, borderWidth: 1)
        styleButton(vc.createAccountButton, backgroundColor: .white, titleColor: .blue, borderWidth: 1)
    }
    
    private func styleButton(_ button: UIButton, backgroundColor: UIColor, titleColor: UIColor, borderWidth: CGFloat) {
        button.layer.cornerRadius = button.bounds.height / 2
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = UIColor.blue.cgColor
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor
    }
    
    private func setupTextField(for vc: RioResetPasswordViewController) {
        vc.emailTextfield.setDefaultColor()
    }
    
    private func setupEmail(for vc: RioResetPasswordViewController) {
        guard !vc.email.isEmpty else { return }
        vc.emailTextfield.text = vc.email
        vc.emailTextfield.isEnabled = false
    }
    
    func updateRecoverPasswordButtonState(for vc: RioResetPasswordViewController) {
        let isValid = !(vc.emailTextfield.text?.isEmpty ?? true)
        vc.recoverPasswordButton.backgroundColor = isValid ? .blue : .gray
        vc.recoverPasswordButton.setTitleColor(.white, for: .normal)
        vc.recoverPasswordButton.isEnabled = isValid
    }
}
