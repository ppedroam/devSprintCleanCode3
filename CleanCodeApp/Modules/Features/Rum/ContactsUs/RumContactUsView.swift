//
//  RumContactUsView.swift
//  CleanCode
//
//  Created by Rayana Prata Neves on 11/02/25.
//

import UIKit

final class RumContactUsView: UIView {
    // MARK: - UI Components
    
    lazy var headerStackView: UIStackView = {
        let headerStackView = UIStackView()
        headerStackView.axis = .vertical
        headerStackView.spacing = 30
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        return headerStackView
    }()
    
    lazy var headerButtonsStackView: UIStackView = {
        let headerButtonsStackView = UIStackView()
        headerButtonsStackView.axis = .horizontal
        headerButtonsStackView.distribution = .equalCentering
        headerButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        return headerButtonsStackView
    }()
    
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
    
    lazy var centerStackView: UIStackView = {
        let centerStackView = UIStackView()
        centerStackView.axis = .vertical
        centerStackView.spacing = 20
        centerStackView.translatesAutoresizingMaskIntoConstraints = false
        return centerStackView
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
    
    lazy var bottomStackView: UIStackView = {
        let bottomStackView = UIStackView()
        bottomStackView.axis = .vertical
        bottomStackView.spacing = 20
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        return bottomStackView
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
        headerStackView.addArrangedSubviews(titleLabel, headerButtonsStackView)
        headerButtonsStackView.addArrangedSubviews(phoneButton, emailButton, chatButton)
        centerStackView.addArrangedSubviews(messageLabel, textView)
        bottomStackView.addArrangedSubviews(sendMessageButton, closeButton)
        addSubview(headerStackView)
        addSubview(centerStackView)
        addSubview(bottomStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            headerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            headerButtonsStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 30),
            headerButtonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            headerButtonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            headerButtonsStackView.heightAnchor.constraint(equalToConstant: 80),
            
            phoneButton.widthAnchor.constraint(equalToConstant: 80),
            emailButton.widthAnchor.constraint(equalToConstant: 80),
            chatButton.widthAnchor.constraint(equalToConstant: 80),
            
            centerStackView.topAnchor.constraint(equalTo: headerButtonsStackView.bottomAnchor, constant: 30),
            centerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            centerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            centerStackView.bottomAnchor.constraint(equalTo: sendMessageButton.topAnchor, constant: -30),
            
            bottomStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            bottomStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bottomStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            sendMessageButton.heightAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
