import UIKit

class FozResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var recoverPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!

<<<<<<< HEAD
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var viewSuccess: UIView!
    @IBOutlet weak var emailLabel: UILabel!

    var userEmail = ""
    var userPressedRecoveryButton = false
=======
    @IBOutlet weak var verifyUserEmailLabel: UILabel!
    @IBOutlet weak var passwordRecoveredSuccessView: UIView!
    @IBOutlet weak var emailDisplayLabel: UILabel!

    var didUserPutEmail: String = ""
    var didUserPressRecoverPasswordButton: Bool = false

    private let emailValidator: EmailValidating = EmailValidatorUseCase()

>>>>>>> upstream/main

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

<<<<<<< HEAD
// MARK: Recover Password
    @IBAction func recoverPasswordButton(_ sender: Any) {
        if !userPressedRecoveryButton {
=======
    // MARK: Recover Password
    @IBAction func recoverPasswordButton(_ sender: Any) {
        if !didUserPressRecoverPasswordButton {
>>>>>>> upstream/main
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
<<<<<<< HEAD
        userPressedRecoveryButton = true
        emailTextfield.isHidden = true
        textLabel.isHidden = true
        viewSuccess.isHidden = false
        emailLabel.text = email
=======
        didUserPressRecoverPasswordButton = true
        emailTextfield.isHidden = true
        verifyUserEmailLabel.isHidden = true
        passwordRecoveredSuccessView.isHidden = false
        emailDisplayLabel.text = email
>>>>>>> upstream/main
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
<<<<<<< HEAD
        let isEmailValid = EmailValidator.isValid(emailTextfield.text)
=======
        let isEmailValid = emailValidator.isValid(emailTextfield.text)
>>>>>>> upstream/main

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
<<<<<<< HEAD
        textLabel.textColor = .red
        textLabel.text = "Verifique o e-mail informado"
    }
}

struct EmailValidator {
    static func isValid(_ email: String?) -> Bool {
        guard let email = email?.trimmingCharacters(in: .whitespaces), !email.isEmpty else { return false }
        return email.contains("@") && email.contains(".") && email.count > 5
=======
        verifyUserEmailLabel.textColor = .red
        verifyUserEmailLabel.text = "Verifique o e-mail informado"
>>>>>>> upstream/main
    }
}


// MARK: - Comportamentos de layout
extension FozResetPasswordViewController {

<<<<<<< HEAD
    func setupView() {
        stylePrimaryButton(recoverPasswordButton)

        styleSecondaryButton(loginButton)

        styleSecondaryButton(helpButton)

        styleSecondaryButton(createAccountButton)

        emailTextfield.setDefaultColor()

        if !userEmail.isEmpty {
            emailTextfield.text = userEmail
=======
    func configureRecoverPasswordView() {
        recoverPasswordButton.applyPrimaryButtonStyle()

        loginButton.applySecondaryButtonStyle()

        helpButton.applySecondaryButtonStyle()

        createAccountButton.applySecondaryButtonStyle()

        emailTextfield.setDefaultColor()

        if !didUserPutEmail.isEmpty {
            emailTextfield.text = didUserPutEmail
>>>>>>> upstream/main
            emailTextfield.isEnabled = false
        }
        updateRecoverPasswordButtonState()
    }

<<<<<<< HEAD
    //email
    @IBAction func emailBeginEditing(_ sender: Any) {
        emailTextfield.setEditingColor()
    }

    @IBAction func emailEditing(_ sender: Any) {
=======
    @IBAction func emailEditingDidBegin(_ sender: Any) {
        emailTextfield.setEditingColor()
    }

    @IBAction func emailEditingChanged(_ sender: Any) {
>>>>>>> upstream/main
        emailTextfield.setEditingColor()
        updateRecoverPasswordButtonState()
    }

<<<<<<< HEAD
    @IBAction func emailEndEditing(_ sender: Any) {
        emailTextfield.setDefaultColor()
    }

    // MARK: Button Styler
    func stylePrimaryButton(_ button: UIButton){
        button.layer.cornerRadius = button.bounds.height / 2
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
    }

    func styleSecondaryButton(_ button: UIButton){
        button.layer.cornerRadius = button.bounds.height / 2
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        button.backgroundColor = .white
        button.setTitleColor(.blue, for: .normal)
    }

}

extension FozResetPasswordViewController {

    func validateButton() {
=======
    @IBAction func emailEditingDidEnd(_ sender: Any) {
        emailTextfield.setDefaultColor()
    }


    func updateRecoverPasswordButtonState() {
>>>>>>> upstream/main
        if !emailTextfield.text!.isEmpty {
            enableRecoverPasswordButton()
        }
        else {
            disableRecoverPasswordButton()
        }
    }

<<<<<<< HEAD
    func disableCreateButton() {
=======
    func disableRecoverPasswordButton() {
>>>>>>> upstream/main
        recoverPasswordButton.backgroundColor = .gray
        recoverPasswordButton.setTitleColor(.white, for: .normal)
        recoverPasswordButton.isEnabled = false
    }

<<<<<<< HEAD
    func enableCreateButton() {
=======
    func enableRecoverPasswordButton() {
>>>>>>> upstream/main
        recoverPasswordButton.backgroundColor = .blue
        recoverPasswordButton.setTitleColor(.white, for: .normal)
        recoverPasswordButton.isEnabled = true
    }

}


