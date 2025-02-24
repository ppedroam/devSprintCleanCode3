import UIKit

final class LuzContactUsViewController: LoadingInheritageController {
    var model: ContactUsModel?
    private let viewModel: LuzContactUSViewModel
    private let contactUSView = ContactUSView()

    init(viewModel: LuzContactUSViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonActions()
        fetch()
    }

    override func loadView() {
        view = contactUSView
    }

    func setupButtonActions() {
        contactUSView.emailButton.addTarget(
            self,
            action: #selector(emailDipTap),
            for: .touchUpInside
        )
        contactUSView.chatButton.addTarget(
            self,
            action: #selector(chatDidTap),
            for: .touchUpInside
        )
        contactUSView.sendMessageButton.addTarget(
            self,
            action: #selector(send),
            for: .touchUpInside
        )
        contactUSView.closeButton.addTarget(
            self,
            action: #selector(close),
            for: .touchUpInside
        )
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
        Task {
            do {
                try await viewModel.fetch()
            } catch {
                handleError(error)
            }
        }
    }

    private func handleError(_ error: Error) {
        print("error api: \(error.localizedDescription)")
        showAlertError()
    }

    @objc
    func send() {
        view.endEditing(true)

        guard
            let message = contactUSView.textView.text, message.isEmpty == false
        else { return }
        let email = model?.mail ?? ""

        let parameters: [String: String] = [
            "email": email,
            "mensagem": message
        ]

        showLoadingView()

        Task {
            do {
                try await viewModel.send(parameters: parameters)
            } catch {
                showAlertError()
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
}

//#Preview {
//    LuzContactUsViewController()
//}
