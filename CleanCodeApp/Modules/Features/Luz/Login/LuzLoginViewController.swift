import UIKit

final class LuzLoginViewController: UIViewController {

    @IBOutlet weak var heightLabelError: NSLayoutConstraint!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var showPasswordButton: UIButton!

    var showPassword = true
    var errorInLogin = false
    
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
        #if DEBUG
            emailTextField.text = "clean.code@devpass.com"
            passwordTextField.text = "111111"
        #endif
    }

    func validateSession() {
        guard UserDefaultsManager.UserInfos.shared.readSesion() != nil else { return }
        setupHomeViewController()
    }

    func checkConnectionInternet() {
        if !ConnectivityManager.shared.isConnected {
            let alertController = UIAlertController(
                title: "Sem conexão",
                message: "Conecte-se à internet para tentar novamente",
                preferredStyle: .alert
            )
            let alertAction = UIAlertAction(
                title: "Ok",
                style: .default
            )
            alertController.addAction(alertAction)
            present(alertController, animated: true)
        }
    }

    // MARK: - IBActions
    @IBAction func loginDidTap(_ sender: Any) {
        checkConnectionInternet()
        emailTextField.setDefaultColor()
        passwordTextField.setDefaultColor()
        showLoading()

        AF.shared.request(
            Endpoints.Auth.login,
            method: .get,
            parameters: makeParams(),
            headers: nil
        ) { result in
            self.stopLoading()
            switch result {
            case .success(let data):
                self.handleSuccess(data)
            case .failure:
                self.handleError()
            }
        }
    }
    
    @IBAction func showPasswordDidTap(_ sender: Any) {
        showPassword.toggle()
        passwordTextField.isSecureTextEntry = !showPassword
        let imageName = showPassword ? "eye.slash" : "eye"
        showPasswordButton.setImage(
            UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
    }
    
    @IBAction func resetPasswordDidTap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "LuzUser", bundle: nil)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "LuzResetPasswordViewController"
        ) as! LuzResetPasswordViewController
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
    
    @IBAction func createAccountDidTap(_ sender: Any) {
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
        do {
            try LuzLoginEmailValidator.validate(emailTextField.text)
            enableButton()
        } catch {
            disableButton()
        }
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
    func handleSuccess(_ data: Data) {
        do {
            let session = try JSONDecoder().decode(Session.self, from: data)
            Task { @MainActor in self.setupHomeViewController() }
            UserDefaultsManager.UserInfos.shared.save(session: session, user: nil)
        } catch {
            debugPrint("error: \(error.localizedDescription)")
            self.showErrorAlert()
        }
    }

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

// MARK: - MakeParams
extension LuzLoginViewController {
    func makeParams() -> [String: String] {
        guard
            let emailTextField = emailTextField.text,
            let passwordTextField = passwordTextField.text
        else { return [:] }

        return [
            "email": emailTextField,
            "password": passwordTextField
        ]
    }
}

// MARK: - Setup HomeViewController
extension LuzLoginViewController {
    func setupHomeViewController() {
        let navigationController = UINavigationController(rootViewController: LuzHomeViewController())
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
