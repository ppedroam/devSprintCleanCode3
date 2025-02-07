//
//  ContactUsViewController.swift
//  DeliveryAppChallenge
//
//  Created by Pedro Menezes on 17/07/22.
//

import UIKit

protocol SolContactUsProtocol: AnyObject {
    func callLoadingView()
    func callRemoveLoadingView()
    func showMessageReturnModel(result: ContactUsModel)
    func displayAlertMessage(title: String, message: String, dissmiss: Bool)
    func displayGlobalAlertMessage()
}

class SolContactUsViewController: LoadingInheritageController, SolContactUsProtocol {
    var model: ContactUsModel?
    let textView = UITextView()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.text = "Escolha o canal para contato"
        return label
    }()
    
    // Criar botões
    lazy var phoneButton: UIButton = {
        let phoneButton = UIButton()
        phoneButton.backgroundColor = .systemGray4
        phoneButton.layer.cornerRadius = 10
        phoneButton.addTarget(self, action: #selector(didTapPhone), for: .touchUpInside)
        return phoneButton
    }()
    
    lazy var emailButton: UIButton = {
        let emailButton = UIButton()
        emailButton.backgroundColor = .systemGray4
        emailButton.layer.cornerRadius = 10
        emailButton.addTarget(self, action: #selector(didTapEmail), for: .touchUpInside)
        return emailButton
    }()
    
    lazy var chatButton: UIButton = {
        let chatButton = UIButton()
        chatButton.backgroundColor = .systemGray4
        chatButton.layer.cornerRadius = 10
        chatButton.addTarget(self, action: #selector(didTapChat), for: .touchUpInside)
        return chatButton
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
    
    lazy var sendMessageButton: UIButton = {
        let sendMessageButton = UIButton()
        sendMessageButton.backgroundColor = .blue
        sendMessageButton.setTitle("  Enviar ", for: .normal)
        sendMessageButton.setTitleColor(.white, for: .normal)
        sendMessageButton.layer.cornerRadius = 10
        sendMessageButton.setContentHuggingPriority(.required, for: .horizontal)
        sendMessageButton.addTarget(self, action: #selector(messageSend), for: .touchUpInside)
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
    
    let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 36)
    
    private let viewModel: SolContactUsViewModel
    
    init (viewModel: SolContactUsViewModel){
        self.viewModel = viewModel
        super.init(nibName: "SolContactUsViewController", bundle: nil)
        self.viewModel.viewController = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        textView.text = "Escreva sua mensagem aqui"
        setButtonImages()
        setupConstraints()
        viewModel.fetchData()
    }
    
    func setButtonImages() {
        phoneButton.setImage(UIImage.init(systemName: "phone")?.withConfiguration(symbolConfiguration), for: .normal)
        emailButton.setImage(UIImage.init(systemName: "envelope")?.withConfiguration(symbolConfiguration), for: .normal)
        chatButton.setImage(UIImage.init(systemName: "message")?.withConfiguration(symbolConfiguration), for: .normal)
    }
    
    func setupConstraints() {
        [titleLabel, phoneButton, emailButton, chatButton, messageLabel, textView, sendMessageButton, closeButton].forEach { uiView in
            uiView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(uiView)
        }
        
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
    
    @objc
    func didTapPhone() {
        if let tel = model?.phone,
           let url = URL(string: "tel://\(tel)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc
    func didTapEmail() {
        if let mail = model?.mail,
           let url = URL(string: "mailto:\(mail)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc
    func didTapChat() {
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
    
    func showAlertMessage(title: String, message: String, dissmiss: Bool) {
        Globals.alertMessage(title: title, message: message, targetVC: self) {
            self.dismiss(animated: dissmiss)
        }
    }
    
    @objc
    func messageSend() {
        view.endEditing(true)
        let parameters = sendParameters()
        showLoadingView()
        viewModel.requestSendMessage(parameters: parameters)
    }
    
    func sendParameters() -> [String: String] {
        let email = model?.mail ?? ""
        if let message = textView.text, textView.text.count > 0 {
            let parameters: [String: String] = [
                "email": email,
                "mensagem": message
            ]
            return parameters
        }
        return [:]
    }
    
    func callLoadingView() {
        showLoading()
    }
    
    func callRemoveLoadingView() {
        removeLoadingView()
    }
    
    func showMessageReturnModel(result: ContactUsModel) {
        self.model = result
    }
    
    func displayAlertMessage(title: String, message: String, dissmiss: Bool) {
        self.showAlertMessage(title: title, message: message , dissmiss: dissmiss)
    }
    
    func displayGlobalAlertMessage() {
        Globals.alertMessage(title: "Ops..", message: "Ocorreu algum erro", targetVC: self)
    }
}

