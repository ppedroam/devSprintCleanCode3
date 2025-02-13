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

    private var didUserPutEmail: String = ""
    private var didUserPressRecoverPasswordButton: Bool = false

    var viewModel: ResetPasswordManaging?
    var coordinator: Coordinating?


    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = viewModel else {
            fatalError("ResetPasswordViewModel não injetada. Faça isso antes de carregar a VC")
        }
        setupBindings(with: viewModel)
        configureRecoverPasswordView()
    }

    private func setupBindings(with viewModel: ResetPasswordManaging) {
        viewModel.onPasswordResetSuccess = { [weak self] email in
            self?.handlePasswordResetSuccess(withEmail: email)
        }
        viewModel.onPasswordResetFailure = { [weak self] in
            self?.handlePasswordResetFailure()
        }
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
        guard isFormValid() else {
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
        guard isFormValid() else { return }
        checkUserConnection()
        guard let email = emailTextfield.text?.trimmingCharacters(in: .whitespaces), !email.isEmpty else { return }
        viewModel?.performPasswordReset(withEmail: email)
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
        coordinator?.showContactUs()
    }

    @IBAction func createAccountButton(_ sender: Any) {
        coordinator?.showCreateAccount()
    }

    private func isFormValid() -> Bool {
        if (viewModel?.validateEmail(didUserPutEmail)) != nil {
            return true
        }
        else {
            displayErrorMessage()
            return false
        }
    }

    private func displayErrorMessage(){
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
