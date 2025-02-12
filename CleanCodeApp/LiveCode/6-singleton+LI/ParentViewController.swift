//
//  ParentViewController.swift
//  CleanCode
//
//  Created by Pedro Menezes on 12/02/25.
//

import UIKit

class ParentViewController: UIViewController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Setup View
    func setupView() {
        addSubviews()
        setupConstraints()
    }

    func addSubviews() {
        // Subclasses devem sobrescrever este método para adicionar subviews
    }

    func setupConstraints() {
        // Subclasses devem sobrescrever este método para definir constraints
    }

    // MARK: - Show Alert
    func showAlert(title: String, message: String, actionTitle: String = "OK", actionHandler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { _ in
            actionHandler?()
        }
        alertController.addAction(action)
        present(alertController, animated: true)
    }

    // MARK: - Show Bottom Sheet
    func showBottomSheet(viewController: UIViewController, height: CGFloat? = nil) {
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = height != nil ? [.medium(), .large()] : [.large()]
            sheet.prefersGrabberVisible = true
        }
        present(viewController, animated: true)
    }
}

protocol BottomSheetAvailable where Self: UIViewController {
    func showBottomSheet(viewController: UIViewController, height: CGFloat)

}

extension BottomSheetAvailable {
    func showBottomSheet(viewController: UIViewController, height: CGFloat) {
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(viewController, animated: true)
    }
}

protocol AlertAvailable where Self: UIViewController {
    func showAlert(title: String, message: String, actionTitle: String, actionHandler: (() -> Void)? )
}

extension AlertAvailable {
    func showAlert(title: String, message: String, actionTitle: String, actionHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { _ in
            actionHandler?()
        }
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

protocol SetupView where Self: UIViewController {
    func setupView()
    func addSubviews()
    func setupConstraints()
}

extension SetupView   {
    func setupView() {
        addSubviews()
        setupConstraints()
    }
}
