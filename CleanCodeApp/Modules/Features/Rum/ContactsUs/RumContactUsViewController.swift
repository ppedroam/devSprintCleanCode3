//
//  ContactUsViewController.swift
//  DeliveryAppChallenge
//
//  Created by Pedro Menezes on 17/07/22.
//

import UIKit

class RumContactUsViewController: LoadingInheritageController {
    // MARK: - Model
    var model: ContactUsModel?
    
    // MARK: - UI Components
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = "Escreva sua mensagem aqui"
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        titleLabel.text = "Escolha o canal para contato"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var phoneButton: UIButton = {
        let phoneButton = UIButton()
        phoneButton.backgroundColor = .systemGray4
        phoneButton.layer.cornerRadius = 10
        phoneButton.addTarget(self, action: #selector(didTapPhoneButton), for: .touchUpInside)
        phoneButton.translatesAutoresizingMaskIntoConstraints = false
        return phoneButton
    }()
    
    private lazy var emailButton: UIButton = {
        let emailButton = UIButton()
        emailButton.backgroundColor = .systemGray4
        emailButton.layer.cornerRadius = 10
        emailButton.addTarget(self, action: #selector(didTapEmailButton), for: .touchUpInside)
        emailButton.translatesAutoresizingMaskIntoConstraints = false
        return emailButton
    }()
    
    private lazy var chatButton: UIButton = {
        let chatButton = UIButton()
        chatButton.backgroundColor = .systemGray4
        chatButton.layer.cornerRadius = 10
        chatButton.addTarget(self, action: #selector(didTapChatButton), for: .touchUpInside)
        chatButton.translatesAutoresizingMaskIntoConstraints = false
        return chatButton
    }()
    
    private lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.textColor = .black
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        messageLabel.text = "Ou envie uma mensagem"
        messageLabel.numberOfLines = 2
        messageLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return messageLabel
    }()
    
    private lazy var sendMessageButton: UIButton = {
        let sendMessageButton = UIButton()
        sendMessageButton.backgroundColor = .blue
        sendMessageButton.setTitle("  Enviar ", for: .normal)
        sendMessageButton.setTitleColor(.white, for: .normal)
        sendMessageButton.layer.cornerRadius = 10
        sendMessageButton.setContentHuggingPriority(.required, for: .horizontal)
        sendMessageButton.addTarget(self, action: #selector(didTapSendMessageButton), for: .touchUpInside)
        sendMessageButton.translatesAutoresizingMaskIntoConstraints = false
        return sendMessageButton
    }()
    
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setTitle("Voltar", for: .normal)
        closeButton.setTitleColor(.blue, for: .normal)
        closeButton.backgroundColor = .clear
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = UIColor.blue.cgColor
        closeButton.layer.cornerRadius = 10
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        return closeButton
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        view.backgroundColor = .systemGray6
        setupButtonImages()
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupButtonImages() {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 36)
        phoneButton.setImage(UIImage.init(systemName: "phone")?.withConfiguration(symbolConfiguration), for: .normal)
        emailButton.setImage(UIImage.init(systemName: "envelope")?.withConfiguration(symbolConfiguration), for: .normal)
        chatButton.setImage(UIImage.init(systemName: "message")?.withConfiguration(symbolConfiguration), for: .normal)
    }
    
    private func setupHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(phoneButton)
        view.addSubview(emailButton)
        view.addSubview(chatButton)
        view.addSubview(messageLabel)
        view.addSubview(textView)
        view.addSubview(sendMessageButton)
        view.addSubview(closeButton)
    }
    
    private func setupConstraints() {
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
            //            stackView.heightAnchor.constraint(equalToConstant: 30),
            
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
        if let message = textView.text, textView.text.count > 0 {
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
        Globals.alertMessage(title: title, message: message, targetVC: self) {
            shouldDismiss ? self.dismiss(animated: true) : nil
        }
    }
}
