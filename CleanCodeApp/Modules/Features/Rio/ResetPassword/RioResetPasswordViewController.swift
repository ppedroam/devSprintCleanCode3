import UIKit

protocol RioResetPasswordViewModelDelegate: AnyObject {
    func didResetPasswordSuccess(email: String)
    func didFailWithError(_ error: RioCommonErrors)
}

class RioResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var recoverPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var viewSuccess: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    
    var email = ""
    private var recoveryEmail = false
    private let viewModel = RioResetPasswordViewModel()
    private let viewConfigurator = RioResetPasswordViewConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewConfigurator.setupView(for: self)
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
        } else {
            guard let emailUser = emailTextfield.text?.trimmingCharacters(in: .whitespaces) else { return }
            viewModel.attemptPasswordReset(email: emailUser)
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func helpButton(_ sender: Any) {
        let vc = RioContactUsViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        present(vc, animated: true)
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        let newVc = RioCreateAccountViewController()
        newVc.modalPresentationStyle = .fullScreen
        present(newVc, animated: true)
    }
    
    @IBAction func emailBeginEditing(_ sender: Any) {
        emailTextfield.setEditingColor()
    }
    
    @IBAction func emailEditing(_ sender: Any) {
        emailTextfield.setEditingColor()
        viewConfigurator.updateRecoverPasswordButtonState(for: self)
    }
    
    @IBAction func emailEndEditing(_ sender: Any) {
        emailTextfield.setDefaultColor()
    }
}

extension RioResetPasswordViewController: RioResetPasswordViewModelDelegate {
    
    func didResetPasswordSuccess(email: String) {
        recoveryEmail = true
        emailTextfield.isHidden = true
        textLabel.isHidden = true
        viewSuccess.isHidden = false
        emailLabel.text = email
        updateRecoverPasswordButtonTitleForSuccess()
    }
    
    func didFailWithError(_ error: RioCommonErrors) {
        RioAlertHelper.showErrorAlert(on: self, message: error.alertDescription)
    }
    
    private func updateRecoverPasswordButtonTitleForSuccess() {
        recoverPasswordButton.setTitle("Voltar", for: .normal)
    }
}
