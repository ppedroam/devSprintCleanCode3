import UIKit

class LuaResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var recoverPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordRecoverySuccessView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    
    var emailInputted: String {
        get {
            guard let emailInput = emailTextField.text?.trimmingCharacters(in: .whitespaces) else {
                return ""
            }
            return emailInput
        }
    }
    
    var hasRequestedRecovery = false
    
    let viewModel = LuaResetPasswordViewModelFabric.makeLuaResetPasswordViewModel()
    
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
    
    @IBAction func onPasswordRecoveryButtonTapped(_ sender: Any) {
        startPasswordRecoveringProcess()
    }
    
    func startPasswordRecoveringProcess() {
        if hasRequestedRecovery {
            dismiss(animated: true)
            return
        }
        do {
            try validateEmailFormat()
            resquestPasswordReset()
            self.displayPasswordResetSuccessUI()
            self.view.endEditing(true)
        } catch {
            displayFormError(textField: emailTextField, label: emailErrorLabel, errorText: LuaUserAccountError.invalidEmail.localizedDescription)
        }
    }
    
    func resquestPasswordReset() {
        viewModel.startPasswordResetRequest(targetViewController: self, emailInputted: emailInputted)
    }
    
    func validateEmailFormat() throws {
        guard viewModel.validateEmailFormat(inputedEmail: emailInputted) else {
            throw LuaUserAccountError.invalidEmail
        }
    }
    
    func displayPasswordResetSuccessUI() {
        self.hasRequestedRecovery = true
        self.emailTextField.isHidden = true
        self.emailErrorLabel.isHidden = true
        self.passwordRecoverySuccessView.isHidden = false
        self.emailLabel.text = emailInputted
        self.recoverPasswordButton.setTitle("Voltar", for: .normal)
    }
    
    @IBAction func onLoginButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func onHelpButtonTapped(_ sender: Any) {
        presentLuaContactUsViewController()
    }
    
    func presentLuaContactUsViewController() {
        let LuaContactUsViewController = LuaContactUsViewController()
        LuaContactUsViewController.modalPresentationStyle = .fullScreen
        LuaContactUsViewController.modalTransitionStyle = .coverVertical
        self.present(LuaContactUsViewController, animated: true, completion: nil)
    }
    
    @IBAction func onCreateAccountButtonTapped(_ sender: Any) {
        presentLuaCreateAccountViewController()
    }
    
    func presentLuaCreateAccountViewController() {
        let LuaCreateAccountViewController = LuaCreateAccountViewController()
        LuaCreateAccountViewController.modalPresentationStyle = .fullScreen
        present(LuaCreateAccountViewController, animated: true)
    }
    
    func displayFormError(textField: UITextField, label: UILabel, errorText: String) {
        textField.setErrorColor()
        label.textColor = .red
        label.text = errorText
    }
}

// MARK: - Comportamentos de layout
extension LuaResetPasswordViewController {
    
    func setupView() {
        setupRecoverPasswordButton()
        setupLoginButton()
        setupHelpButton()
        setupAccountButton()
        emailTextField.setDefaultColor()
        validateExistingEmailInput()
        updatePasswordRecoveryButtonState()
    }
    
    func setupRecoverPasswordButton() {
        recoverPasswordButton.layer.cornerRadius = recoverPasswordButton.bounds.height / 2
        recoverPasswordButton.backgroundColor = .blue
        recoverPasswordButton.setTitleColor(.white, for: .normal)
    }
    
    func setupLoginButton() {
        loginButton.layer.cornerRadius = createAccountButton.frame.height / 2
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.blue.cgColor
        loginButton.setTitleColor(.blue, for: .normal)
        loginButton.backgroundColor = .white
    }
    
    func setupHelpButton() {
        helpButton.layer.cornerRadius = createAccountButton.frame.height / 2
        helpButton.layer.borderWidth = 1
        helpButton.layer.borderColor = UIColor.blue.cgColor
        helpButton.setTitleColor(.blue, for: .normal)
        helpButton.backgroundColor = .white
    }
    
    func setupAccountButton() {
        createAccountButton.layer.cornerRadius = createAccountButton.frame.height / 2
        createAccountButton.layer.borderWidth = 1
        createAccountButton.layer.borderColor = UIColor.blue.cgColor
        createAccountButton.setTitleColor(.blue, for: .normal)
        createAccountButton.backgroundColor = .white
    }
    
    @IBAction func emailTextFieldDidBeginEditing(_ sender: Any) {
        emailTextField.setEditingColor()
    }
    
    @IBAction func onEmailTextFieldEdit(_ sender: Any) {
        emailTextField.setEditingColor()
        updatePasswordRecoveryButtonState()
    }
    
    @IBAction func emailTextFieldDidEndEditing(_ sender: Any) {
        emailTextField.setDefaultColor()
    }
}

extension LuaResetPasswordViewController {
    
    func validateExistingEmailInput(){
        if !emailInputted.isEmpty {
            emailTextField.text = emailInputted
            emailTextField.isEnabled = false
        }
    }
    
    func updatePasswordRecoveryButtonState() {
        let isEnabled = !emailInputted.isEmpty
        updatePasswordRecoverButtonStatus(newStatus: isEnabled)
    }
    
    func updatePasswordRecoverButtonStatus(newStatus: Bool) {
        recoverPasswordButton.backgroundColor = newStatus ? .blue : .gray
        recoverPasswordButton.setTitleColor(newStatus ? .white: .blue, for: .normal)
        recoverPasswordButton.isEnabled = newStatus
    }
}

