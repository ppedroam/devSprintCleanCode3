import UIKit

class CeuResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var recoverPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!

    @IBOutlet weak var verifyEmailLabel: UILabel!
    @IBOutlet weak var recoveryPasswordSuccessView: UIView!
    @IBOutlet weak var emailErrorLabel: UILabel!

    var email = ""
    var isEmailRecovered = false
    var ceuResetPasswordViewModel: CeuResetPasswordViewModel?
    var ceuResetPasswordCoordinator: CeuResetPasswordCoordinator?

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
        if isEmailRecovered {
            dismiss(animated: true)
        } else {
            ceuResetPasswordViewModel?.startRecoverPassword()
        }
    }

    @IBAction func loginButton(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func helpButton(_ sender: Any) {
        ceuResetPasswordCoordinator?.showContactUsViewController()
    }

    @IBAction func createAccountButton(_ sender: Any) {
        ceuResetPasswordCoordinator?.showCreateAccountViewController()
    }

    // MARK: - Reset Password Request functions
    func handleResetPasswordRequestSuccess() {
        self.isEmailRecovered = true
        self.emailTextfield.isHidden = true
        self.verifyEmailLabel.isHidden = true
        self.recoveryPasswordSuccessView.isHidden = false
        self.emailErrorLabel.text = self.emailTextfield.text?.trimmingCharacters(in: .whitespaces)
        self.recoverPasswordButton.titleLabel?.text = "REENVIAR E-MAIL"
        self.recoverPasswordButton.setTitle("Voltar", for: .normal)
    }

    func handleResetPasswordRequestError() {
        ceuResetPasswordCoordinator?.showAlert()
    }

    func validateForm() throws {
        guard let isEmailValid = emailTextfield.text?.isEmailValid() else {
            throw CeuCommonsErrors.invalidEmail
        }

        self.view.endEditing(true)

        guard isEmailValid else {
            emailTextfield.setErrorColor()
            verifyEmailLabel.textColor = .red
            verifyEmailLabel.text = "Verifique o e-mail informado"
            throw CeuCommonsErrors.invalidEmail
        }
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

        changeEmailTextfieldState()
    }

    func configureSupportClasses() {
        self.ceuResetPasswordViewModel = CeuResetPasswordViewModel(viewController: self)
        self.ceuResetPasswordCoordinator = CeuResetPasswordCoordinator(viewController: self)
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

        let emailTextExists = !email.isEmpty
        if emailTextExists {
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
        changeEmailTextfieldState()
    }

    @IBAction func emailEndEditing(_ sender: Any) {
        emailTextfield.setDefaultColor()
    }

    func changeEmailTextfieldState() {
        let emailTextfieldIsEmpty = emailTextfield.text!.isEmpty
        return updateRecoverPasswordButtonState(toEnabled: emailTextfieldIsEmpty)
    }

    func updateRecoverPasswordButtonState(toEnabled: Bool) {
        recoverPasswordButton.backgroundColor = toEnabled ? .blue : .gray
        recoverPasswordButton.setTitleColor(.white, for: .normal)
        recoverPasswordButton.isEnabled = toEnabled
    }
}

enum CeuCommonsErrors: Error {
    case invalidData
    case invalidEmail
    case networkError
}
