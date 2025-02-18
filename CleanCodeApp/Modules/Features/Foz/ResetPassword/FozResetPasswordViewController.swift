import UIKit

class FozResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var recoverPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!

    @IBOutlet weak var verifyUserEmailLabel: UILabel!
    @IBOutlet weak var passwordRecoveredSuccessView: UIView!
    @IBOutlet weak var emailDisplayLabel: UILabel!

    var didUserPutEmail: String = ""
    var didUserPressRecoverPasswordButton: Bool = false

    private let emailValidator: EmailValidating = EmailValidatorUseCase()


    override func viewDidLoad() {
        super.viewDidLoad()
        configureRecoverPasswordView()
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }

    // MARK: Recover Password
    @IBAction func recoverPasswordButton(_ sender: Any) {
        if !didUserPressRecoverPasswordButton {
            validateRecovering()
        }
        else {
            dismiss(animated: true)
        }

        view.endEditing(true)
    }

    private func validateRecovering(){
        guard validateForm() else {
            return
        }

        checkUserConnection()

        guard let email = emailTextfield.text?.trimmingCharacters(in: .whitespaces), !email.isEmpty else {
            return
        }

        let parameters = ["email": email]
        performPasswordReset(with: parameters, email: email)
    }

    private func checkUserConnection (){
        guard ConnectivityManager.shared.isConnected else {
            Globals.showNoInternetCOnnection(controller: self)
            return
        }
    }

    private func performPasswordReset(with parameters: [String: String], email: String) {
        BadNetworkLayer.shared.resetPassword(self, parameters: parameters) { [weak self] success in
            DispatchQueue.main.async {
                guard let self = self else { return }
                success ? self.handlePasswordResetSuccess(withEmail: email) : self.handlePasswordResetFailure()
            }
        }
    }

    private func handlePasswordResetSuccess(withEmail email: String) {
        didUserPressRecoverPasswordButton = true
        emailTextfield.isHidden = true
        verifyUserEmailLabel.isHidden = true
        passwordRecoveredSuccessView.isHidden = false
        emailDisplayLabel.text = email
        recoverPasswordButton.setTitle("Voltar", for: .normal)
    }

    private func handlePasswordResetFailure() {
        let alertController = UIAlertController(
            title: "Ops…",
            message: "Algo de errado aconteceu. Tente novamente mais tarde.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }


    @IBAction func loginButton(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func helpButton(_ sender: Any) {
        let vc = FozContactUsViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func createAccountButton(_ sender: Any) {
        let newVc = FozCreateAccountViewController()
        newVc.modalPresentationStyle = .fullScreen
        present(newVc, animated: true)
    }

    func validateForm() -> Bool {
        let isEmailValid = emailValidator.isValid(emailTextfield.text)

        if isEmailValid {
            return true
        }

        else {
            setupErrorMessage()
            return false
        }

    }

    private func setupErrorMessage(){
        emailTextfield.setErrorColor()
        verifyUserEmailLabel.textColor = .red
        verifyUserEmailLabel.text = "Verifique o e-mail informado"
    }
}


// MARK: - Comportamentos de layout
extension FozResetPasswordViewController {

    func configureRecoverPasswordView() {
        recoverPasswordButton.applyPrimaryButtonStyle()

        loginButton.applySecondaryButtonStyle()

        helpButton.applySecondaryButtonStyle()

        createAccountButton.applySecondaryButtonStyle()

        emailTextfield.setDefaultColor()

        if !didUserPutEmail.isEmpty {
            emailTextfield.text = didUserPutEmail
            emailTextfield.isEnabled = false
        }
        updateRecoverPasswordButtonState()
    }

    @IBAction func emailEditingDidBegin(_ sender: Any) {
        emailTextfield.setEditingColor()
    }

    @IBAction func emailEditingChanged(_ sender: Any) {
        emailTextfield.setEditingColor()
        updateRecoverPasswordButtonState()
    }

    @IBAction func emailEditingDidEnd(_ sender: Any) {
        emailTextfield.setDefaultColor()
    }


    func updateRecoverPasswordButtonState() {
        if !emailTextfield.text!.isEmpty {
            enableRecoverPasswordButton()
        }
        else {
            disableRecoverPasswordButton()
        }
    }

    func disableRecoverPasswordButton() {
        recoverPasswordButton.backgroundColor = .gray
        recoverPasswordButton.setTitleColor(.white, for: .normal)
        recoverPasswordButton.isEnabled = false
    }

    func enableRecoverPasswordButton() {
        recoverPasswordButton.backgroundColor = .blue
        recoverPasswordButton.setTitleColor(.white, for: .normal)
        recoverPasswordButton.isEnabled = true
    }

}
