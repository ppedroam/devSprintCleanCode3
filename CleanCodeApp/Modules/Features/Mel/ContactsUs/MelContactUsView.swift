//
//  MelContactUsView.swift
//  CleanCode
//
//  Created by Bruno Moura on 11/02/25.
//

import UIKit

protocol MelContactUsViewDelegate: AnyObject {
    func didTapPhoneCallButton()
    func didTapEmailButton()
    func didTapChatButton()
    func didTapSendMessageButton(message: String)
    func didTapCloseButton()
}

class MelContactUsView: UIView {
    
    private weak var delegate: MelContactUsViewDelegate?
    
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = MelContactUsStrings.placeholderMessage.rawValue
        return textView
    }()
    
    private lazy var channelTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.text = MelContactUsStrings.contactChannelTitle.rawValue
        return label
    }()
    
    private lazy var phoneCallButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapPhoneCallButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapEmailButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var chatButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapChatButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var alternativeMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = MelContactUsStrings.alternativeMessageText.rawValue
        label.numberOfLines = 2
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var sendMessageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.setTitle(MelContactUsStrings.sendActionTitle.rawValue, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.addTarget(self, action: #selector(didTapSendMessageButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(MelContactUsStrings.backActionTitle.rawValue, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
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
extension MelContactUsView {
    @objc
    private func didTapPhoneCallButton() {
        delegate?.didTapPhoneCallButton()
    }
    
    @objc
    private func didTapEmailButton() {
        delegate?.didTapEmailButton()
    }
    
    @objc
    private func didTapChatButton() {
        delegate?.didTapChatButton()
    }
    
    @objc
    private func didTapSendMessageButton() {
        endEditing(true)
        delegate?.didTapSendMessageButton(message: messageTextView.text)
    }
    
    @objc
    private func didTapCloseButton() {
        delegate?.didTapCloseButton()
    }
}

// MARK: - Functions
extension MelContactUsView {
    public func setDelegate(delegate: MelContactUsViewDelegate?) {
        self.delegate = delegate
    }
    
    private func configureButtonSymbols() {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 36)
        setButtonImage(phoneCallButton,
                             with: MelSystemImage.phone.rawValue,
                             buttonSymbolConfiguration: symbolConfig)
        setButtonImage(emailButton,
                             with: MelSystemImage.envelope.rawValue,
                             buttonSymbolConfiguration: symbolConfig)
        setButtonImage(chatButton,
                             with: MelSystemImage.message.rawValue,
                             buttonSymbolConfiguration: symbolConfig)
    }
    
    private func setButtonImage(_ button: UIButton, with systemNameImage: String, buttonSymbolConfiguration: UIImage.SymbolConfiguration) {
        let image = UIImage(systemName: systemNameImage)?.withConfiguration(buttonSymbolConfiguration)
        button.setImage(image, for: .normal)
    }
}

// MARK: - ViewCode Protocol Conformance
extension MelContactUsView: MelViewCode {
    func addSubviews() {
        addSubview(channelTitleLabel)
        addSubview(phoneCallButton)
        addSubview(emailButton)
        addSubview(chatButton)
        addSubview(alternativeMessageLabel)
        addSubview(messageTextView)
        addSubview(sendMessageButton)
        addSubview(closeButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            channelTitleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            channelTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            channelTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            phoneCallButton.topAnchor.constraint(equalTo: channelTitleLabel.bottomAnchor, constant: 30),
            emailButton.centerYAnchor.constraint(equalTo: phoneCallButton.centerYAnchor),
            chatButton.centerYAnchor.constraint(equalTo: phoneCallButton.centerYAnchor),
            
            phoneCallButton.widthAnchor.constraint(equalToConstant: 80),
            phoneCallButton.heightAnchor.constraint(equalToConstant: 80),
            phoneCallButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            emailButton.widthAnchor.constraint(equalToConstant: 80),
            emailButton.heightAnchor.constraint(equalToConstant: 80),
            emailButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            chatButton.widthAnchor.constraint(equalToConstant: 80),
            chatButton.heightAnchor.constraint(equalToConstant: 80),
            chatButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            alternativeMessageLabel.topAnchor.constraint(equalTo: phoneCallButton.bottomAnchor, constant: 30),
            alternativeMessageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            alternativeMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            messageTextView.topAnchor.constraint(equalTo: alternativeMessageLabel.bottomAnchor, constant: 20),
            messageTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            messageTextView.bottomAnchor.constraint(equalTo: sendMessageButton.topAnchor, constant: -30),
            
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
        configureButtonSymbols()
    }
}
