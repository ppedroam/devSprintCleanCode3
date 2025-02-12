import UIKit

final class LuzContactUsViewController: LoadingInheritageController {
    private var model: ContactUsModel?
    private let symbolConfiguration: UIImage.SymbolConfiguration

    // MARK: - TextView
    private lazy var textView: UITextView = {
        let text = UITextView()
        text.text = "Escreva sua mensagem aqui"
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()

    // MARK: - UILabel's
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.text = "Escolha o canal para contato"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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

    // MARK: - UIButton's
    private lazy var phoneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        button.addTarget(
            self,
            action: #selector(phoneDidTap),
            for: .touchUpInside
        )
        button.setImage(
            .init(systemName: "phone")?.withConfiguration(symbolConfiguration),
            for: .normal
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var emailButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        button.addTarget(
            self,
            action: #selector(emailDipTap),
            for: .touchUpInside
        )
        button.setImage(
            .init(systemName: "envelope")?.withConfiguration(symbolConfiguration),
            for: .normal
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var chatButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        button.addTarget(
            self,
            action: #selector(chatDidTap),
            for: .touchUpInside
        )
        button.setImage(
            .init(systemName: "message")?.withConfiguration(symbolConfiguration),
            for: .normal
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var sendMessageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Enviar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.addTarget(
            self,
            action: #selector(send),
            for: .touchUpInside
        )
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
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(
        model: ContactUsModel?,
        symbolConfiguration: UIImage.SymbolConfiguration
    ) {
        self.model = model
        self.symbolConfiguration = symbolConfiguration
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        configureUI()
        setupLayout()
        fetch()
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
        ].forEach { view.addSubview($0) }
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

        view.addSubview(mainStackView)

        setupConstraints(for: mainStackView)
    }

    func setupConstraints(for mainStackView: UIStackView) {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    @objc
    func phoneDidTap() {
        guard let phone = model?.phone else { return }
        open(appLink: .phone(phone))
    }

    @objc
    func emailDipTap() {
        guard let email = model?.mail else { return }
        open(appLink: .email(email))
    }

    @objc
    func chatDidTap() {
        guard let phone = model?.phone else { return }
        open(appLink: .whatsapp(phone))
    }

    @objc
    func close() {
        dismiss(animated: true)
    }

    func fetch() {
        showLoadingView()
        AF.shared.request(
            Endpoints.contactUs,
            method: .get,
            parameters: nil,
            headers: nil
        ) { result in
            self.removeLoadingView()
            switch result {
            case .success(let data):
                self.handleSuccess(data: data)
            case .failure(let error):
                self.handleError(error)
            }
        }
    }

    @objc
    func send() {
        view.endEditing(true)
        let email = model?.mail ?? ""
        if let message = textView.text, textView.text.count > 0 {
            let parameters: [String: String] = [
                "email": email,
                "mensagem": message
            ]
            showLoadingView()
            AF.shared.request(
                Endpoints.sendMessage,
                method: .post,
                parameters: parameters,
                headers: nil
            ) { result in
                self.removeLoadingView()
                switch result {
                case .success:
                    self.showAlertSuccess()
                case .failure:
                    self.showAlertError()
                }
            }
        }
    }

    // MARK: - private funcs
    private func open(appLink: AppLink) {
        guard let url = appLink.url else { return }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(
                url,
                options: [:],
                completionHandler: nil
            )
        } else if let fallback = appLink.fallbackURL {
            UIApplication.shared.open(
                fallback,
                options: [:],
                completionHandler: nil
            )
        }
    }

    private func showAlertSuccess() {
        Globals.alertMessage(
            title: "Sucesso..",
            message: "Sua mensagem foi enviada",
            targetVC: self
        ) {
            self.dismiss(animated: true)
        }
    }

    private func showAlertError() {
        Globals.alertMessage(
            title: "Ops..",
            message: "Ocorreu algum erro",
            targetVC: self
        ) {
            self.dismiss(animated: true)
        }
    }

    // MARK: - Handlers
    private func handleSuccess(data: Data) {
        return if let returned = try? JSONDecoder().decode(
            ContactUsModel.self,
            from: data
        ) {
            self.model = returned
        } else {
            showAlertError()
        }
    }

    private func handleError(_ error: Error) {
        print("error api: \(error.localizedDescription)")
        showAlertError()
    }
}

// MARK: - StackView's
extension LuzContactUsViewController {
    private func createContactButtonsStackView() -> UIStackView {
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

    private func createMessageStackView() -> UIStackView {
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

    private func createCTAStackView() -> UIStackView {
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

//#Preview {
//    LuzContactUsViewController()
//}
