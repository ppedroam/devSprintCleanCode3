import UIKit

extension UIViewController {
    func showLoading() {
        let loadingController = LoadingController()
        loadingController.modalPresentationStyle = .fullScreen
        loadingController.modalTransitionStyle = .crossDissolve
        self.present(loadingController, animated: false)
    }

    func stopLoading() {
        if let presentedController = presentedViewController as? LoadingController {
            presentedController.dismiss(animated: false)
        }
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
