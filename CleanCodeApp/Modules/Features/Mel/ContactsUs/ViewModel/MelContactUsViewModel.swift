//
//  MelContactUsViewModel.swift
//  CleanCode
//
//  Created by Bruno Moura on 22/02/25.
//

import Foundation

@MainActor protocol MelContactUsViewModelDelegate: AnyObject {
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
    func sendMessageToSupport(message: String) async
}

final class MelContactUsViewModel {
    private weak var delegate: MelContactUsViewModelDelegate?
    private var contactModel: ContactUsModel?
    private let appOpener: ExternalAppOpening
    private let contactUsService: MelContactUsServiceProtocol
    
    init(appOpener: ExternalAppOpening,
         contactUsService: MelContactUsServiceProtocol
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
        Task {
            await delegate?.presentLoading()

            do {
                let contactUsData = try await contactUsService.fetchContactData()
                self.contactModel = contactUsData
            } catch {
                print("Erro na API: \(error.localizedDescription)")
                await delegate?.presentErrorAlert(mustDismiss: true)
            }
            await delegate?.hideLoading()
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
    
    func sendMessageToSupport(message: String) async {
        await delegate?.presentLoading()
        guard !message.isEmpty, let email = contactModel?.mail else {
            await delegate?.hideLoading()
            return
        }
        await prepareAndSendMessage(email: email, message: message)
    }
    
    private func prepareAndSendMessage(email: String, message: String) async {
            do {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                let parameters = createMessageParameters(email: email, message: message)
                _ = try await contactUsService.sendContactUsMessage(parameters)
                await delegate?.hideLoading()
                await delegate?.presentSuccessAlert()
            } catch {
                await delegate?.hideLoading()
                await delegate?.presentErrorAlert(mustDismiss: false)
            }
    }
    
    private func createMessageParameters(email: String, message: String) -> [String : String] {
        return [
            "email" : email,
            "message" : message
        ]
    }
}
