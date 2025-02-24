//
//  ContactUsViewController.swift
//  DeliveryAppChallenge
//
//  Created by Pedro Menezes on 17/07/22.
//

import UIKit

class MelContactUsViewController: LoadingInheritageController {
    var contactModel: ContactUsModel?
    var contactUsView: MelContactUsScreen?
    private let appOpener = ExternalAppOpener(application: UIApplication.shared)
    private let contactUsService: MelContactUsService = MelContactUsService()
    private let melLoadingView: LoadingInheritageController = LoadingInheritageController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactUsView?.setDelegate(delegate: self)
        fetchAndProcessContactData()
    }
    
    override func loadView() {
        self.contactUsView = MelContactUsScreen()
        view = contactUsView
    }
    
    deinit {
        print(Self.self, "- Deallocated")
    }
}

// MARK: - Functions
extension MelContactUsViewController: MelContactUsScreenDelegate {
    func didTapPhoneCallButton() {
        guard let tel = contactModel?.phone else { return }
        let telephoneUrlCreator = TelephoneUrlCreator(number: tel)
        Task {
            do {
                try await appOpener.openUrl(telephoneUrlCreator)
            } catch {
                print("Erro ao abrir URL: \(error)")
            }
        }
    }
    
    func didTapEmailButton() {
        guard let mail = contactModel?.mail else { return }
        let emailUrlCreator = EmailUrlCreator(email: mail)
        Task {
            do {
                try await appOpener.openUrl(emailUrlCreator)
            } catch {
                print("Erro ao abrir URL: \(error)")
            }
        }
    }
    
    func didTapChatButton() {
        guard let phone = contactModel?.phone else {
            print("Número de telefone inválido")
            return
        }
        let whatsappUrlCreator = WhatsppUrlCreator(phoneNumber: phone)
        let appStoreUrlCreator = MelWhatsAppAppStoreUrlCreator()
        Task {
            do {
                try await appOpener.openUrl(whatsappUrlCreator)
            } catch {
                print("Erro ao abrir WhatsApp: \(error). Tentando abrir a App Store...")
                try? await appOpener.openUrl(appStoreUrlCreator)
            }
        }
    }
    
    func didTapSendMessageButton(message: String) {
        guard !message.isEmpty, let email = contactModel?.mail else { return }
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
        contactUsService.sendContactUsMessage(parameters) { [weak self] result in
            guard let self = self else { return }
            self.removeLoadingView()
            self.handleSendContactResponse(result)
        }
    }
    
    private func handleSendContactResponse(_ result: Result<Data, Error>) {
        switch result {
        case .success:
            presentSuccessAlert()
        case .failure:
            presentErrorAlert()
        }
    }
    
    private func presentSuccessAlert() {
        Globals.alertMessage(title: MelContactUsStrings.successAlertTitle.rawValue,
                             message: MelContactUsStrings.successAlertMessage.rawValue,
                             targetVC: self) {
            self.dismiss(animated: true)
        }
    }
    
    private func presentErrorAlert(mustDismiss: Bool = false) {
        Globals.alertMessage(title: MelContactUsStrings.errorAlertTitle.rawValue,
                             message: MelContactUsStrings.errorAlertMessage.rawValue,
                             targetVC: self)
        if mustDismiss {
            self.dismiss(animated: true)
        }
    }
    
    private func fetchAndProcessContactData() {
        melLoadingView.showLoadingView()
        contactUsService.fetchContactData() { [weak self] result in
            guard let self = self else { return }
            self.melLoadingView.removeLoadingView()
            switch result {
            case .success(let contactModel):
                self.contactModel = contactModel
            case .failure(let error):
                print("Erro na API: \(error.localizedDescription)")
                self.presentErrorAlert(mustDismiss: true)
            }
        }
    }
}

enum ChatError: Error {
    case invalidPhoneNumber
    case invalidURL
}
