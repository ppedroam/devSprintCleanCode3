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
        openURL(url)
    }
    
    func didTapEmailButton() {
        guard let mail = model?.mail,
              let url = URL(string: "mailto:\(mail)") else { return }
        openURL(url)
    }
    
    func didTapChatButton() {
        do {
            let whatsAppURL = try getWhatsAppURL()
            if canOpenURL(whatsAppURL) {
                openURL(whatsAppURL)
            } else {
                let appStoreURL = try getAppStoreURL()
                openURL(appStoreURL)
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
    
    private func getWhatsAppURL() throws -> URL {
        guard let phoneNumber = model?.phone else { throw ChatError.invalidPhoneNumber }
        guard let url = URL(string: "whatsapp://send?phone=\(phoneNumber)&text=Oi)") else { throw ChatError.invalidURL }
        return url
    }
    
    private func getAppStoreURL() throws -> URL {
        guard let url = URL(string: "https://apps.apple.com/app/whatsapp-messenger/id310633997") else { throw ChatError.invalidURL }
        return url
    }
    
    private func canOpenURL(_ url: URL) -> Bool {
        return UIApplication.shared.canOpenURL(url)
    }
    
    private func openURL(_ url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func createMessageParameters(email: String, message: String) -> [String : String] {
        return [
            "email" : email,
            "message" : message
        ]
    }
    
    private func sendRequest(_ parameters: [String : String], completion: @escaping (Result<Data, Error>) -> Void) {
        let url = Endpoints.sendMessage
        AF.shared.request(url, method: .post, parameters: parameters, headers: nil) { result in
            completion(result)
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
    
    private func prepareAndSendMessage(email: String, message: String) {
        let parameters = createMessageParameters(email: email, message: message)
        sendRequest(parameters) { [weak self] result in
            guard let self = self else { return }
            self.removeLoadingView()
            self.handleResponse(result)
        }
    }
    
    private func showSuccessAlert() {
        Globals.alertMessage(title: "Sucesso..", message: "Sua mensagem foi enviada", targetVC: self) {
            self.dismiss(animated: true)
        }
    }
    
    private func showErrorAlert(mustDismiss: Bool = false) {
        Globals.alertMessage(title: "Ops..", message: "Ocorreu algum erro", targetVC: self)
        if mustDismiss {
            self.dismiss(animated: true)
        }
    }
    
    private func fetchAndProcessContactData() {
        melLoadingView.showLoadingView()
        fetchContactData() { [weak self] result in
            guard let self = self else { return }
            self.melLoadingView.removeLoadingView()
            self.handleContactDataResponse(result)
        }
    }
    
    private func fetchContactData(completion: @escaping (Result<Data, Error>) -> Void) {
        let url = Endpoints.contactUs
        AF.shared.request(url, method: .get, parameters: nil, headers: nil) { result in
            completion(result)
        }
    }
    
    private func handleContactDataResponse(_ result: Result<Data, Error>) {
        switch result {
        case .success(let data):
            decodeContactData(data)
        case .failure(let error):
            print("Erro na API: \(error.localizedDescription)")
            showErrorAlert(mustDismiss: true)
        }
    }
    
    private func decodeContactData(_ data: Data) {
        let decoder = JSONDecoder()
        
        if let returned = try? decoder.decode(ContactUsModel.self, from: data) {
            self.model = returned
        } else {
            showErrorAlert(mustDismiss: true)
        }
    }
}

enum ChatError: Error {
    case invalidPhoneNumber
    case invalidURL
}
