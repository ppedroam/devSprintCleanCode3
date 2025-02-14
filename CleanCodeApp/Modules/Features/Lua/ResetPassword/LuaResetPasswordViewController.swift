import UIKit

final class LuaResetPasswordViewController: UIViewController, LuaAlertHandlerProtocol {
    
    private let luaResetPasswordView = LuaResetPasswordView()
    private var viewModel: LuaResetPasswordViewModelProtocol?
    private var coordinator: LuaCoordinatorProtocol?
    private var hasRequestedRecovery = false
    
    func configure(viewModel: LuaResetPasswordViewModelProtocol, coordinator: LuaCoordinatorProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
    }
    
    override func loadView() {
        view = luaResetPasswordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        configureTextField()
        updatePasswordRecoveryButtonState()
        validateExistingEmailInput()
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func startPasswordRecoveringProcess() async {
        if hasRequestedRecovery {
            dismiss(animated: true)
            return
        }
        do {
            try validateEmailFormat()
            await resquestPasswordReset()
            self.view.endEditing(true)
        } catch {
            displayFormError(textField: luaResetPasswordView.emailTextField, label: luaResetPasswordView.successLabel, errorText: LuaUserAccountError.invalidEmail.localizedDescription)
        }
    }
    
    private func resquestPasswordReset() async {
        do {
            try await viewModel!.startPasswordResetRequest(targetViewController: self, emailInputted: luaResetPasswordView.emailInputted)
            displayPasswordResetSuccessUI()
        } catch let error as LuaNetworkError  {
            handle(error: error, from: self, alertTitle: error.errorTitle)
        } catch {
            handle(error: error, from: self, alertTitle: "Algo de errado aconteceu. Tente novamente mais tarde.")
        }
    }
    
    private func validateEmailFormat() throws {
        guard viewModel!.validateEmailFormat(inputedEmail: luaResetPasswordView.emailInputted) else {
            throw LuaUserAccountError.invalidEmail
        }
    }
    
    private func displayPasswordResetSuccessUI() {
        self.hasRequestedRecovery = true
        luaResetPasswordView.emailTextField.isHidden = true
        luaResetPasswordView.successLabel.isHidden = true
        luaResetPasswordView.passwordRecoverySuccessView.isHidden = false
        luaResetPasswordView.emailLabel.text = luaResetPasswordView.emailInputted
        luaResetPasswordView.passwordRecoveryButton.setTitle("Voltar", for: .normal)
    }
    
    private func displayFormError(textField: UITextField, label: UILabel, errorText: String) {
        textField.setErrorColor()
        label.textColor = .red
        label.text = errorText
    }
}

// MARK: - Comportamentos de layout
private extension LuaResetPasswordViewController {
    
    func configureButtons() {
        luaResetPasswordView.configureHelpButton(target: self, selector: #selector(onHelpButtonTapped) )
        luaResetPasswordView.configureCloseButton(target: self, selector: #selector(closeButtonTapped))
        luaResetPasswordView.configureLoginButton(target: self, selector: #selector(onLoginButtonTapped))
        luaResetPasswordView.configureCreateAccountButton(target: self, selector: #selector(onCreateAccountButtonTapped))
        luaResetPasswordView.configurePasswordRecoveryButton(target: self, selector: #selector(onPasswordRecoveryButtonTapped))
    }
    
    func configureTextField() {
        luaResetPasswordView.configureEmailTextFieldOnEditing(target: self, selector: #selector(onEmailTextFieldEdit))
        luaResetPasswordView.configureEmailTextFieldDidBeginEditing(target: self, selector: #selector(emailTextFieldDidBeginEditing))
        luaResetPasswordView.configureEmailTextFieldDidEndEditing(target: self, selector: #selector(emailTextFieldDidEndEditing))
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func onPasswordRecoveryButtonTapped(_ sender: Any) {
        Task {
            await startPasswordRecoveringProcess()
        }
    }
    
    @IBAction func onLoginButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func onHelpButtonTapped(_ sender: Any) {
        coordinator!.openLuaContactUsScreen()
    }
    
    @IBAction func onCreateAccountButtonTapped(_ sender: Any) {
        coordinator!.openLuaCreateAccountScreen()
    }
    
    @IBAction func emailTextFieldDidBeginEditing(_ sender: Any) {
        luaResetPasswordView.emailTextField.setEditingColor()
    }
    
    @IBAction func onEmailTextFieldEdit(_ sender: Any) {
        luaResetPasswordView.emailTextField.setEditingColor()
        updatePasswordRecoveryButtonState()
    }
    
    @IBAction func emailTextFieldDidEndEditing(_ sender: Any) {
        luaResetPasswordView.emailTextField.setDefaultColor()
    }
}

private extension LuaResetPasswordViewController {
    
    func validateExistingEmailInput(){
        if luaResetPasswordView.emailInputted.isNotEmpty {
            luaResetPasswordView.emailTextField.text = luaResetPasswordView.emailInputted
            luaResetPasswordView.emailTextField.isEnabled = false
        }
    }
    
    func updatePasswordRecoveryButtonState() {
        let isEnabled = luaResetPasswordView.emailInputted.isNotEmpty
        updatePasswordRecoverButtonStatus(newStatus: isEnabled)
    }
    
    func updatePasswordRecoverButtonStatus(newStatus: Bool) {
        luaResetPasswordView.passwordRecoveryButton.backgroundColor = newStatus ? .defaultViolet : .darkGray
        luaResetPasswordView.passwordRecoveryButton.setTitleColor(newStatus ? .white: .defaultViolet, for: .normal)
        luaResetPasswordView.passwordRecoveryButton.isEnabled = newStatus
    }
}
