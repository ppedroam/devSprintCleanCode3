import UIKit

final class LuzResetPasswordViewController: UIViewController {

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
        configureUI()
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - IBActions
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func recoverPasswordDidTap(_ sender: Any) {
        if recoveryEmail {
            dismiss(animated: true)
            return
        }

        do {
            try FormValidator.validateEmail(emailTextfield.text)
            try ConnectivityValidator.checkInternetConnection()
        } catch {
            handleError(error)
            return
        }

        self.view.endEditing(true)

        BadNetworkLayer
            .shared
            .resetPassword(
                self,
                parameters: makeParams()
            ) { success in
                guard success else {
                    self.showErrorAlert()
                    return
                }
                self.handleSucess()
            }
    }

    @IBAction func helpDidTap(_ sender: Any) {
        let vc = LuzContactUsFactory.make()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func createAccountDidTap(_ sender: Any) {
        let newVc = LuzCreateAccountViewController()
        newVc.modalPresentationStyle = .fullScreen
        present(newVc, animated: true)
    }

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

// MARK: - Setup View
private extension LuzResetPasswordViewController {

    func configureUI() {
        buttonStyle(
            for: recoverPasswordButton,
            backgroundColor: .blue,
            textColor: .white
        )
        buttonOutlineStyle(for: loginButton)
        buttonOutlineStyle(for: helpButton)
        buttonOutlineStyle(for: createAccountButton)
        emailTextfield.setDefaultColor()

        if !email.isEmpty {
            emailTextfield.text = email
            emailTextfield.isEnabled = false
        }
        validateButton()
    }

    func buttonStyle(
        for button: UIButton,
        backgroundColor: UIColor,
        textColor: UIColor
    ) {
        button.layer.cornerRadius = button.bounds.height / 2
        button.backgroundColor = backgroundColor
        button.setTitleColor(textColor, for: .normal)
    }

    func buttonOutlineStyle(for button: UIButton) {
        button.layer.cornerRadius = createAccountButton.bounds.height / 2
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .white
    }
}

// MARK: - Validations
private extension LuzResetPasswordViewController {
    func validateButton() {
        if !emailTextfield.text!.isEmpty {
            enableCreateButton()
        } else {
            disableCreateButton()
        }
    }

    func disableCreateButton() {
        recoverPasswordButton.backgroundColor = .gray
        recoverPasswordButton.setTitleColor(.white, for: .normal)
        recoverPasswordButton.isEnabled = false
    }

    func enableCreateButton() {
        recoverPasswordButton.backgroundColor = .blue
        recoverPasswordButton.setTitleColor(.white, for: .normal)
        recoverPasswordButton.isEnabled = true
    }
}

// MARK: Handlers
private extension LuzResetPasswordViewController {
    func handleSucess() {
        self.recoveryEmail = true
        self.emailTextfield.isHidden = true
        self.textLabel.isHidden = true
        self.viewSuccess.isHidden = false
        self.emailLabel.text = self.emailTextfield.text?.trimmingCharacters(in: .whitespaces)
        self.recoverPasswordButton.titleLabel?.text = "REENVIAR E-MAIL"
        self.recoverPasswordButton.setTitle("Voltar", for: .normal)
    }

    func showErrorAlert() {
        let alertController = UIAlertController(
            title: "Ops..",
            message: "Algo de errado aconteceu. Tente novamente mais tarde.",
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }

    func handleError(_ error: Error) {
        emailTextfield.setErrorColor()
        textLabel.textColor = .red

        switch error {
        case ValidationError.emptyEmail:
            return textLabel.text = "E-mail não pode estar vazio"
        case ValidationError.invalidFormat:
            return textLabel.text = "Verifique o email informado"
        case ConnectivityError.noInternet:
            return Globals.showNoInternetCOnnection(controller: self)
        default:
            textLabel.text = "Ocorreu um erro inesperado"
        }
    }
}

// MARK: Make Params
private extension LuzResetPasswordViewController {
    func makeParams() -> [String: String] {
        let email = emailTextfield.text!.trimmingCharacters(in: .whitespaces)
        return [
            "email" : email
        ]
    }
}
