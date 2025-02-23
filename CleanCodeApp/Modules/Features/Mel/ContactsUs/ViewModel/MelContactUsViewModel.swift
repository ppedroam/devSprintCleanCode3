//
//  MelContactUsViewModel.swift
//  CleanCode
//
//  Created by Bruno Moura on 22/02/25.
//

import Foundation

protocol MelContactUsViewModelDelegate: AnyObject {
    func presentLoading()
    func hideLoading()
    func presentErrorAlert(mustDismiss: Bool)
    func presentSuccessAlert()
}

protocol MelContactUsViewModelProtocol: AnyObject {
    func setDelegate(delegate: MelContactUsViewModelDelegate?)
    func fetchAndProcessContactData()
    func openPhoneForCall()
    func openEmailForMessage()
    func openWhatsAppOrRedirect()
    func sendMessageToSupport(message: String)
}

final class MelContactUsViewModel {
    private weak var delegate: MelContactUsViewModelDelegate?
    private var contactModel: ContactUsModel?
    private let appOpener: ExternalAppOpening
    private let contactUsService: MelContactUsServiceProtocol
    
    init(appOpener: ExternalAppOpening,
         contactUsService: MelContactUsServiceProtocol = MelContactUsService(networking: MelNetworkManager())
    ) {
        self.appOpener = appOpener
        self.contactUsService = contactUsService
    }
}

extension MelContactUsViewModel: MelContactUsViewModelProtocol {
    public func setDelegate(delegate: MelContactUsViewModelDelegate?) {
        self.delegate = delegate
    }
    
    public func fetchAndProcessContactData() {
        delegate?.presentLoading()
        contactUsService.fetchContactData() { [weak self] result in
            guard let self = self else { return }
            self.delegate?.hideLoading()
            switch result {
            case .success(let contactModel):
                self.contactModel = contactModel
            case .failure(let error):
                print("Erro na API: \(error.localizedDescription)")
                self.delegate?.presentErrorAlert(mustDismiss: true)
            }
        }
    }
    
    func openPhoneForCall() {
        guard let tel = contactModel?.phone else { return }
        let telephoneUrlCreator = MelContactUrlFactory.makePhoneCallUrl(for: tel)
        Task {
            do {
                try await appOpener.openUrl(telephoneUrlCreator)
            } catch {
                print("Erro ao abrir URL: \(error)")
            }
        }
    }
    
    func openEmailForMessage() {
        guard let mail = contactModel?.mail else { return }
        let emailUrlCreator = MelContactUrlFactory.makeEmailUrl(for: mail)
        Task {
            do {
                try await appOpener.openUrl(emailUrlCreator)
            } catch {
                print("Erro ao abrir URL: \(error)")
            }
        }
    }
    
    func openWhatsAppOrRedirect() {
        guard let phone = contactModel?.phone else {
            print("Número de telefone inválido")
            return
        }
        
        let whatsappUrl = MelContactUrlFactory.makeWhatsAppUrl(for: phone)
        let appStoreUrl = MelContactUrlFactory.makeAppStoreUrl()
        
        Task {
            do {
                try await appOpener.openUrl(whatsappUrl)
            } catch {
                print("Erro ao abrir WhatsApp: \(error). Tentando abrir a App Store...")
                try? await appOpener.openUrl(appStoreUrl)
            }
        }
    }
    
    func sendMessageToSupport(message: String) {
        guard !message.isEmpty, let email = contactModel?.mail else { return }
        delegate?.presentLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            self.delegate?.hideLoading()
        }
        prepareAndSendMessage(email: email, message: message)
    }
    
    private func prepareAndSendMessage(email: String, message: String) {
        let parameters = createMessageParameters(email: email, message: message)
        contactUsService.sendContactUsMessage(parameters) { [weak self] result in
            guard let self = self else { return }
            self.delegate?.hideLoading()
            self.handleSendContactResponse(result)
        }
    }
    
    private func createMessageParameters(email: String, message: String) -> [String : String] {
        return [
            "email" : email,
            "message" : message
        ]
    }
    
    private func handleSendContactResponse(_ result: Result<Data, Error>) {
        switch result {
        case .success:
            delegate?.presentSuccessAlert()
        case .failure:
            delegate?.presentErrorAlert(mustDismiss: false)
        }
    }
}
