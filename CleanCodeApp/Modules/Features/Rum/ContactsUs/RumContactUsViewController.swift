//
//  ContactUsViewController.swift
//  DeliveryAppChallenge
//
//  Created by Pedro Menezes on 17/07/22.
//

import UIKit

final class RumContactUsViewController: LoadingInheritageController {
    // MARK: - Model
    var model: ContactUsModel?
    
    // MARK: - UI Components
    private lazy var contactUsView = RumContactUsView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contactUsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        fetchData()
    }
    
    // MARK: - Setup Methods
    private func setupActions() {
        contactUsView.phoneButton.addTarget(self, action: #selector(didTapPhoneButton), for: .touchUpInside)
        contactUsView.emailButton.addTarget(self, action: #selector(didTapEmailButton), for: .touchUpInside)
        contactUsView.chatButton.addTarget(self, action: #selector(didTapChatButton), for: .touchUpInside)
        contactUsView.sendMessageButton.addTarget(self, action: #selector(didTapSendMessageButton), for: .touchUpInside)
        contactUsView.closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc func didTapPhoneButton() {
        guard let tel = model?.phone, let url = URL(string: "tel://\(tel)") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func didTapEmailButton() {
        guard let mail = model?.mail, let url = URL(string: "mailto:\(mail)") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func didTapChatButton() {
        guard let phoneNumber = model?.phone, let whatsappURL = URL(string: "whatsapp://send?phone=\(phoneNumber)&text=Oi)") else { return }
        UIApplication.shared.canOpenURL(whatsappURL) ? openWhatsapp(whatsappURL) : openAppStore()
    }
    
    private func openWhatsapp(_ whatsappURL: URL) {
        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
    }
    
    private func openAppStore() {
        guard let appStoreURL = URL(string: "https://apps.apple.com/app/whatsapp-messenger/id310633997") else { return }
        UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
    }
    
    @objc func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    func fetchData() {
        showLoadingView()
        let url = Endpoints.contactUs
        AF.shared.request(url, method: .get, parameters: nil, headers: nil) { result in
            self.removeLoadingView()
            switch result {
            case .success(let data):
                self.decodeData(data)
            case .failure(let error):
                print("error api: \(error.localizedDescription)")
                self.handleAlertMessage(title: "Ops..", message: "Ocorreu algum erro", shouldDismiss: true)
            }
        }
    }
    
    private func decodeData(_ data: Data) {
        do {
            let decoder = JSONDecoder()
            let returned = try decoder.decode(ContactUsModel.self, from: data)
            self.model = returned
        } catch {
            self.handleAlertMessage(title: "Ops..", message: "Ocorreu algum erro", shouldDismiss: true)
        }
    }
    
    @objc func didTapSendMessageButton() {
        view.endEditing(true)
        let email = model?.mail ?? ""
        if let message = contactUsView.textView.text, contactUsView.textView.text.count > 0 {
            let parameters: [String: String] = [
                "email": email,
                "mensagem": message
            ]
            sendMessage(parameters: parameters)
        }
    }
    
    private func sendMessage(parameters: [String: String]) {
        showLoadingView()
        let url = Endpoints.sendMessage
        AF.shared.request(url, method: .post, parameters: parameters, headers: nil) { result in
            self.removeLoadingView()
            switch result {
            case .success:
                self.handleAlertMessage(title: "Sucesso..", message: "Sua mensagem foi enviada", shouldDismiss: true)
            case .failure:
                self.handleAlertMessage(title: "Ops..", message: "Ocorreu algum erro")
            }
        }
    }
    
    private func handleAlertMessage(title: String, message: String, shouldDismiss: Bool = false) {
        Globals.showAlertMessage(title: title, message: message, targetVC: self) {
            shouldDismiss ? self.dismiss(animated: true) : nil
        }
    }
}
