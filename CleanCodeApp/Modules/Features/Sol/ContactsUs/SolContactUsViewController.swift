//
//  ContactUsViewController.swift
//  DeliveryAppChallenge
//
//  Created by Pedro Menezes on 17/07/22.
//

import UIKit

//IMPLEMENTAR SINGLETO UIAPPLICATION

protocol SolContactUsProtocol: AnyObject {
    func callLoadingView()
    func callRemoveLoadingView()
    func showMessageReturnModel(result: ContactUsModel)
    func displayAlertMessage(title: String, message: String, dissmiss: Bool)
    func displayGlobalAlertMessage()
}

class SolContactUsViewController: LoadingInheritageController, SolContactUsProtocol {
    var model: ContactUsModel?
    
    private let viewModel: SolContactUsViewModel
    private let contactUsView: SolContactUsView
    
    override func loadView() {
        view = contactUsView
    }
    
    init (viewModel: SolContactUsViewModel,
          contactUsView: SolContactUsView = SolContactUsView()){
        self.viewModel = viewModel
        self.contactUsView = contactUsView
        super.init(nibName: nil, bundle: nil)
        self.viewModel.viewController = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        contactUsView.textView.text  = SolContactUsStrings.writheHereYourMessage
        callConfigureActionsButtonsByType ()
        
        viewModel.fetchData()
    }
    
    func callConfigureActionsButtonsByType () {
        contactUsView.configureActionsButtonsByType(target: self, action: #selector(didTapPhone), viewAction: .phoneButton)
        contactUsView.configureActionsButtonsByType(target: self, action: #selector(didTapEmail), viewAction: .emailButton)
        contactUsView.configureActionsButtonsByType(target: self, action: #selector(didTapChat), viewAction: .chatButton)
        contactUsView.configureActionsButtonsByType(target: self, action: #selector(messageSend), viewAction: .sendMessageButton)
        contactUsView.configureActionsButtonsByType(target: self, action: #selector(close), viewAction: .closeButton)
    }
    
    
    
    private func openAppLinks(appLink: ExternalActionsHandler) {
        guard let url = appLink.url else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(
                url,
                options: [:],
                completionHandler: nil
            )
        } else if let fallback = appLink.fallbackURL {
            UIApplication.shared.open(
                fallback,
                options: [:],
                completionHandler: nil
            )
        }
    }
    
    
    
    
    private func showAlertMessage(title: String, message: String, dissmiss: Bool) {
        Globals.showAlertMessage(title: title, message: message, targetVC: self) {
            self.dismiss(animated: dissmiss)
        }
    }
    
    
    func sendParameters() throws -> [String: String]  {
        let email = model?.mail ?? ""
        guard let message = contactUsView.textView.text, contactUsView.textView.text.count > 0 else {
            throw SolCommonsError.invalidMessage
        }
        
        let parameters: [String: String] = [
            "email": email,
            "mensagem": message
        ]
        return parameters
    }
    
    func callLoadingView() {
        showLoading()
    }
    
    func callRemoveLoadingView() {
        removeLoadingView()
    }
    
    func showMessageReturnModel(result: ContactUsModel) {
        self.model = result
    }
    
    func displayAlertMessage(title: String, message: String, dissmiss: Bool) {
        self.showAlertMessage(title: title, message: message , dissmiss: dissmiss)
    }
    
    func displayGlobalAlertMessage() {
        Globals.showAlertMessage(title: SolContactUsStrings.ops, message: SolContactUsStrings.anyErrorOcorred, targetVC: self)
    }
}

private extension SolContactUsViewController {
    @objc
    func messageSend() {
        do{
            view.endEditing(true)
            let parameters = try sendParameters()
            showLoadingView()
            viewModel.requestSendMessage(parameters: parameters)
        }
        catch {
            Globals.showAlertMessage(title: SolContactUsStrings.ops, message: SolContactUsStrings.anyErrorOcorred, targetVC: self)
        }
    }
    
    @objc
    func didTapPhone() {
        if let phone = model?.phone {
            openAppLinks(appLink: .phone(phone))
        }
    }
    
    @objc
    func didTapEmail() {
        if let mail = model?.mail{
            openAppLinks(appLink: .email(mail))
        }
    }
    
    @objc
    func didTapChat() {
        if let phoneNumber = model?.phone {
            openAppLinks(appLink: .whatsapp(phoneNumber))
        }
    }
    
    @objc
    func close() {
        dismiss(animated: true)
    }
}

enum SolCommonsError: Error {
    case invalidMessage
}
