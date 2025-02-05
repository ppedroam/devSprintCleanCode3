import UIKit

class LuaResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var recoverPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var emailTextFieldLabel: UILabel!
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

        if validateEmailTextField() {
            self.view.endEditing(true)
            if !ConnectivityManager.shared.isConnected {
                Globals.showNoInternetCOnnection(controller: self)
                return
            }

            let emailUser = emailTextField.text!.trimmingCharacters(in: .whitespaces)
            
            let parameters = [
                "email": emailUser
            ]
            
            BadNetworkLayer.shared.resetPassword(self, parameters: parameters) { (success) in
                if success {
                    self.recoveryEmail = true
                    self.emailTextField.isHidden = true
                    self.emailTextFieldLabel.isHidden = true
                    self.viewSuccess.isHidden = false
                    self.emailLabel.text = self.emailTextField.text?.trimmingCharacters(in: .whitespaces)
                    self.recoverPasswordButton.titleLabel?.text = "REENVIAR E-MAIL"
                    self.recoverPasswordButton.setTitle("Voltar", for: .normal)
                } else {
                    let alertController = UIAlertController(title: "Ops..", message: "Algo de errado aconteceu. Tente novamente mais tarde.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default)
                    alertController.addAction(action)
                    self.present(alertController, animated: true)
                }
            }
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func helpButton(_ sender: Any) {
        let vc = LuaContactUsViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        let newVc = LuaCreateAccountViewController()
        newVc.modalPresentationStyle = .fullScreen
        present(newVc, animated: true)
    }
    
    func validateEmailTextField() -> Bool {
        let isEmailFormatValid = validateEmailFormat()
        if isEmailFormatValid {
            return true
        }
        displayFormError(textField: emailTextField, label: emailTextFieldLabel, errorText: "Verifique o e-mail informado")
        return false
    }
    
    func validateEmailFormat() -> Bool {
        guard let emailTextifieldText = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
             return false
        }
        let isEmailFormatValid = emailTextifieldText.contains(".") &&
                                 emailTextifieldText.contains("@") &&
                                 emailTextifieldText.count > 5
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
        recoverPasswordButton.layer.cornerRadius = recoverPasswordButton.bounds.height / 2
        recoverPasswordButton.backgroundColor = .blue
        recoverPasswordButton.setTitleColor(.white, for: .normal)

        loginButton.layer.cornerRadius = createAccountButton.frame.height / 2
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.blue.cgColor
        loginButton.setTitleColor(.blue, for: .normal)
        loginButton.backgroundColor = .white
        
        helpButton.layer.cornerRadius = createAccountButton.frame.height / 2
        helpButton.layer.borderWidth = 1
        helpButton.layer.borderColor = UIColor.blue.cgColor
        helpButton.setTitleColor(.blue, for: .normal)
        helpButton.backgroundColor = .white
        
        createAccountButton.layer.cornerRadius = createAccountButton.frame.height / 2
        createAccountButton.layer.borderWidth = 1
        createAccountButton.layer.borderColor = UIColor.blue.cgColor
        createAccountButton.setTitleColor(.blue, for: .normal)
        createAccountButton.backgroundColor = .white
        
        emailTextField.setDefaultColor()
        
        if !email.isEmpty {
            emailTextField.text = email
            emailTextField.isEnabled = false
        }
        validateButton()
    }
    
    //email
    @IBAction func emailBeginEditing(_ sender: Any) {
        emailTextField.setEditingColor()
    }
    
    @IBAction func emailEditing(_ sender: Any) {
        emailTextField.setEditingColor()
        validateButton()
    }
    
    @IBAction func emailEndEditing(_ sender: Any) {
        emailTextField.setDefaultColor()
    }
}

extension LuaResetPasswordViewController {
    
    func validateButton() {
        if !emailTextField.text!.isEmpty {
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
