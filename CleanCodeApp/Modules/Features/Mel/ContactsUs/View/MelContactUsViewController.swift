//
//  ContactUsViewController.swift
//  DeliveryAppChallenge
//
//  Created by Pedro Menezes on 17/07/22.
//

import UIKit

class MelContactUsViewController: UIViewController {
    private var viewModel: MelContactUsViewModelProtocol
    private var contactUsView: MelContactUsView?
    private let contactUsService: MelContactUsServiceProtocol
    private let melLoadingView: MelLoadingViewProtocol
    
    init(viewModel: MelContactUsViewModelProtocol = MelContactUsViewModel(appOpener: ExternalAppOpener(application: UIApplication.shared)),
         contactUsService: MelContactUsServiceProtocol = MelContactUsService(networking: MelNetworkManager()),
         melLoadingView: MelLoadingViewProtocol = MelLoadingView()
    ) {
        self.viewModel = viewModel
        self.contactUsService = contactUsService
        self.melLoadingView = melLoadingView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactUsView?.setDelegate(delegate: self)
        viewModel.setDelegate(delegate: self)
        viewModel.fetchAndProcessContactData()
    }
    
    override func loadView() {
        self.contactUsView = MelContactUsView()
        view = contactUsView
    }
    
    deinit {
        print(Self.self, "- Deallocated")
    }
}

// MARK: - Functions
extension MelContactUsViewController: MelContactUsViewDelegate {
    func didTapPhoneCallButton() {
        viewModel.openPhoneForCall()
    }
    
    func didTapEmailButton() {
        viewModel.openEmailForMessage()
    }
    
    func didTapChatButton() {
        viewModel.openWhatsAppOrRedirect()
    }
    
    func didTapSendMessageButton(message: String) {
        viewModel.sendMessageToSupport(message: message)
    }
    
    func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    private func displaySuccessAlert() {
        Globals.alertMessage(title: MelContactUsStrings.successAlertTitle.rawValue,
                             message: MelContactUsStrings.successAlertMessage.rawValue,
                             targetVC: self) {
            self.dismiss(animated: true)
        }
    }
    
    private func displayErrorAlert(mustDismiss: Bool) {
        Globals.alertMessage(title: MelContactUsStrings.errorAlertTitle.rawValue,
                             message: MelContactUsStrings.errorAlertMessage.rawValue,
                             targetVC: self)
        if mustDismiss {
            self.dismiss(animated: true)
        }
    }
}

extension MelContactUsViewController: MelContactUsViewModelDelegate {
    func presentLoading() {
        melLoadingView.showLoadingView()
    }
    func hideLoading() {
        melLoadingView.hideLoadingView()
    }
    
    func presentErrorAlert(mustDismiss: Bool) {
        displayErrorAlert(mustDismiss: mustDismiss)
    }
    
    func presentSuccessAlert() {
        displaySuccessAlert()
    }
}

enum ChatError: Error {
    case invalidPhoneNumber
    case invalidURL
}
