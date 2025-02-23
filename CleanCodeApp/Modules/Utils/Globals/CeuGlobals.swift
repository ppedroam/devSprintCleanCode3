
import UIKit

protocol CeuGlobalsProtocol {
    func alertMessage(title: String, message: String, targetVC: UIViewController, action: (() -> Void)?)
    func showAlertMessage(title: String, message: String, targetVC: UIViewController, action: (() -> Void)?)
    func showNoInternetCOnnection(controller: UIViewController)
}

extension CeuGlobalsProtocol {

    @available(*, deprecated, message: "usar showAlertMessage")
    func alertMessage(title: String, message: String, targetVC: UIViewController, action: (() -> Void)? = nil) {
        self.showAlertMessage(title: title, message: message, targetVC: targetVC)
    }

    func showAlertMessage(title: String, message: String, targetVC: UIViewController, action: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            action?()
        }))
        targetVC.present(alert, animated: true, completion: nil)
    }

    func showNoInternetCOnnection(controller: UIViewController) {
        let alertController = UIAlertController(title: "Sem conexão", message: "Conecte-se à internet para tentar novamente", preferredStyle: .alert)
        let actin = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(actin)
        controller.present(alertController, animated: true)
    }
}

