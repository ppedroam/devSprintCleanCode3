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

        guard validateForm() else { return }

        self.view.endEditing(true)
        if !ConnectivityManager.shared.isConnected {
            Globals.showNoInternetCOnnection(controller: self)
            return
        }

        let emailUser = emailTextfield.text!.trimmingCharacters(in: .whitespaces)

        let parameters = [
            "email": emailUser
        ]

        BadNetworkLayer
            .shared
            .resetPassword(
                self,
                parameters: parameters
            ) { success in
                guard success else {
                    self.handleError()
                    return
                }
                self.handleSucess()
            }
    }

    @IBAction func helpDidTap(_ sender: Any) {
        let vc = LuzContactUsViewController()
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
    func validateForm() -> Bool {
        let status = emailTextfield.text!.isEmpty ||
        !emailTextfield.text!.contains(".") ||
        !emailTextfield.text!.contains("@") ||
        emailTextfield.text!.count <= 5

        if status {
            emailTextfield.setErrorColor()
            textLabel.textColor = .red
            textLabel.text = "Verifique o e-mail informado"
            return false
        }

        return true
    }

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

    func handleError() {
        let alertController = UIAlertController(
            title: "Ops..",
            message: "Algo de errado aconteceu. Tente novamente mais tarde.",
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
}
