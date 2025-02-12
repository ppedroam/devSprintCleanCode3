//
//  ContactUsViewController.swift
//  DeliveryAppChallenge
//
//  Created by Pedro Menezes on 17/07/22.
//

import UIKit

class CeuContactUsViewController: LoadingInheritageController {
    var model: ContactUsModel?

    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = "Escreva sua mensagem aqui"
        return textView
    }()

    lazy var symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 36)

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        titleLabel.text = "Escolha o canal para contato"
        return titleLabel
    }()

    lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.textColor = .black
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        messageLabel.text = "Ou envie uma mensagem"
        messageLabel.numberOfLines = 2
        messageLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return messageLabel
    }()

    lazy var phoneButton: UIButton = {
        let phoneButton = UIButton()
        phoneButton.backgroundColor = .systemGray4
        phoneButton.layer.cornerRadius = 10
        phoneButton.addTarget(self, action: #selector(phoneClick), for: .touchUpInside)
        phoneButton.setImage(UIImage.init(systemName: "phone")?.withConfiguration(symbolConfiguration), for: .normal)
        return phoneButton
    }()

    lazy var emailButton: UIButton = {
        let emailButton = UIButton()
        emailButton.backgroundColor = .systemGray4
        emailButton.layer.cornerRadius = 10
        emailButton.addTarget(self, action: #selector(emailClick), for: .touchUpInside)
        emailButton.setImage(UIImage.init(systemName: "envelope")?.withConfiguration(symbolConfiguration), for: .normal)
        return emailButton
    }()

    lazy var chatButton: UIButton = {
        let chatButton = UIButton()
        chatButton.backgroundColor = .systemGray4
        chatButton.layer.cornerRadius = 10
        chatButton.addTarget(self, action: #selector(chatClicked), for: .touchUpInside)
        chatButton.setImage(UIImage.init(systemName: "message")?.withConfiguration(symbolConfiguration), for: .normal)
        return chatButton
    }()

    lazy var sendMessageButton: UIButton = {
        let sendMessageButton = UIButton()
        sendMessageButton.backgroundColor = .blue
        sendMessageButton.setTitle("Enviar", for: .normal)
        sendMessageButton.setTitleColor(.white, for: .normal)
        sendMessageButton.layer.cornerRadius = 10
        sendMessageButton.setContentHuggingPriority(.required, for: .horizontal)
        sendMessageButton.addTarget(self, action: #selector(sendMessageButtonAction), for: .touchUpInside)
        return sendMessageButton
    }()

    lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setTitle("Voltar", for: .normal)
        closeButton.setTitleColor(.blue, for: .normal)
        closeButton.backgroundColor = .clear
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = UIColor.blue.cgColor
        closeButton.layer.cornerRadius = 10
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        return closeButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        fetchContactUsData()
    }

    private func setupViews() {
        view.backgroundColor = .systemGray6
        setupTitleLabel()
        setupPhoneButton()
        setupEmailButton()
        setupChatButton()
        setupMessageLabel()
        setupCloseButton()
        setupSendMessageButton()
        setupTextView()
    }

    private func setupSubview(_ view: UIView, constraints: [NSLayoutConstraint]) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        NSLayoutConstraint.activate(constraints)
    }

    private func setupEmailButton() {
        setupSubview(emailButton, constraints: [
            emailButton.centerYAnchor.constraint(equalTo: phoneButton.centerYAnchor),
            emailButton.widthAnchor.constraint(equalToConstant: 80),
            emailButton.heightAnchor.constraint(equalToConstant: 80),
            emailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    private func setupTitleLabel() {
        setupSubview(titleLabel, constraints: [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupPhoneButton() {
        setupSubview(phoneButton, constraints: [
            phoneButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            phoneButton.widthAnchor.constraint(equalToConstant: 80),
            phoneButton.heightAnchor.constraint(equalToConstant: 80),
            phoneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }

    private func setupChatButton() {
        setupSubview(chatButton, constraints: [
            chatButton.centerYAnchor.constraint(equalTo: phoneButton.centerYAnchor),
            chatButton.widthAnchor.constraint(equalToConstant: 80),
            chatButton.heightAnchor.constraint(equalToConstant: 80),
            chatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupMessageLabel() {
        setupSubview(messageLabel, constraints: [
            messageLabel.topAnchor.constraint(equalTo: phoneButton.bottomAnchor, constant: 30),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupSendMessageButton() {
        setupSubview(sendMessageButton, constraints: [
            sendMessageButton.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -20),
            sendMessageButton.heightAnchor.constraint(equalToConstant: 40),
            sendMessageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sendMessageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupTextView() {
        setupSubview(textView, constraints: [
            textView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: sendMessageButton.topAnchor, constant: -30)
        ])
    }

    private func setupCloseButton() {
        setupSubview(closeButton, constraints: [
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc
    func phoneClick() {
        let tel = model?.phone
        handleClick(string: tel, urlString: "tel://")
    }
    
    @objc
    func emailClick() {
        let mail = model?.mail
        handleClick(string: mail, urlString: "mailto:")
    }

    private func handleClick(string: String?, urlString: String) {
        if let string = string,
           let url = URL(string: urlString + string) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    @objc
    func chatClicked() throws {
        let urls = try setupURLs()
        let canOpenWhatsappURL = UIApplication.shared.canOpenURL(urls.whatsappURL)
        if canOpenWhatsappURL {
            openURL(url: urls.whatsappURL)
        } else {
            openURL(url: urls.appleStoreURL)
        }

    }

    private func setupURLs() throws -> CeuUrlTypes {
        let phoneNumber = model?.phone
        guard let phoneNumber = phoneNumber else {
            throw CeuContactUsCommonsErrors.invalidPhoneNumber
        }
        guard let whatsappURL = URL(string: "whatsapp://send?phone=\(phoneNumber)&text=Oi)") else {
            throw CeuContactUsCommonsErrors.invalidURL
        }
        guard let appleStoreURL = URL(string: "https://apps.apple.com/app/whatsapp-messenger/id310633997") else {
            throw CeuContactUsCommonsErrors.invalidURL
        }
        return CeuUrlTypes(appleStoreURL: appleStoreURL, whatsappURL: whatsappURL)
    }

    private func openURL(url: URL?) {
        if let url = url {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    @objc
    func close() {
        dismiss(animated: true)
    }

    private func fetchContactUsData() {
        showLoadingView()
        let url = Endpoints.contactUs
        AF.shared.request(url, method: .get, parameters: nil, headers: nil) { result in
            self.removeLoadingView()
            switch result {
            case .success(let data):
                self.handleFetchContactUsDataResquestSuccess(data)
            case .failure(let error):
                self.showErrorAlertMessage()
            }
        }
    }

    private func handleFetchContactUsDataResquestSuccess(_ data: Data) {
        let decoder = JSONDecoder()
        if let returned = try? decoder.decode(ContactUsModel.self, from: data) {
            self.model = returned
        } else {
            self.showErrorAlertMessage()
        }
    }

    private func showErrorAlertMessage() {
        Globals.alertMessage(title: "Ops..", message: "Ocorreu algum erro", targetVC: self) {
            self.dismiss(animated: true)
        }
    }

    private func showSuccessAlertMessage() {
        Globals.alertMessage(title: "Sucesso..", message: "Sua mensagem foi enviada", targetVC: self) {
            self.dismiss(animated: true)
        }
    }

    @objc
    func sendMessageButtonAction() {
        view.endEditing(true)
        guard let message = textView.text, textView.text.count > 0 else {
            return
        }
        showLoadingView()
        sendMessageRequest(message: message)
    }

    func sendMessageRequest(message: String) {
        let parameters = setupParameters(message: message)
        let url = Endpoints.sendMessage
        AF.shared.request(url, method: .post, parameters: parameters, headers: nil) { result in
            self.removeLoadingView()
            switch result {
            case .success:
                self.showSuccessAlertMessage()
            case .failure:
                self.showErrorAlertMessage()
            }
        }
    }

    private func setupParameters(message: String) -> [String: String] {
        let email = model?.mail ?? ""
        let parameters: [String: String] = [
            "email": email,
            "mensagem": message
        ]
        return parameters
    }
}

enum CeuContactUsCommonsErrors: Error {
    case invalidData
    case invalidURL
    case invalidPhoneNumber
}

struct CeuUrlTypes {
    let appleStoreURL: URL
    let whatsappURL: URL
}
