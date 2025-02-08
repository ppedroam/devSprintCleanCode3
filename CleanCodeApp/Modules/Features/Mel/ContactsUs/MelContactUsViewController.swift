//
//  ContactUsViewController.swift
//  DeliveryAppChallenge
//
//  Created by Pedro Menezes on 17/07/22.
//

import UIKit

class MelContactUsViewController: LoadingInheritageController {
    var model: ContactUsModel?
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Escreva sua mensagem aqui"
        return textView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.text = "Escolha o canal para contato"
        return label
    }()
    
    private lazy var phoneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(phoneClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(emailClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var chatButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(chatClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = "Ou envie uma mensagem"
        label.numberOfLines = 2
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var sendMessageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.setTitle("  Enviar ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.addTarget(self, action: #selector(messageSend), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Voltar", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchAndProcessContactData()
    }
}

// MARK: - Functions
extension MelContactUsViewController {
    @objc
    private func phoneClick() {
        guard let tel = model?.phone,
              let url = URL(string: "tel://\(tel)") else { return }
        openURL(url)
    }
    
    @objc
    private func emailClick() {
        guard let mail = model?.mail,
              let url = URL(string: "mailto:\(mail)") else { return }
        openURL(url)
    }
    
    @objc
    private func chatClicked() {
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
    
    @objc
    private func messageSend() {
        view.endEditing(true)
        guard let message = textView.text, !message.isEmpty else { return }
        let email = model?.mail ?? ""
        let parameters = createMessageParameters(email: email, message: message)
        showLoadingView()
        sendRequest(parameters) { [weak self] result in
            guard let self = self else { return }
            self.removeLoadingView()
            self.handleResponse(result)
        }
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
    
    @objc
    private func close() {
        dismiss(animated: true)
    }
    
    private func symbolConfiguration() {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 36)
        configureButtonImage(phoneButton, with: "phone", buttonSymbolConfiguration: symbolConfig)
        configureButtonImage(emailButton, with: "envelope", buttonSymbolConfiguration: symbolConfig)
        configureButtonImage(chatButton, with: "message", buttonSymbolConfiguration: symbolConfig)
    }
    
    private func configureButtonImage(_ button: UIButton, with systemNameImage: String, buttonSymbolConfiguration: UIImage.SymbolConfiguration) {
        let image = UIImage(systemName: systemNameImage)?.withConfiguration(buttonSymbolConfiguration)
        button.setImage(image, for: .normal)
    }
    
    private func fetchAndProcessContactData() {
        showLoadingView()
        fetchContactData() { [weak self] result in
            guard let self = self else { return }
            self.removeLoadingView()
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

// MARK: - ViewCode Protocol Conformance
extension MelContactUsViewController: MelViewCode {
    func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(phoneButton)
        view.addSubview(emailButton)
        view.addSubview(chatButton)
        view.addSubview(messageLabel)
        view.addSubview(textView)
        view.addSubview(sendMessageButton)
        view.addSubview(closeButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            phoneButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            emailButton.centerYAnchor.constraint(equalTo: phoneButton.centerYAnchor),
            chatButton.centerYAnchor.constraint(equalTo: phoneButton.centerYAnchor),
            
            phoneButton.widthAnchor.constraint(equalToConstant: 80),
            phoneButton.heightAnchor.constraint(equalToConstant: 80),
            phoneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            emailButton.widthAnchor.constraint(equalToConstant: 80),
            emailButton.heightAnchor.constraint(equalToConstant: 80),
            emailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            chatButton.widthAnchor.constraint(equalToConstant: 80),
            chatButton.heightAnchor.constraint(equalToConstant: 80),
            chatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: phoneButton.bottomAnchor, constant: 30),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            textView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: sendMessageButton.topAnchor, constant: -30),
            
            sendMessageButton.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -20),
            sendMessageButton.heightAnchor.constraint(equalToConstant: 40),
            sendMessageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sendMessageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func setupStyle() {
        view.backgroundColor = .systemGray6
        symbolConfiguration()
    }
}

enum ChatError: Error {
    case invalidPhoneNumber
    case invalidURL
}
