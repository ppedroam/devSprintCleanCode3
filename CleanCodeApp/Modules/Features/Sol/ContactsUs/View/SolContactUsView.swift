//
//  SolContactUsView.swift
//  CleanCode
//
//  Created by Ely Assumpcao Ndiaye on 15/02/25.
//

import Foundation
import UIKit

protocol SolContactUsViewProtocol: AnyObject {
    func setupView()
    func setupConstraints()
}
extension  SolContactUsViewProtocol {
    func setupView() {
        setupConstraints()
    }
}

final class SolContactUsView: UIView, SolContactUsViewProtocol {
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
        return phoneButton
    }()
    
    lazy var emailButton: UIButton = {
        let emailButton = UIButton()
        emailButton.backgroundColor = .systemGray4
        emailButton.layer.cornerRadius = 10
        return emailButton
    }()
    
    lazy var chatButton: UIButton = {
        let chatButton = UIButton()
        chatButton.backgroundColor = .systemGray4
        chatButton.layer.cornerRadius = 10
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
        return closeButton
    }()
    
    let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 36)
    
    override init(frame: CGRect) {
           super.init(frame: frame)
        setButtonImages()
        setupConstraints()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
   private func setButtonImages() {
        phoneButton.setImage(UIImage.init(systemName: "phone")?.withConfiguration(symbolConfiguration), for: .normal)
        emailButton.setImage(UIImage.init(systemName: "envelope")?.withConfiguration(symbolConfiguration), for: .normal)
        chatButton.setImage(UIImage.init(systemName: "message")?.withConfiguration(symbolConfiguration), for: .normal)
    }
    
     func setupConstraints() {
        [titleLabel, phoneButton, emailButton, chatButton, messageLabel, textView, sendMessageButton, closeButton].forEach { uiView in
            uiView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uiView)
        }
        
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
            //            stackView.heightAnchor.constraint(equalToConstant: 30),
            
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
    
    func configureActionsButtonsByType(target: Any, action: Selector, viewAction: CaseActionButtonType) {
        switch viewAction {
        case .phoneButton:
            phoneButton.addTarget(target, action: action, for: .touchUpInside)
        case .emailButton:
            emailButton.addTarget(target, action: action, for: .touchUpInside)
        case .chatButton:
            chatButton.addTarget(target, action: action, for: .touchUpInside)
        case .sendMessageButton :
            sendMessageButton.addTarget(target, action:action, for: .touchUpInside)
        case .closeButton:
            closeButton.addTarget(target, action: action, for: .touchUpInside)
        }
    }
}


enum CaseActionButtonType {
    case phoneButton
    case emailButton
    case chatButton
    case sendMessageButton
    case closeButton
}
