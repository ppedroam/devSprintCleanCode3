import UIKit

class CeuResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var recoverPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var viewSuccess: UIView!
    @IBOutlet weak var emailLabel: UILabel!

    var email = ""
    var recoveryEmail = false
    var viewModel: CeuResetPasswordViewModel?
    var coordinator: CeuResetPasswordCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureSupportClasses()
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - IBAction functions
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func recoverPasswordButton(_ sender: Any) {
        if recoveryEmail {
            dismiss(animated: true)
        } else {
            viewModel?.startRecoverPassword()
        }
    }

    @IBAction func loginButton(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func helpButton(_ sender: Any) {
        coordinator?.setupContactUsViewController()
    }

    @IBAction func createAccountButton(_ sender: Any) {
        coordinator?.setupCreateAccountViewController()
    }

    // MARK: - Reset Password Request functions
    func handleResetPasswordRequestSuccess() {
        self.recoveryEmail = true
        self.emailTextfield.isHidden = true
        self.textLabel.isHidden = true
        self.viewSuccess.isHidden = false
        self.emailLabel.text = self.emailTextfield.text?.trimmingCharacters(in: .whitespaces)
        self.recoverPasswordButton.titleLabel?.text = "REENVIAR E-MAIL"
        self.recoverPasswordButton.setTitle("Voltar", for: .normal)
    }

    func handleResetPasswordRequestError() {
        coordinator?.showAlert()
    }

    func validateForm() throws {
        guard let status = viewModel?.setupStatus(text: emailTextfield.text) else {
            throw CeuCommonsErrors.invalidEmail
        }

        if status {
            emailTextfield.setErrorColor()
            textLabel.textColor = .red
            textLabel.text = "Verifique o e-mail informado"
            throw CeuCommonsErrors.invalidEmail
        }

        self.view.endEditing(true)
    }
}

// MARK: - Comportamentos de layout
extension CeuResetPasswordViewController {

    // MARK: - Setup Views
    func setupView() {
        setupRecoverPasswordButton()
        setupLoginButton()
        setupHelpButton()
        setupCreateAccountButton()
        setupEmailTextfield()

        validateButton()
    }

    func configureSupportClasses() {
        self.viewModel = CeuResetPasswordViewModel(viewController: self)
        self.coordinator = CeuResetPasswordCoordinator(viewController: self)
    }

    private func setupRecoverPasswordButton() {
        recoverPasswordButton.layer.cornerRadius = recoverPasswordButton.bounds.height / 2
        recoverPasswordButton.backgroundColor = .blue
        recoverPasswordButton.setTitleColor(.white, for: .normal)
    }

    private func setupLoginButton() {
        loginButton.layer.cornerRadius = createAccountButton.frame.height / 2
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.blue.cgColor
        loginButton.setTitleColor(.blue, for: .normal)
        loginButton.backgroundColor = .white
    }

    private func setupHelpButton() {
        helpButton.layer.cornerRadius = createAccountButton.frame.height / 2
        helpButton.layer.borderWidth = 1
        helpButton.layer.borderColor = UIColor.blue.cgColor
        helpButton.setTitleColor(.blue, for: .normal)
        helpButton.backgroundColor = .white
    }

    private func setupCreateAccountButton() {
        createAccountButton.layer.cornerRadius = createAccountButton.frame.height / 2
        createAccountButton.layer.borderWidth = 1
        createAccountButton.layer.borderColor = UIColor.blue.cgColor
        createAccountButton.setTitleColor(.blue, for: .normal)
        createAccountButton.backgroundColor = .white
    }

    private func setupEmailTextfield() {
        emailTextfield.setDefaultColor()

        if !email.isEmpty {
            emailTextfield.text = email
            emailTextfield.isEnabled = false
        }
    }

    // MARK: - Email TextField Editing Functions
    @IBAction func emailBeginEditing(_ sender: Any) {
        emailTextfield.setEditingColor()
    }

    @IBAction func emailEditing(_ sender: Any) {
        emailTextfield.setEditingColor()
        validateButton()
    }

    @IBAction func emailEndEditing(_ sender: Any) {
        emailTextfield.setDefaultColor()
    }

    func validateButton() {
        if emailTextfield.text!.isEmpty {
            return createButtonIs(enable: false)
        }
        return createButtonIs(enable: true)
    }

    func createButtonIs(enable: Bool) {
        recoverPasswordButton.backgroundColor = enable ? .blue : .gray
        recoverPasswordButton.setTitleColor(.white, for: .normal)
        recoverPasswordButton.isEnabled = enable
    }
}

enum CeuCommonsErrors: Error {
    case invalidData
    case invalidEmail
    case networkError
}
