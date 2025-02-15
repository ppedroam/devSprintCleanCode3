//
//  ContactUsViewController.swift
//  DeliveryAppChallenge
//
//  Created by Pedro Menezes on 17/07/22.
//

import UIKit

final class LuaContactUsViewController: UIViewController, LuaViewControllerProtocol, LuaAlertHandlerProtocol {
    var model: ContactUsModel?
   
    typealias ViewCode = LuaContactUsView
    internal let viewCode = LuaContactUsView()

    override func loadView() {
        view = viewCode
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pegarDados()
        configureButtons()
        hideKeyboardWhenTappedAround() 
    }

    func pegarDados() {
        showLoading()
        
        let url = Endpoints.contactUs
        
        AF.shared.request(url, method: .get, parameters: nil, headers: nil) { result in
            self.stopLoading()
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let returned = try? decoder.decode(ContactUsModel.self, from: data) {
                    self.model = returned
                } else {
                    Globals.alertMessage(title: "Ops..", message: "Ocorreu algum erro", targetVC: self) {
                        self.dismiss(animated: true)
                    }
                }
            case .failure(let error):
                print("error api: \(error.localizedDescription)")
                Globals.alertMessage(title: "Ops..", message: "Ocorreu algum erro", targetVC: self) {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    @objc
    func messageSend() {
        view.endEditing(true)
        let email = model?.mail ?? ""
        if let message = viewCode.textView.text, viewCode.textView.text.count > 0 {
            let parameters: [String: String] = [
                "email": email,
                "mensagem": message
            ]
            showLoading()
            let url = Endpoints.sendMessage
            AF.shared.request(url, method: .post, parameters: parameters, headers: nil) { result in
                self.stopLoading()
                switch result {
                case .success:
                    Globals.alertMessage(title: "Sucesso..", message: "Sua mensagem foi enviada", targetVC: self) {
                        self.dismiss(animated: true)
                    }
                case .failure:
                    Globals.alertMessage(title: "Ops..", message: "Ocorreu algum erro", targetVC: self)
                }
            }
        }
    }
}
// MARK: - Comportamentos de layout
private extension LuaContactUsViewController {
    func configureButtons() {
        viewCode.configureChatButton(target: self, selector: #selector(chatButtonTapped))
        viewCode.configureCloseButton(target: self, selector: #selector(close))
        viewCode.configureEmailButton(target: self, selector: #selector(emailButtonTapped))
        viewCode.configurePhoneButton(target: self, selector: #selector(phoneButtonTapped))
        viewCode.configureSendMessageButton(target: self, selector: #selector(messageSend))
    }
    
    @objc func phoneButtonTapped() {
        do {
            try openPhone()
        } catch let error as LuaPersonalInfoError {
            showAlertError(error: error, from: self, alertTitle: error.errorTitle)
        } catch {
            showAlertError(error: error, from: self, alertTitle: "Algo de errado aconteceu. Tente novamente mais tarde.")
        }
    }
    
    @objc func emailButtonTapped() {
        do {
            try openMail()
        } catch let error as LuaPersonalInfoError {
            showAlertError(error: error, from: self, alertTitle: error.errorTitle)
        } catch {
            showAlertError(error: error, from: self, alertTitle: "Algo de errado aconteceu. Tente novamente mais tarde.")
        }
    }
    
    @objc func chatButtonTapped() {
        do {
            try openWhatsapp()
        } catch let error as LuaPersonalInfoError {
            showAlertError(error: error, from: self, alertTitle: error.errorTitle)
        } catch {
            showAlertError(error: error, from: self, alertTitle: "Algo de errado aconteceu. Tente novamente mais tarde.")
        }
    }
    
    @objc func close() {
        dismiss(animated: true)
    }
    
    func openPhone() throws {
        guard let phoneNumer = model?.phone else {
            throw LuaPersonalInfoError.invalidPhoneNumber
        }
        do {
            try openExternalApp(appURLTarget: .phone(phoneNumer))
        }
        catch let error as LuaUIApplicationURLError {
            showAlertError(error: error, from: self, alertTitle: error.errorTitle)
        }
    }
    
    func openWhatsapp() throws {
        guard let phoneNumer = model?.phone else {
            throw LuaPersonalInfoError.invalidPhoneNumber
        }
        do {
            try openExternalApp(appURLTarget: .whatsapp(phoneNumer))
        }
        catch let error as LuaUIApplicationURLError {
            showAlertError(error: error, from: self, alertTitle: error.errorTitle)
        }
    }
    
    func openMail() throws {
        guard let mail = model?.mail else {
            throw LuaPersonalInfoError.invalidMail
        }
        do {
            try openExternalApp(appURLTarget: .mail(mail))
        }
        catch let error as LuaUIApplicationURLError {
            showAlertError(error: error, from: self, alertTitle: error.errorTitle)
        }
    }
    
    func openExternalApp(appURLTarget: LuaAppURLTarget) throws {
        guard let url = appURLTarget.url else {
            throw LuaUIApplicationURLError.invalidAppURL
        }
        if canOpenURL(url) {
            openExternalURL(url)
            return
        }
        guard let fallBackURL = appURLTarget.fallBackURL else {
            throw LuaUIApplicationURLError.unableToOpenAppURL
        }
        openExternalURL(fallBackURL)
    }
}
