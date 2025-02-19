import UIKit

final class LuzLoginViewController: UIViewController {
    private let viewModel: LuzLoginViewModel

    @IBOutlet weak var heightLabelError: NSLayoutConstraint!
    @IBOutlet weak var errorLabel: UILabel!

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var showPasswordButton: UIButton!

    var showPassword = true
    var errorInLogin = false

    init(viewModel: LuzLoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDebugConfiguration()
        setupView()
        validateSession()
        validateButton()
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func setupDebugConfiguration() {
        viewModel.setupDebugConfiguration(
            for: emailTextField,
            passwordTextField: passwordTextField
        )
    }

    func validateSession() {
        viewModel.validateSession { [weak self] in
            self?.setupHomeViewController()
        }
    }

    func checkConnectionInternet() {
        viewModel.checkConnectionInternet { [weak self] alert in
            self?.present(alert, animated: true)
        }
    }

    // MARK: - IBActions
    @IBAction func didTapLogin(_ sender: Any) {
        checkConnectionInternet()
        emailTextField.setDefaultColor()
        passwordTextField.setDefaultColor()
        showLoading()

        Task {
            do {
                let data = try await viewModel.login(
                    email: emailTextField.text,
                    password: passwordTextField.text
                )
                stopLoading()
                try viewModel.handleLoginSuccess(data: data)
                Task { @MainActor in self.setupHomeViewController() }
            } catch {
                debugPrint("error: \(error.localizedDescription)")
                handleError()
            }
        }
    }

    @IBAction func didTapShowPassword(_ sender: Any) {
        showPassword.toggle()
        passwordTextField.isSecureTextEntry = !showPassword
        let imageName = showPassword ? "eye.slash" : "eye"
        showPasswordButton.setImage(
            UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
    }

    @IBAction func didTapResetPassword(_ sender: Any) {
        let viewController = LuzResetPasswordFactory.make()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }


    @IBAction func didTapCreateAccount(_ sender: Any) {
        let controller = LuzCreateAccountViewController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
}

// MARK: - Setup View
private extension LuzLoginViewController {
    func setupView() {
        configureUI()
        configureGestureRecognizer()
        validateButton()
    }

    func configureUI() {
        heightLabelError.constant = 0
        configureButton(for: loginButton, backgroundColor: .blue, titleColor: .white)
        configureBorderButton(for: createAccountButton, borderColor: .blue)
        showPasswordButton.tintColor = .lightGray
        emailTextField.setDefaultColor()
        passwordTextField.setDefaultColor()
    }

    func configureButton(
        for button: UIButton,
        backgroundColor: UIColor,
        titleColor: UIColor
    ) {
        button.layer.cornerRadius = button.frame.height / 2
        button.backgroundColor = backgroundColor
        button.setTitleColor(titleColor, for: .normal)
        button.isEnabled = true
    }

    func configureBorderButton(
        for button: UIButton,
        borderColor: UIColor
    ) {
        button.layer.cornerRadius = button.frame.height / 2
        button.layer.borderWidth = 1
        button.layer.borderColor = borderColor.cgColor
        button.setTitleColor(borderColor, for: .normal)
        button.backgroundColor = .white
    }

    func configureGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(viewDidTap)
        )
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc
    func viewDidTap() {
        view.endEditing(true)
    }

    @IBAction func emailBeginEditing(_ sender: Any) {
        errorInLogin ? resetErrorLogin(emailTextField) : emailTextField.setEditingColor()
    }

    @IBAction func emailEditing(_ sender: Any) {
        validateButton()
    }

    @IBAction func emailEndEditing(_ sender: Any) {
        emailTextField.setDefaultColor()
    }

    @IBAction func passwordBeginEditing(_ sender: Any) {
        errorInLogin ? resetErrorLogin(passwordTextField) : passwordTextField.setEditingColor()
    }

    @IBAction func passwordEditing(_ sender: Any) {
        validateButton()
    }

    @IBAction func passwordEndEditing(_ sender: Any) {
        passwordTextField.setDefaultColor()
    }

    func setErrorLogin(_ message: String) {
        errorInLogin = true
        heightLabelError.constant = 20
        errorLabel.text = message
        emailTextField.setErrorColor()
        passwordTextField.setErrorColor()
    }

    func resetErrorLogin(_ textField: UITextField) {
        heightLabelError.constant = 0
        if textField == emailTextField {
            emailTextField.setEditingColor()
            passwordTextField.setDefaultColor()
        } else {
            emailTextField.setDefaultColor()
            passwordTextField.setDefaultColor()
        }
    }
}

// MARK: - Validate
extension LuzLoginViewController {
    func validateButton() {
        viewModel.validateButton(
            email: emailTextField.text,
            enable: enableButton,
            disable: disableButton
        )
    }

    func disableButton() {
        loginButton.backgroundColor = .gray
        loginButton.isEnabled = false
    }

    func enableButton() {
        loginButton.backgroundColor = .blue
        loginButton.isEnabled = true
    }
}

// MARK: - Handlers
extension LuzLoginViewController {
    func handleError() {
        setErrorLogin("E-mail ou senha incorretos")
        showErrorAlert()
    }

    func showErrorAlert() {
        Globals.alertMessage(
            title: "Ops..",
            message: "Houve um problema, tente novamente mais tarde.",
            targetVC: self
        )
    }
}

// MARK: - Setup HomeViewController
extension LuzLoginViewController {
    func setupHomeViewController() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let homeCoordinator = LuzHomeCoordinator(window: window)
        homeCoordinator.start()
    }
}
