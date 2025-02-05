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
    
    var emailInput: String {
        get {
            guard let emailInput = emailTextField.text?.trimmingCharacters(in: .whitespaces) else {
                return ""
            }
            return emailInput
        }
    }
    var hasRequestedRecovery = false
    
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
        if hasRequestedRecovery {
            dismiss(animated: true)
            return
        }
        let isEmailAndConnectivityValid = validateEmailFormAndConnectivity()
        if !isEmailAndConnectivityValid {
            return
        }
        self.view.endEditing(true)
        let passwordResetParameters = getPasswordResetRequestParameters()
        sendPasswordResetRequest(parameters: passwordResetParameters)
    }
    
    func validateEmailFormAndConnectivity() -> Bool {
        let isEmailValid = validateEmailForm()
        if !isEmailValid {
            return false
        }
        let isConnected = ConnectivityManager.shared.isConnected
        if !isConnected {
            Globals.showNoInternetCOnnection(controller: self)
            return false
        }
        return true
    }
    
    func getPasswordResetRequestParameters() -> [String : String] {
        let passwordResetParameters = [
            "email": emailInput
        ]
        return passwordResetParameters
    }
    
    func sendPasswordResetRequest(parameters: [String : String]) {
        BadNetworkLayer.shared.resetPassword(self, parameters: parameters) { (success) in
            if success {
                self.handlePasswordResetRequestSuccess()
                return
            }
            self.handlePasswordResetRequestFailure()
        }
    }
    
    func handlePasswordResetRequestSuccess() {
        self.hasRequestedRecovery = true
        self.emailTextField.isHidden = true
        self.emailErrorLabel.isHidden = true
        self.passwordRecoverySuccessView.isHidden = false
        self.emailLabel.text = emailInput
        self.recoverPasswordButton.setTitle("Voltar", for: .normal)
    }
    
    func handlePasswordResetRequestFailure() {
        let alertController = UIAlertController(title: "Ops..", message: "Algo de errado aconteceu. Tente novamente mais tarde.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
    
    @IBAction func onLoginButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func onHelpButtonTapped(_ sender: Any) {
        let vc = LuaContactUsViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onCreateAccountButtonTapped(_ sender: Any) {
        let newVc = LuaCreateAccountViewController()
        newVc.modalPresentationStyle = .fullScreen
        present(newVc, animated: true)
    }
    
    func validateEmailForm() -> Bool {
        let isEmailFormatValid = validateEmailFormat()
        if isEmailFormatValid {
            return true
        }
        displayFormError(textField: emailTextField, label: emailErrorLabel, errorText: "Verifique o e-mail informado")
        return false
    }
    
    func validateEmailFormat() -> Bool {
        let isEmailFormatValid = emailInput.contains(".") &&
        emailInput.contains("@") &&
        emailInput.count > 5
        return isEmailFormatValid
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
        validatePasswordRecoveryButton()
       
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
        validatePasswordRecoveryButton()
    }
    
    @IBAction func emailTextFieldDidEndEditing(_ sender: Any) {
        emailTextField.setDefaultColor()
    }
}

extension LuaResetPasswordViewController {
    
    func validateExistingEmailInput(){
        if !emailInput.isEmpty {
            emailTextField.text = emailInput
            emailTextField.isEnabled = false
        }
    }
    
    func validatePasswordRecoveryButton() {
        if !emailInput.isEmpty {
            enablePasswordRecoveryButton()
        } else {
            disablePasswordRecoveryButtonTap()
        }
    }
    
    func disablePasswordRecoveryButtonTap() {
        recoverPasswordButton.backgroundColor = .gray
        recoverPasswordButton.setTitleColor(.white, for: .normal)
        recoverPasswordButton.isEnabled = false
    }
    
    func enablePasswordRecoveryButton() {
        recoverPasswordButton.backgroundColor = .blue
        recoverPasswordButton.setTitleColor(.white, for: .normal)
        recoverPasswordButton.isEnabled = true
    }
}
