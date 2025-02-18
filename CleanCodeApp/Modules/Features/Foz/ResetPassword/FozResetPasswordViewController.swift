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

    var viewModel: FozResetPasswordManaging
    weak var coordinator: FozResetPasswordCoordinating?

    init(viewModel: FozResetPasswordManaging, coordinator: FozResetPasswordCoordinating){
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings(with: viewModel)
        configureRecoverPasswordView()
    }

    private func setupBindings(with viewModel: FozResetPasswordManaging) {
        viewModel.onPasswordResetSuccess = { [weak self] email in
            self?.handlePasswordResetSuccess(withEmail: email)
        }
        viewModel.onPasswordResetFailure = { [weak self] errorMessage in guard let self = self else { return }
            if errorMessage == "Sem conexão com a internet" {
                Globals.showNoInternetCOnnection(controller: self)
            } else {
                Globals.alertMessage(title: "Ops…", message: errorMessage, targetVC: self)
            }
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
        view.endEditing(true)
        viewModel.performPasswordReset(withEmail: emailTextfield.text)

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
        if viewModel.isEmailValid(didUserPutEmail){
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
