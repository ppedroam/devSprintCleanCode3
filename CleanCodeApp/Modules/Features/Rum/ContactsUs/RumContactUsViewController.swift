//
//  ContactUsViewController.swift
//  DeliveryAppChallenge
//
//  Created by Pedro Menezes on 17/07/22.
//

import UIKit

class RumContactUsViewController: LoadingInheritageController {
    var model: ContactUsModel?
    let textView = UITextView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.text = "Escolha o canal para contato"
        return label
    }()
    
    private lazy var phoneButton: UIButton = {
        let phoneButton = UIButton()
        phoneButton.backgroundColor = .systemGray4
        phoneButton.layer.cornerRadius = 10
        phoneButton.addTarget(self, action: #selector(phoneClick), for: .touchUpInside)
        return phoneButton
    }()
    
    private lazy var emailButton: UIButton = {
        let emailButton = UIButton()
        emailButton.backgroundColor = .systemGray4
        emailButton.layer.cornerRadius = 10
        emailButton.addTarget(self, action: #selector(emailClick), for: .touchUpInside)
        return emailButton
    }()
    
    private lazy var chatButton: UIButton = {
        let chatButton = UIButton()
        chatButton.backgroundColor = .systemGray4
        chatButton.layer.cornerRadius = 10
        chatButton.addTarget(self, action: #selector(chatClicked), for: .touchUpInside)
        return chatButton
    }()
    
    private lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.textColor = .black
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        messageLabel.text = "Ou envie uma mensagem"
        messageLabel.numberOfLines = 2
        messageLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return messageLabel
    }()
    
    private lazy var sendMessageButton: UIButton = {
        let sendMessageButton = UIButton()
        sendMessageButton.backgroundColor = .blue
        sendMessageButton.setTitle("  Enviar ", for: .normal)
        sendMessageButton.setTitleColor(.white, for: .normal)
        sendMessageButton.layer.cornerRadius = 10
        sendMessageButton.setContentHuggingPriority(.required, for: .horizontal)
        sendMessageButton.addTarget(self, action: #selector(messageSend), for: .touchUpInside)
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
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        return closeButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        textView.text = "Escreva sua mensagem aqui"
        
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 36)
        phoneButton.setImage(UIImage.init(systemName: "phone")?.withConfiguration(symbolConfiguration), for: .normal)
        emailButton.setImage(UIImage.init(systemName: "envelope")?.withConfiguration(symbolConfiguration), for: .normal)
        chatButton.setImage(UIImage.init(systemName: "message")?.withConfiguration(symbolConfiguration), for: .normal)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneButton.translatesAutoresizingMaskIntoConstraints = false
        emailButton.translatesAutoresizingMaskIntoConstraints = false
        chatButton.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        sendMessageButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(phoneButton)
        view.addSubview(emailButton)
        view.addSubview(chatButton)
        view.addSubview(messageLabel)
        view.addSubview(textView)
        view.addSubview(sendMessageButton)
        view.addSubview(closeButton)
        
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
        
        pegarDados()
    }
    
    @objc
    func phoneClick() {
        if let tel = model?.phone,
           let url = URL(string: "tel://\(tel)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc
    func emailClick() {
        if let mail = model?.mail,
           let url = URL(string: "mailto:\(mail)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc
    func chatClicked() {
        if let phoneNumber = model?.phone, let whatsappURL = URL(string: "whatsapp://send?phone=\(phoneNumber)&text=Oi)") {
            if UIApplication.shared.canOpenURL(whatsappURL) {
                UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
            } else {
                if let appStoreURL = URL(string: "https://apps.apple.com/app/whatsapp-messenger/id310633997") {
                    UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    @objc
    func close() {
        dismiss(animated: true)
    }
    
    
    func pegarDados() {
        showLoadingView()
        let url = Endpoints.contactUs
        AF.shared.request(url, method: .get, parameters: nil, headers: nil) { result in
            self.removeLoadingView()
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let returned = try? decoder.decode(ContactUsModel.self, from: data) {
                    self.model = returned
                } else {
                    Globals.alertMessage(title: "Ops..", message: "Ocorreu algum erro", targetVC: self) {
                        self.dismiss(animated: true)
                    }
                }
            case .failure(let error):
                print("error api: \(error.localizedDescription)")
                Globals.alertMessage(title: "Ops..", message: "Ocorreu algum erro", targetVC: self) {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    @objc
    func messageSend() {
        view.endEditing(true)
        let email = model?.mail ?? ""
        if let message = textView.text, textView.text.count > 0 {
            let parameters: [String: String] = [
                "email": email,
                "mensagem": message
            ]
            showLoadingView()
            let url = Endpoints.sendMessage
            AF.shared.request(url, method: .post, parameters: parameters, headers: nil) { result in
                self.removeLoadingView()
                switch result {
                case .success:
                    Globals.alertMessage(title: "Sucesso..", message: "Sua mensagem foi enviada", targetVC: self) {
                        self.dismiss(animated: true)
                    }
                case .failure:
                    Globals.alertMessage(title: "Ops..", message: "Ocorreu algum erro", targetVC: self)
                }
            }
        }
    }
}
