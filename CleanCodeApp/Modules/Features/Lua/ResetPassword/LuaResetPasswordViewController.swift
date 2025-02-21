import UIKit

final class LuaResetPasswordViewController: UIViewController, LuaViewControllerProtocol {
    
    typealias ViewCode = LuaResetPasswordView
    internal let viewCode = LuaResetPasswordView()
    private let viewModel: LuaResetPasswordViewModelProtocol
    private let coordinator: LuaCoordinatorProtocol
    private var hasRequestedRecovery = false
    
    init(viewModel: LuaResetPasswordViewModelProtocol, coordinator: LuaBasicCoordinator) {
           self.viewModel = viewModel
           self.coordinator = coordinator
           super.init(nibName: nil, bundle: nil)
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = viewCode
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
            displayFormError(textField: viewCode.emailTextField, label: viewCode.emailLabel, errorText: LuaUserAccountError.invalidEmail.localizedDescription)
        }
    }
    
    private func resquestPasswordReset() async {
        do {
            try await viewModel.startPasswordReseting(targetViewController: self, emailInputted: viewCode.emailInputted)
            displayPasswordResetSuccessUI()
        } catch let error as LuaNetworkError  {
            showAlertError(error: error, from: self, alertTitle: error.errorTitle)
        } catch {
            showAlertError(error: error, from: self, alertTitle: "Algo de errado aconteceu. Tente novamente mais tarde.")
        }
    }
    
    private func validateEmailFormat() throws {
        guard viewModel.validateEmailFormat(inputedEmail: viewCode.emailInputted) else {
            throw LuaUserAccountError.invalidEmail
        }
    }
    
    private func displayPasswordResetSuccessUI() {
        self.hasRequestedRecovery = true
        viewCode.emailTextField.isHidden = true
        viewCode.emailLabel.isHidden = true
        viewCode.passwordRecoverySuccessView.isHidden = false
        viewCode.emailSentLabel.text = viewCode.emailInputted
        viewCode.passwordRecoveryButton.setTitle("Voltar", for: .normal)
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
        viewCode.loginButton.addTarget(self, action: #selector(onLoginButtonTapped), for: .touchUpInside)
        viewCode.helpButton.addTarget(self, action: #selector(onHelpButtonTapped), for: .touchUpInside)
        viewCode.createAccountButton.addTarget(self, action: #selector(onCreateAccountButtonTapped), for: .touchUpInside)
        viewCode.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        viewCode.passwordRecoveryButton.addTarget(target, action:  #selector(onPasswordRecoveryButtonTapped), for: .touchUpInside)
    }
    
    func configureTextField() {
        viewCode.emailTextField.addTarget(self, action:  #selector(emailTextFieldDidBeginEditing), for: .editingDidBegin)
        viewCode.emailTextField.addTarget(self, action:  #selector(onEmailTextFieldEdit), for: .editingChanged)
        viewCode.emailTextField.addTarget(self, action:  #selector(emailTextFieldDidEndEditing), for: .editingDidEnd)
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
        coordinator.openLuaContactUsScreen()
    }
    
    @IBAction func onCreateAccountButtonTapped(_ sender: Any) {
        coordinator.openLuaCreateAccountScreen()
    }
    
    @IBAction func emailTextFieldDidBeginEditing(_ sender: Any) {
        viewCode.emailTextField.setEditingColor()
    }
    
    @IBAction func onEmailTextFieldEdit(_ sender: Any) {
        viewCode.emailTextField.setEditingColor()
        updatePasswordRecoveryButtonState()
    }
    
    @IBAction func emailTextFieldDidEndEditing(_ sender: Any) {
        viewCode.emailTextField.setDefaultColor()
    }
}

private extension LuaResetPasswordViewController {
    
    func validateExistingEmailInput(){
        if viewCode.emailInputted.isNotEmpty {
            viewCode.emailTextField.text = viewCode.emailInputted
            viewCode.emailTextField.isEnabled = false
        }
    }
    
    func updatePasswordRecoveryButtonState() {
        let isEnabled = viewCode.emailInputted.isNotEmpty
        updatePasswordRecoverButtonStatus(newStatus: isEnabled)
    }
    
    func updatePasswordRecoverButtonStatus(newStatus: Bool) {
        viewCode.passwordRecoveryButton.backgroundColor = newStatus ? .defaultViolet : .darkGray
        viewCode.passwordRecoveryButton.setTitleColor(newStatus ? .white: .defaultViolet, for: .normal)
        viewCode.passwordRecoveryButton.isEnabled = newStatus
    }
}
