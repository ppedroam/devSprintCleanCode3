//
//  RumContactUsView.swift
//  CleanCode
//
//  Created by Rayana Prata Neves on 11/02/25.
//

import UIKit

final class RumContactUsView: UIView {
    // MARK: - UI Components
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = "Escreva sua mensagem aqui"
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        titleLabel.text = "Escolha o canal para contato"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    lazy var phoneButton: UIButton = {
        let phoneButton = UIButton()
        phoneButton.backgroundColor = .systemGray4
        phoneButton.layer.cornerRadius = 10
        phoneButton.translatesAutoresizingMaskIntoConstraints = false
        return phoneButton
    }()
    
    lazy var emailButton: UIButton = {
        let emailButton = UIButton()
        emailButton.backgroundColor = .systemGray4
        emailButton.layer.cornerRadius = 10
        emailButton.translatesAutoresizingMaskIntoConstraints = false
        return emailButton
    }()
    
    lazy var chatButton: UIButton = {
        let chatButton = UIButton()
        chatButton.backgroundColor = .systemGray4
        chatButton.layer.cornerRadius = 10
        chatButton.translatesAutoresizingMaskIntoConstraints = false
        return chatButton
    }()
    
    lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.textColor = .black
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        messageLabel.text = "Ou envie uma mensagem"
        messageLabel.numberOfLines = 2
        messageLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        return messageLabel
    }()
    
    lazy var sendMessageButton: UIButton = {
        let sendMessageButton = UIButton()
        sendMessageButton.backgroundColor = .blue
        sendMessageButton.setTitle("  Enviar ", for: .normal)
        sendMessageButton.setTitleColor(.white, for: .normal)
        sendMessageButton.layer.cornerRadius = 10
        sendMessageButton.setContentHuggingPriority(.required, for: .horizontal)
        sendMessageButton.translatesAutoresizingMaskIntoConstraints = false
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
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        return closeButton
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        backgroundColor = .systemGray6
        setupButtonImages()
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupButtonImages() {
        phoneButton.setSymbolImage(systemName: "phone", pointSize: 36)
        emailButton.setSymbolImage(systemName: "envelope", pointSize: 36)
        chatButton.setSymbolImage(systemName: "message", pointSize: 36)
    }
    
    private func setupHierarchy() {
        addSubview(titleLabel)
        addSubview(phoneButton)
        addSubview(emailButton)
        addSubview(chatButton)
        addSubview(messageLabel)
        addSubview(textView)
        addSubview(sendMessageButton)
        addSubview(closeButton)
    }
    
    private func setupConstraints() {
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
}
