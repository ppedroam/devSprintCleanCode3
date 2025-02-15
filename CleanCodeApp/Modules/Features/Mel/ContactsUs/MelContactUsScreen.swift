//
//  MelContactUsScreen.swift
//  CleanCode
//
//  Created by Bruno Moura on 11/02/25.
//

import UIKit

protocol MelContactUsScreenDelegate: AnyObject {
    func didTapPhoneButton()
    func didTapEmailButton()
    func didTapChatButton()
    func didTapSendMessageButton(message: String)
    func didTapCloseButton()
}

class MelContactUsScreen: UIView {
    
    private weak var delegate: MelContactUsScreenDelegate?
    
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
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(Self.self, "- Deallocated")
    }
}

// MARK: - Button actions
extension MelContactUsScreen {
    @objc
    private func phoneClick() {
        delegate?.didTapPhoneButton()
    }
    
    @objc
    private func emailClick() {
        delegate?.didTapEmailButton()
    }
    
    @objc
    private func chatClicked() {
        delegate?.didTapChatButton()
    }
    
    @objc
    private func messageSend() {
        endEditing(true)
        delegate?.didTapSendMessageButton(message: textView.text)
    }
    
    @objc
    private func close() {
        delegate?.didTapCloseButton()
    }
}

// MARK: - Functions
extension MelContactUsScreen {
    public func configureDelegate(delegate: MelContactUsScreenDelegate?) {
        self.delegate = delegate
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
}

// MARK: - ViewCode Protocol Conformance
extension MelContactUsScreen: MelViewCode {
    func addSubviews() {
        addSubview(titleLabel)
        addSubview(phoneButton)
        addSubview(emailButton)
        addSubview(chatButton)
        addSubview(messageLabel)
        addSubview(textView)
        addSubview(sendMessageButton)
        addSubview(closeButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            phoneButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            emailButton.centerYAnchor.constraint(equalTo: phoneButton.centerYAnchor),
            chatButton.centerYAnchor.constraint(equalTo: phoneButton.centerYAnchor),
            
            phoneButton.widthAnchor.constraint(equalToConstant: 80),
            phoneButton.heightAnchor.constraint(equalToConstant: 80),
            phoneButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            emailButton.widthAnchor.constraint(equalToConstant: 80),
            emailButton.heightAnchor.constraint(equalToConstant: 80),
            emailButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            chatButton.widthAnchor.constraint(equalToConstant: 80),
            chatButton.heightAnchor.constraint(equalToConstant: 80),
            chatButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: phoneButton.bottomAnchor, constant: 30),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            textView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: sendMessageButton.topAnchor, constant: -30),
            
            sendMessageButton.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -20),
            sendMessageButton.heightAnchor.constraint(equalToConstant: 40),
            sendMessageButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            sendMessageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            closeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
    
    func setupStyle() {
        backgroundColor = .systemGray6
        symbolConfiguration()
    }
}
