import UIKit

protocol LuaContactUsViewProtocol {
    func configurePhoneButton(target: Any, selector: Selector)
    func configureEmailButton(target: Any, selector: Selector)
    func configureChatButton(target: Any, selector: Selector)
    func configureSendMessageButton(target: Any, selector: Selector)
    func configureCloseButton(target: Any, selector: Selector)
}

class LuaContactUsView: UIView, LuaContactUsViewProtocol {
    
    // MARK: - Lazy UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.text = "Escolha o canal para contato"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var phoneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 36)
        button.setImage(UIImage(systemName: "phone")?.withConfiguration(symbolConfiguration), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var emailButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 36)
        button.setImage(UIImage(systemName: "envelope")?.withConfiguration(symbolConfiguration), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var chatButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 36)
        button.setImage(UIImage(systemName: "message")?.withConfiguration(symbolConfiguration), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = "Ou envie uma mensagem"
        label.numberOfLines = 2
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = "Escreva sua mensagem aqui"
        textView.font = .systemFont(ofSize: 10)
        textView.backgroundColor = .systemGray5
        textView.layer.cornerRadius = 10
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private lazy var sendMessageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("  Enviar  ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Voltar", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    // MARK: - Setup UI
    private func setupView() {
        backgroundColor = .systemGray6
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        addSubviewsToContentView()
        addConstraintToUIElements()
    }
    
    private func addSubviewsToContentView() {
        [titleLabel, phoneButton, emailButton, chatButton, messageLabel, textView, sendMessageButton, closeButton ].forEach { contentView.addSubview($0) }
    }
    
    private func addConstraintToUIElements() {
        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Title Label
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Phone Button
            phoneButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            phoneButton.widthAnchor.constraint(equalToConstant: 80),
            phoneButton.heightAnchor.constraint(equalToConstant: 80),
            phoneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            // Email Button
            emailButton.centerYAnchor.constraint(equalTo: phoneButton.centerYAnchor),
            emailButton.widthAnchor.constraint(equalToConstant: 80),
            emailButton.heightAnchor.constraint(equalToConstant: 80),
            emailButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            // Chat Button
            chatButton.centerYAnchor.constraint(equalTo: phoneButton.centerYAnchor),
            chatButton.widthAnchor.constraint(equalToConstant: 80),
            chatButton.heightAnchor.constraint(equalToConstant: 80),
            chatButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Message Label
            messageLabel.topAnchor.constraint(equalTo: phoneButton.bottomAnchor, constant: 30),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // TextView
            textView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textView.heightAnchor.constraint(equalToConstant: 350),

            sendMessageButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            sendMessageButton.heightAnchor.constraint(equalToConstant: 40),
            sendMessageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            sendMessageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            closeButton.topAnchor.constraint(equalTo: sendMessageButton.bottomAnchor, constant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            closeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            closeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    // MARK: - Target configuration
    func configurePhoneButton(target: Any, selector: Selector){
        phoneButton.addTarget(target, action: selector, for: .touchUpInside)
    }
    func configureEmailButton(target: Any, selector: Selector){
        emailButton.addTarget(target, action: selector, for: .touchUpInside)
    }
    func configureChatButton(target: Any, selector: Selector){
        chatButton.addTarget(target, action: selector, for: .touchUpInside)
    }
    func configureSendMessageButton(target: Any, selector: Selector){
        sendMessageButton.addTarget(target, action: selector, for: .touchUpInside)
    }
    func configureCloseButton(target: Any, selector: Selector){
        closeButton.addTarget(target, action: selector, for: .touchUpInside)
    }
    
}

//#Preview {
//    LuaContactUsView()
//}
