//
//  ContactUsViewController.swift
//  DeliveryAppChallenge
//
//  Created by Pedro Menezes on 17/07/22.
//

import UIKit

class MelContactUsViewController: LoadingInheritageController {
    var model: ContactUsModel?
    var screen: MelContactUsScreen?
    private let urlHandler: MelURLHandler = MelURLHandler()
    private let service: MelContactUsService = MelContactUsService()
    
    private let melLoadingView: LoadingInheritageController = LoadingInheritageController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screen?.configureDelegate(delegate: self)
        fetchAndProcessContactData()
    }
    
    override func loadView() {
        self.screen = MelContactUsScreen()
        view = screen
    }
    
    deinit {
        print(Self.self, "- Deallocated")
    }
}

// MARK: - Functions
extension MelContactUsViewController: MelContactUsScreenDelegate {
    func didTapPhoneButton() {
        guard let tel = model?.phone,
              let url = URL(string: "tel://\(tel)") else { return }
        urlHandler.openURL(url)
    }
    
    func didTapEmailButton() {
        guard let mail = model?.mail,
              let url = URL(string: "mailto:\(mail)") else { return }
        urlHandler.openURL(url)
    }
    
    func didTapChatButton() {
        do {
            let whatsAppURL = try urlHandler.getWhatsAppURL(phoneNumber: model?.phone)
            if urlHandler.canOpenURL(whatsAppURL) {
                urlHandler.openURL(whatsAppURL)
            } else {
                let appStoreURL = try urlHandler.getAppStoreURL()
                urlHandler.openURL(appStoreURL)
            }
        } catch {
            print("Erro ao tentar abrir o chat: \(error)")
        }
    }
    
    func didTapSendMessageButton(message: String) {
        guard !message.isEmpty, let email = model?.mail else { return }
        melLoadingView.showLoadingView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.melLoadingView.removeLoadingView()
        }
        prepareAndSendMessage(email: email, message: message)
    }
    
    func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    private func createMessageParameters(email: String, message: String) -> [String : String] {
        return [
            "email" : email,
            "message" : message
        ]
    }
    
    private func prepareAndSendMessage(email: String, message: String) {
        let parameters = createMessageParameters(email: email, message: message)
        service.sendRequest(parameters) { [weak self] result in
            guard let self = self else { return }
            self.removeLoadingView()
            self.handleResponse(result)
        }
    }
    
    private func handleResponse(_ result: Result<Data, Error>) {
        switch result {
        case .success:
            showSuccessAlert()
        case .failure:
            showErrorAlert()
        }
    }
    
    private func showSuccessAlert() {
        Globals.alertMessage(title: MelContactUsStrings.successAlertTitle.rawValue,
                             message: MelContactUsStrings.successAlertMessage.rawValue,
                             targetVC: self) {
            self.dismiss(animated: true)
        }
    }
    
    private func showErrorAlert(mustDismiss: Bool = false) {
        Globals.alertMessage(title: MelContactUsStrings.errorAlertTitle.rawValue,
                             message: MelContactUsStrings.errorAlertMessage.rawValue,
                             targetVC: self)
        if mustDismiss {
            self.dismiss(animated: true)
        }
    }
    
    private func fetchAndProcessContactData() {
        melLoadingView.showLoadingView()
        service.fetchContactData() { [weak self] result in
            guard let self = self else { return }
            self.melLoadingView.removeLoadingView()
            switch result {
            case .success(let contactModel):
                self.model = contactModel
            case .failure(let error):
                print("Erro na API: \(error.localizedDescription)")
                self.showErrorAlert(mustDismiss: true)
            }
        }
    }
}

enum ChatError: Error {
    case invalidPhoneNumber
    case invalidURL
}
