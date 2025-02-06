import UIKit

class RioResetPasswordViewController: UIViewController {

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

    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func recoverPasswordButton(_ sender: Any) {
        if recoveryEmail {
            dismiss(animated: true)
            return
        }

        guard validateForm() else { return }
        
        self.view.endEditing(true)
        guard isConnected() else { return }

        let emailUser = getEmail()
        resetPassword(email: emailUser)
    }

    // MARK: - Validações

    private func isConnected() -> Bool {
        guard ConnectivityManager.shared.isConnected else {
            Globals.showNoInternetCOnnection(controller: self)
            return false
        }
        return true
    }

    private func getEmail() -> String {
        return emailTextfield.text!.trimmingCharacters(in: .whitespaces)
    }

    // MARK: - Reset de Senha

    private func resetPassword(email: String) {
        let parameters = ["email": email]

        BadNetworkLayer.shared.resetPassword(self, parameters: parameters) { success in
            success ? self.handleSuccess(email: email) : self.showErrorAlert()
        }
    }

    private func handleSuccess(email: String) {
        recoveryEmail = true
        emailTextfield.isHidden = true
        textLabel.isHidden = true
        viewSuccess.isHidden = false
        emailLabel.text = email
        updateRecoverPasswordButton()
    }

    private func updateRecoverPasswordButton() {
        recoverPasswordButton.titleLabel?.text = "REENVIAR E-MAIL"
        recoverPasswordButton.setTitle("Voltar", for: .normal)
    }

    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "Ops..",
            message: "Algo de errado aconteceu. Tente novamente mais tarde.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    
    @IBAction func loginButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func helpButton(_ sender: Any) {
        let vc = RioContactUsViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        let newVc = RioCreateAccountViewController()
        newVc.modalPresentationStyle = .fullScreen
        present(newVc, animated: true)
    }
    
    // Gerencia a validação do campo de email
    func validateForm() -> Bool {
        guard let email = emailTextfield.text, !isEmailFormatInvalid(email) else {
            showEmailValidationError()
            return false
        }
        return true
    }

    // Apenas valida o formato do e-mail, sem acessar UI
    func isEmailFormatInvalid(_ email: String) -> Bool {
        return email.isEmpty ||
               !email.contains(".") ||
               !email.contains("@") ||
               email.count <= 5
    }

    // Responsável apenas por atualizar a UI quando houver erro
    func showEmailValidationError() {
        emailTextfield.setErrorColor()
        textLabel.textColor = .red
        textLabel.text = "Verifique o e-mail informado"
    }
}

// MARK: - Comportamentos de layout
extension RioResetPasswordViewController {
    
    func setupView() {
        setupButtons()
        setupTextField()
        setupEmail()
        validateButton()
    }

    // MARK: - Configuração dos Botões

    private func setupButtons() {
        styleButton(recoverPasswordButton, backgroundColor: .blue, titleColor: .white, borderWidth: 0)
        styleButton(loginButton, backgroundColor: .white, titleColor: .blue, borderWidth: 1)
        styleButton(helpButton, backgroundColor: .white, titleColor: .blue, borderWidth: 1)
        styleButton(createAccountButton, backgroundColor: .white, titleColor: .blue, borderWidth: 1)
    }

    private func styleButton(_ button: UIButton, backgroundColor: UIColor, titleColor: UIColor, borderWidth: CGFloat) {
        button.layer.cornerRadius = button.bounds.height / 2
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = UIColor.blue.cgColor
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor
    }

    // MARK: - Configuração do Campo de Texto

    private func setupTextField() {
        emailTextfield.setDefaultColor()
    }

    // MARK: - Configuração do E-mail

    private func setupEmail() {
        guard !email.isEmpty else { return }
        emailTextfield.text = email
        emailTextfield.isEnabled = false
    }
    
    //email
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

extension RioResetPasswordViewController {
    
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
