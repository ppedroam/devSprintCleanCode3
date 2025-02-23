import UIKit

final class LuzResetPasswordViewController: UIViewController {
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var recoverPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var viewSuccess: UIView!
    @IBOutlet weak var emailLabel: UILabel!

    var email = ""
    var recoveryEmail = false

    private let viewModel: LuzResetPasswordViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.delegate = self
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    init(viewModel: LuzResetPasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - IBActions
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func didTapResetPassword(_ sender: Any) {
        if recoveryEmail {
            dismiss(animated: true)
            return
        }
        guard let email = emailTextfield.text else { return }
        viewModel.recoverPassword(from: self, email: email)
    }

    @IBAction func didTapContactUS(_ sender: Any) {
        let contactUsViewController = LuzContactUsViewController()
        contactUsViewController.modalPresentationStyle = .fullScreen
        contactUsViewController.modalTransitionStyle = .coverVertical
        self.present(contactUsViewController, animated: true, completion: nil)
    }

    @IBAction func didTapCreateAccount(_ sender: Any) {
        let createAccountViewController = LuzCreateAccountViewController()
        createAccountViewController.modalPresentationStyle = .fullScreen
        present(createAccountViewController, animated: true)
    }

    @IBAction func emailBeginEditing(_ sender: Any) {
        emailTextfield.setEditingColor()
    }

    @IBAction func emailEditing(_ sender: Any) {
        emailTextfield.setEditingColor()
        validateButton()
    }

    @IBAction func emailEndEditing(_ sender: Any) {
        emailTextfield.setDefaultColor()
    }
}

// MARK: - Setup View
private extension LuzResetPasswordViewController {

    func configureUI() {
        buttonStyle(
            for: recoverPasswordButton,
            backgroundColor: .blue,
            textColor: .white
        )
        buttonOutlineStyle(for: loginButton)
        buttonOutlineStyle(for: helpButton)
        buttonOutlineStyle(for: createAccountButton)
        emailTextfield.setDefaultColor()

        if !email.isEmpty {
            emailTextfield.text = email
            emailTextfield.isEnabled = false
        }
        validateButton()
    }

    func buttonStyle(
        for button: UIButton,
        backgroundColor: UIColor,
        textColor: UIColor
    ) {
        button.layer.cornerRadius = button.bounds.height / 2
        button.backgroundColor = backgroundColor
        button.setTitleColor(textColor, for: .normal)
    }

    func buttonOutlineStyle(for button: UIButton) {
        button.layer.cornerRadius = createAccountButton.bounds.height / 2
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .white
    }
}

// MARK: - Validations
private extension LuzResetPasswordViewController {
    func validateButton() {
        if !emailTextfield.text!.isEmpty {
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

// MARK: Handlers
private extension LuzResetPasswordViewController {
    func handleSucess() {
        self.recoveryEmail = true
        self.emailTextfield.isHidden = true
        self.textLabel.isHidden = true
        self.viewSuccess.isHidden = false
        self.emailLabel.text = self.emailTextfield.text?.trimmingCharacters(in: .whitespaces)
        self.recoverPasswordButton.titleLabel?.text = "REENVIAR E-MAIL"
        self.recoverPasswordButton.setTitle("Voltar", for: .normal)
    }

    func showErrorAlert() {
        let alertController = UIAlertController(
            title: "Ops..",
            message: "Algo de errado aconteceu. Tente novamente mais tarde.",
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
}

extension LuzResetPasswordViewController: LuzResetPasswordViewModelDelegate {
    func showError(_ message: String) {
        self.showErrorAlert()
    }

    func showSuccess() {
        self.handleSucess()
    }
}
