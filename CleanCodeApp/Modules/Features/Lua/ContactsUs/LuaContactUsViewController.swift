//
//  ContactUsViewController.swift
//  DeliveryAppChallenge
//
//  Created by Pedro Menezes on 17/07/22.
//

import UIKit

final class LuaContactUsViewController: UIViewController, LuaViewControllerProtocol {
    typealias ViewCode = LuaContactUsView
    internal let viewCode = LuaContactUsView()
    private let viewModel: LuaContactUsViewModelProtocol
    
    init(viewModel: LuaContactUsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = viewCode
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContactUsData()
        configureButtons()
        hideKeyboardWhenTappedAround()
    }
    
    private func fetchContactUsData() {
        Task {
            do {
                await luaShowLoading()
                try await viewModel.fetchContactUsData()
                await luaStopLoading()
            } catch {
                await luaStopLoading()
                showAlertError(error: error, from: self, alertTitle: LuaContactUsStrings.defaultErrorTitle)
                self.dismiss(animated: true)
            }
        }
    }
    
    private func startSendMessageProcess() {
        view.endEditing(true)
        let hasMessage = viewCode.textInputted.isNotEmpty && viewCode.textInputted != LuaContactUsStrings.textFieldDefaultMessage
        if hasMessage {
            let message = viewCode.textInputted
            guard let mail = viewModel.contactUsModel?.mail else {
                return
            }
            sendMessage(message: message, mail: mail)
            return
        }
        showAlert(alertTitle: LuaContactUsStrings.emptyMessageTitle , message: LuaContactUsStrings.emptyMessageDescription, viewController: self)
    }
    
    private func sendMessage(message: String, mail: String) {
        Task {
            do {
                await luaShowLoading()
                try await viewModel.sendMessage(message: message, mail: mail)
                showAlert(alertTitle: LuaContactUsStrings.defaultSuccessTitle, message: LuaContactUsStrings.defaultSuccessDescription, viewController: self)
            } catch {
                await luaStopLoading()
                showAlertError(error: error, from: self, alertTitle: LuaContactUsStrings.sendMessageErrorDescription)
            }
            await luaStopLoading()
        }
    }
}

// MARK: - Comportamentos de layout
private extension LuaContactUsViewController {
    
    func configureButtons() {
        viewCode.phoneButton.addTarget(self, action: #selector(phoneButtonTapped), for: .touchUpInside)
        viewCode.emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        viewCode.chatButton.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
        viewCode.sendMessageButton.addTarget(self, action: #selector(sendMessageButtonTapped), for: .touchUpInside)
        viewCode.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    @objc func sendMessageButtonTapped() {
        startSendMessageProcess()
    }
    
    @objc func phoneButtonTapped() {
        do {
            try openPhone()
        } catch let error as LuaPersonalInfoError {
            showAlertError(error: error, from: self, alertTitle: error.errorTitle)
        } catch {
            showAlertError(error: error, from: self, alertTitle: LuaContactUsStrings.defaultErrorDescription)
        }
    }
    
    @objc func emailButtonTapped() {
        do {
            try openMail()
        } catch let error as LuaPersonalInfoError {
            showAlertError(error: error, from: self, alertTitle: error.errorTitle)
        } catch {
            showAlertError(error: error, from: self, alertTitle: LuaContactUsStrings.defaultErrorDescription)
        }
    }
    
    @objc func chatButtonTapped() {
        do {
            try openWhatsapp()
        } catch let error as LuaPersonalInfoError {
            showAlertError(error: error, from: self, alertTitle: error.errorTitle)
        } catch {
            showAlertError(error: error, from: self, alertTitle: LuaContactUsStrings.defaultErrorDescription)
        }
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    func openPhone() throws {
        guard let phoneNumer = viewModel.contactUsModel?.phone else {
            throw LuaPersonalInfoError.invalidPhoneNumber
        }
        do {
            try openExternalApp(appURLTarget: PhoneTarget.init(phoneNumer: phoneNumer))
        }
        catch let error as LuaUIApplicationURLError {
            showAlertError(error: error, from: self, alertTitle: error.errorTitle)
        }
    }
    
    func openWhatsapp() throws {
        guard let phoneNumer = viewModel.contactUsModel?.phone else {
            throw LuaPersonalInfoError.invalidPhoneNumber
        }
        do {
            try openExternalApp(appURLTarget: WhatsappTarget.init(whatsappNumber: phoneNumer))
        }
        catch let error as LuaUIApplicationURLError {
            showAlertError(error: error, from: self, alertTitle: error.errorTitle)
        }
    }
    
    func openMail() throws {
        guard let mail = viewModel.contactUsModel?.mail else {
            throw LuaPersonalInfoError.invalidMail
        }
        do {
            try openExternalApp(appURLTarget: MailTarget.init(mail: mail))
        }
        catch let error as LuaUIApplicationURLError {
            showAlertError(error: error, from: self, alertTitle: error.errorTitle)
        }
    }
    
    func openExternalApp(appURLTarget: LuaUrlTargetsProtocol) throws {
        guard let url = appURLTarget.url else {
            throw LuaUIApplicationURLError.invalidAppURL
        }
        if canOpenURL(url) {
            openExternalURL(url)
            return
        }
        guard let fallBackURL = appURLTarget.fallBackURL else {
            throw LuaUIApplicationURLError.unableToOpenAppURL
        }
        openExternalURL(fallBackURL)
    }
}
