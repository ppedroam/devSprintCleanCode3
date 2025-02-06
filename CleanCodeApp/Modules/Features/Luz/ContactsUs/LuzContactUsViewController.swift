import UIKit

final class LuzContactUsViewController: LoadingInheritageController {
    var model: ContactUsModel?
    let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 36)

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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        configureUI()
        setupConstraints()
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

    func setupConstraints() {
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
    func send() {
        view.endEditing(true)
        let email = model?.mail ?? ""
        if let message = textView.text, textView.text.count > 0 {
            let parameters: [String: String] = [
                "email": email,
                "mensagem": message
            ]
            showLoadingView()
            let url = Endpoints.sendMessage
            AF.shared.request(
                url,
                method: .post,
                parameters: parameters,
                headers: nil
            ) { result in
                self.removeLoadingView()
                switch result {
                case .success:
                    Globals.alertMessage(
                        title: "Sucesso..",
                        message: "Sua mensagem foi enviada",
                        targetVC: self
                    ) {
                        self.dismiss(animated: true)
                    }
                case .failure:
                    Globals.alertMessage(
                        title: "Ops..",
                        message: "Ocorreu algum erro",
                        targetVC: self
                    )
                }
            }
        }
    }

    // MARK: - private funcs
    private func open(appLink: AppLink) {
        guard let url = appLink.url else { return }

        if appLink.fallbackURL != nil, !UIApplication.shared.canOpenURL(url) {
            if let fallback = appLink.fallbackURL {
                UIApplication.shared.open(fallback, options: [:], completionHandler: nil)
            }
        } else {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

#Preview {
    LuzContactUsViewController()
}
