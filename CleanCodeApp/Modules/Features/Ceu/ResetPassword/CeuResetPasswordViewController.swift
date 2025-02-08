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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
            startRecoverPassword()
        }
    }

    @IBAction func loginButton(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func helpButton(_ sender: Any) {
        let viewController = setupContactUsViewController()
        self.present(viewController, animated: true, completion: nil)
    }

    @IBAction func createAccountButton(_ sender: Any) {
        let viewController = setupCreateAccountViewController()
        present(viewController, animated: true)
    }

    // MARK: - Reset Password Request functions

    private func makeResetPasswordRequest(parameters: [String : String]) {
        BadNetworkLayer.shared.resetPassword(self, parameters: parameters) { (success) in
            if success {
                return self.handleResetPasswordRequestSuccess()
            }
            self.handleResetPasswordRequestError()
        }
    }

    private func handleResetPasswordRequestSuccess() {
        self.recoveryEmail = true
        self.emailTextfield.isHidden = true
        self.textLabel.isHidden = true
        self.viewSuccess.isHidden = false
        self.emailLabel.text = self.emailTextfield.text?.trimmingCharacters(in: .whitespaces)
        self.recoverPasswordButton.titleLabel?.text = "REENVIAR E-MAIL"
        self.recoverPasswordButton.setTitle("Voltar", for: .normal)
    }

    private func handleResetPasswordRequestError() {
        let alertController = UIAlertController(title: "Ops..", message: "Algo de errado aconteceu. Tente novamente mais tarde.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }

    private func setupResetPasswordRequestParameters() throws -> [String: String] {
        guard let text = emailTextfield.text else { throw CommonsErros.invalidData }

        let emailUser = text.trimmingCharacters(in: .whitespaces)
        let parameters = [
            "email": emailUser
        ]

        return parameters
    }

    private func setupContactUsViewController() -> UIViewController {
        let viewController = CeuContactUsViewController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .coverVertical

        return viewController
    }

    private func setupCreateAccountViewController() -> UIViewController {
        let viewController = CeuCreateAccountViewController()
        viewController.modalPresentationStyle = .fullScreen

        return viewController
    }

    private func setupStatus() -> Bool {
        let status = emailTextfield.text!.isEmpty ||
        !emailTextfield.text!.contains(".") ||
        !emailTextfield.text!.contains("@") ||
        emailTextfield.text!.count <= 5

        return status
    }

    private func startRecoverPassword() {
        do {
            try validateForm()
            try verifyInternet()

            let parameters = try setupResetPasswordRequestParameters()
            makeResetPasswordRequest(parameters: parameters)
        } catch CommonsErros.invalidEmail {
            showAlert(message: "Verifique o e-mail informado.")
        } catch {
            showAlert(message: "Algo de errado aconteceu. Tente novamente mais tarde.")
        }
    }

    private func showAlert(message: String) {
        return Globals.alertMessage(title: "Ops...", message: message, targetVC: self)
    }

    private func verifyInternet() throws {
        if !ConnectivityManager.shared.isConnected {
            Globals.showNoInternetCOnnection(controller: self)
            throw CommonsErros.networkError
        }
    }

    private func validateForm() throws {
        let status = setupStatus()

        if status {
            emailTextfield.setErrorColor()
            textLabel.textColor = .red
            textLabel.text = "Verifique o e-mail informado"
            throw CommonsErros.invalidEmail
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
}

extension CeuResetPasswordViewController {

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


enum CommonsErros: Error {
    case invalidData
    case invalidEmail
    case networkError
}
