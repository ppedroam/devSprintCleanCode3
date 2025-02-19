import UIKit

final class ContactUSView: UIView {
    let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 36)

    lazy var textView: UITextView = {
        let text = UITextView()
        text.text = "Escreva sua mensagem aqui"
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.text = "Escolha o canal para contato"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = "Ou envie uma mensagem"
        label.numberOfLines = 2
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - UIButton's
    lazy var phoneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        button.setImage(
            .init(systemName: "phone")?.withConfiguration(symbolConfiguration),
            for: .normal
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var emailButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        button.setImage(
            .init(systemName: "envelope")?.withConfiguration(symbolConfiguration),
            for: .normal
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var chatButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        button.setImage(
            .init(systemName: "message")?.withConfiguration(symbolConfiguration),
            for: .normal
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var sendMessageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Enviar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var closeButton: UIButton = {
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray6
        configureUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        [
            titleLabel,
            phoneButton,
            emailButton,
            chatButton,
            messageLabel,
            textView,
            sendMessageButton,
            closeButton
        ].forEach { addSubview($0) }
    }

    func setupLayout() {
        let contactButtonsStackView = createContactButtonsStackView()
        let messageStackView = createMessageStackView()
        let ctaStackView = createCTAStackView()

        let mainStackView = UIStackView(
            arrangedSubviews: [
                titleLabel,
                contactButtonsStackView,
                messageStackView,
                ctaStackView
            ]
        )
        mainStackView.axis = .vertical
        mainStackView.spacing = 30
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(mainStackView)

        setupConstraints(for: mainStackView)
    }

    func setupConstraints(for mainStackView: UIStackView) {
        NSLayoutConstraint.activate(
            [
                mainStackView.topAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.topAnchor,
                    constant: 30
                ),
                mainStackView.leadingAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.leadingAnchor,
                    constant: 20
                ),
                mainStackView.trailingAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.trailingAnchor,
                    constant: -20
                ),
                mainStackView.bottomAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.bottomAnchor,
                    constant: -20
                )
            ]
        )
    }
}

private extension ContactUSView {
    func createContactButtonsStackView() -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [
                phoneButton,
                emailButton,
                chatButton
            ]
        )
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing

        [phoneButton, emailButton, chatButton].forEach { view in
            view.widthAnchor.constraint(equalToConstant: 80).isActive = true
            view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        }

        return stackView
    }

    func createMessageStackView() -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [
                messageLabel,
                textView
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }

    func createCTAStackView() -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [
                sendMessageButton,
                closeButton
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 20

        [sendMessageButton, closeButton].forEach { view in
            view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
        return stackView
    }
}
