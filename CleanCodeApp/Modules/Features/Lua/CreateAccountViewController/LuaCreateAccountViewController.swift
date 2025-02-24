import UIKit

enum LuaCreateAccountFormError: Error {
    case invalidName
    case invalidPhone
    case invalidIdInfo
    case invalidEmail
    case emailMismatch
    case passwordMismatch
    case passwordTooShort
    case passwordMissingNumber
    case passwordMissingUppercase
}

extension LuaCreateAccountFormError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
            
        case .invalidName:
            return "Informe seu nome completo."
        case .invalidPhone:
            return "O número deve ter 11 caracteres."
        case .invalidIdInfo:
            return "Informe seu CPF/CNPJ."
        case .invalidEmail:
            return "E-mails devem ser iguais."
        case .emailMismatch:
            return "Email deve ser igual."
        case .passwordMismatch:
            return "Senhas devem ser iguais."
        case .passwordTooShort:
            return "A senha deve ter no mínimo 6 caracteres"
        case .passwordMissingNumber:
            return  "A senha deve ter um número."
        case .passwordMissingUppercase:
            return  "A senha deve ter uma letra maiúscula"
        }
    }
}

class LuaCreateAccountViewController: UIViewController {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var contentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var documentTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailConfirmation: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var passwordConfirmation: UITextField!
    @IBOutlet weak var showConfirmPasswordButton: UIButton!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var phoneErrorLabel: UILabel!
    @IBOutlet weak var documentErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var emailConfirmationErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    
    var showPassword = true
    var showConfirmPassword = true
    
    
    var keyboardAppearenceManager: KeyboardAppearenceManaging?
    var textfieldReturnKeyManager: TextfieldReturnKeyManaging?
    
    private var inputtedName: String {
        get {
            guard let nameInput = nameTextField.text?
                .trimmingCharacters(in: .whitespacesAndNewlines) else {
                return ""
            }
            return nameInput
        }
    }
    
    
    
    private var inputtedPhone: String {
        
        let forbiddenSet = CharacterSet.symbols
        
        guard let phoneText = phoneTextField.text?
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: "[()\\- ]", with: "", options: .regularExpression) else {
            return ""
        }
        
        return phoneText.components(separatedBy: forbiddenSet).joined()
    }
    
    private var inputtedDocumentInfo: String {
        get {
            guard let IdInfoInput = documentTextField.text?
                .trimmingCharacters(in: .symbols.union(.whitespacesAndNewlines))
                .replacingOccurrences(of: "[./-]", with: "", options: .regularExpression) else {
                return ""
            }
            return IdInfoInput
        }
    }
    
    private var inputtedEmail: String {
        get {
            guard let emailInput = emailTextField.text?
                .trimmingCharacters(in: .whitespacesAndNewlines) else {
                return ""
            }
            return emailInput
        }
    }
    
    private var inputtedEmailConfirmation: String {
        get {
            guard let emailInput = emailConfirmation.text?
                .trimmingCharacters(in: .whitespacesAndNewlines) else {
                return ""
            }
            return emailInput
        }
    }
    
    private var inputtedPassword: String {
        get {
            guard let inputtedPassword = passwordTextField.text?
                .trimmingCharacters(in: .whitespacesAndNewlines) else {
                return ""
            }
            return inputtedPassword
        }
    }
    
    private var inputtedPasswordlConfirmation: String {
        get {
            guard let inputtedPassword = passwordConfirmation.text?
                .trimmingCharacters(in: .whitespacesAndNewlines) else {
                return ""
            }
            return inputtedPassword
        }
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var viewModel: LuaCreateAccountViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupManagers()
        setupView()
    }
    
    // MARK: - Actions
    @IBAction func closedButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        startAccountCreation()
    }
    
    func startAccountCreation() {
        do {
           try validateAllForms()
           updateUserInformation()
            // show loading
            try viewModel?.startAccountCreationProcess()
            // move to LuaHomeViewController
//            let vc = UINavigationController(rootViewController: LuaHomeViewController())
//            //                    let scenes = UIApplication.shared.connectedScenes
//            //                    let windowScene = scenes.first as? UIWindowScene
//            //                    let window = windowScene?.windows.first
//            //                    window?.rootViewController = vc
//            //                    window?.makeKeyAndVisible()
        } catch let error as LuaCreateAccountFormError  {
            handleValidationError(error)
        } catch {
            
        }
    }
    
    private func validateAllForms() throws {
        do {
            try viewModel?.validateFormAllForms(with: LuaRegistrationFormInput(
                name: inputtedName,
                phone: inputtedPhone,
                identityDocumentInfo: inputtedDocumentInfo,
                email: inputtedEmail,
                emailConfirmation: inputtedEmailConfirmation,
                password: inputtedPassword,
                passwordConfirmation: inputtedPasswordlConfirmation))
        } catch {
            throw error
        }
    }
    
    private func updateUserInformation()  {
        viewModel?.updateUserInformation(with: LuaUserInformation(
            name: inputtedName,
            email: inputtedEmail,
            password: inputtedPassword,
            phoneNumber: inputtedPhone,
            document: inputtedDocumentInfo
        ))
    }
    
    @IBAction func nameEditing(_ sender: Any) {
        validateCreateButton()
        let text = nameTextField.text ?? ""
        let okayChars : Set<Character> =
        Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ")
        let differentLetters = String(text.filter { okayChars.contains($0) })
        if text != differentLetters {
            nameErrorLabel.text = "Por favor, utilize somente letras"
        } else {
            nameErrorLabel.text = ""
        }
        nameTextField.text = differentLetters
    }
    
    @IBAction func nameBeginEditing(_ sender: Any) {
        nameTextField.setEditingColorBorder()
        nameErrorLabel.text = ""
    }
    @IBAction func nameEndEditing(_ sender: Any) {
        nameTextField.setDefaultColor()
    }
    
    @IBAction func phoneEditing(_ sender: Any) {
        let okayNumbers : Set<Character> = Set("0123456789")
        let phoneNumbers =  String(phoneTextField.text!.filter { okayNumbers.contains($0) })
        phoneTextField.text = phoneNumbers
        validateCreateButton()
    }
    
    @IBAction func phoneBeginEditing(_ sender: Any) {
        phoneTextField.setEditingColorBorder()
        phoneErrorLabel.text = ""
    }
    @IBAction func phoneEndEditing(_ sender: Any) {
        phoneTextField.setDefaultColor()
    }
    
    @IBAction func documetEditing(_ sender: Any) {
        let okayNumbers : Set<Character> = Set("0123456789")
        let documentNumbers =  String(documentTextField.text!.filter { okayNumbers.contains($0) })
        documentTextField.text = documentNumbers
        validateCreateButton()
    }
    
    @IBAction func documentBeginEditing(_ sender: Any) {
        documentTextField.setEditingColorBorder()
        documentErrorLabel.text = ""
    }
    @IBAction func documentEndEditing(_ sender: Any) {
        documentTextField.setDefaultColor()
    }
    
    @IBAction func emailEditing(_ sender: Any) {
        validateCreateButton()
    }
    
    @IBAction func emailBeginEditing(_ sender: Any) {
        emailTextField.setEditingColorBorder()
        emailErrorLabel.text = ""
    }
    @IBAction func emailEndEditing(_ sender: Any) {
        emailTextField.setDefaultColor()
    }
    
    @IBAction func emailConfirmationEditing(_ sender: Any) {
        validateCreateButton()
    }
    
    @IBAction func emailConfirmationBeginEditing(_ sender: Any) {
        emailConfirmation.setEditingColorBorder()
        emailConfirmationErrorLabel.text = ""
    }
    @IBAction func emailConfirmationEndEditing(_ sender: Any) {
        emailConfirmation.setDefaultColor()
    }
    
    @IBAction func passwordEditing(_ sender: Any) {
        validateCreateButton()
    }
    
    @IBAction func passwordBeginEditing(_ sender: Any) {
        passwordTextField.setEditingColorBorder()
        passwordErrorLabel.text = ""
    }
    @IBAction func passwordEndEditing(_ sender: Any) {
        passwordTextField.setDefaultColor()
    }
    
    @IBAction func passwordConfirmationEditing(_ sender: Any) {
        validateCreateButton()
    }
    
    @IBAction func passwordConfirmationBeginEditing(_ sender: Any) {
        passwordConfirmation.setEditingColorBorder()
        passwordErrorLabel.text = ""
    }
    @IBAction func passwordConfirmationEndEditing(_ sender: Any) {
        passwordConfirmation.setDefaultColor()
    }
    
    @IBAction func showPassword(_ sender: Any) {
        if(showPassword == true) {
            passwordTextField.isSecureTextEntry = false
            showPasswordButton.setImage(UIImage(named: "ic_hide_password"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            showPasswordButton.setImage(UIImage(named: "ic_show_password"), for: .normal)
        }
        showPassword = !showPassword
    }
    
    @IBAction func showConfirmPassword(_ sender: Any) {
        if(showConfirmPassword == true) {
            passwordConfirmation.isSecureTextEntry = false
            showConfirmPasswordButton.setImage(UIImage(named: "ic_hide_password"), for: .normal)
        } else {
            passwordConfirmation.isSecureTextEntry = true
            showConfirmPasswordButton.setImage(UIImage(named: "ic_show_password"), for: .normal)
        }
        showConfirmPassword = !showConfirmPassword
    }
    
    func setupView() {
        hideKeyboardWhenTappedAround()
        viewMain.layer.cornerRadius = 5
        createButton.layer.cornerRadius = createButton.frame.height / 2
        
        nameTextField.setDefaultColor()
        phoneTextField.setDefaultColor()
        documentTextField.setDefaultColor()
        emailTextField.setDefaultColor()
        emailConfirmation.setDefaultColor()
        passwordTextField.setDefaultColor()
        passwordConfirmation.setDefaultColor()
        
        disableCreateButton()
        passwordTextField.textContentType = .oneTimeCode
        passwordConfirmation.textContentType = .oneTimeCode
    }
    
    func setupManagers() {
        keyboardAppearenceManager = KeyboardAppearenceManager(viewController: self,
                                                              topConstraint: contentViewTopConstraint)
        
        let textFields: [UITextField] = [
            nameTextField,
            phoneTextField,
            documentTextField,
            emailTextField,
            emailConfirmation,
            passwordTextField,
            passwordConfirmation
        ]
        textfieldReturnKeyManager = TextfieldReturnKeyManager()
        textfieldReturnKeyManager?.start(textfields: textFields,
                                         lastKeyType: .go,
                                         completionLastKey: {
            self.createAccountButtonTapped(self.createButton ?? UIButton())
        })
    }
    
    func validateFields() {
        
    }
    
    func disableCreateButton() {
        createButton.backgroundColor = .gray
        createButton.setTitleColor(.lightGray, for: .normal)
        createButton.isEnabled = false
    }
    
    func enableCreateButton() {
        createButton.backgroundColor = .blue
        createButton.setTitleColor(.white, for: .normal)
        createButton.isEnabled = true
    }
    
    
    private func handleValidationError(_ error: LuaCreateAccountFormError) {
        switch error {
        case .invalidName:
            nameTextField.setErrorColor()
            nameErrorLabel.text = error.localizedDescription
            
        case .invalidPhone:
            phoneTextField.setErrorColor()
            phoneErrorLabel.text = error.localizedDescription
            
        case .invalidIdInfo:
            documentTextField.setErrorColor()
            documentErrorLabel.text = error.localizedDescription
            
        case .invalidEmail:
            setEmailError(error.localizedDescription)
            
        case .emailMismatch:
            setEmailError(error.localizedDescription)
            
        case .passwordMissingUppercase:
            setPasswordError(error.localizedDescription)
            
        case .passwordMissingNumber:
            setPasswordError(error.localizedDescription)
            
        case .passwordTooShort:
            setPasswordError(error.localizedDescription)
            
        case .passwordMismatch:
            setPasswordError(error.localizedDescription)
            
        }
    }
    
    private func setEmailError(_ message: String) {
        emailTextField.setErrorColor()
        emailConfirmation.setErrorColor()
        emailErrorLabel.text = message
    }
    private func setPasswordError(_ message: String) {
        passwordTextField.setErrorColor()
        passwordConfirmation.setErrorColor()
        passwordErrorLabel.text = message
    }
    
    
    func validateCreateButton() {
        let isValid =  !nameTextField.text!.isEmpty
        && !phoneTextField.text!.isEmpty
        && !documentTextField.text!.isEmpty
        && !emailTextField.text!.isEmpty
        && !emailConfirmation.text!.isEmpty
        && !passwordTextField.text!.isEmpty
        && !passwordConfirmation.text!.isEmpty
        
        if isValid {
            self.enableCreateButton()
        } else {
            self.disableCreateButton()
        }
    }
}

extension LuaCreateAccountViewController: KeyboardAppearenceDelegate {
    func keyboardWillShow(_ notification: Notification) {
        keyboardAppearenceManager?.keyboardWillShow(notification)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        keyboardAppearenceManager?.keyboardWillHide(notification)
    }
}
