//
//  ContactUsViewController.swift
//  DeliveryAppChallenge
//
//  Created by Pedro Menezes on 17/07/22.
//

import UIKit

class LuaContactUsViewController: LoadingInheritageController {
    var model: ContactUsModel?
    var luaContactUsView = LuaContactUsView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view = luaContactUsView
        pegarDados()
        configureButtons()
    }
    
    private func configureButtons() {
        luaContactUsView.configureChatButton(target: self, selector: #selector(chatClicked))
        luaContactUsView.configureCloseButton(target: self, selector: #selector(close))
        luaContactUsView.configureEmailButton(target: self, selector: #selector(emailClick))
        luaContactUsView.configurePhoneButton(target: self, selector: #selector(phoneClick))
        luaContactUsView.configureSendMessageButton(target: self, selector: #selector(messageSend))
    }
    
    @objc
    func phoneClick() {
        if let tel = model?.phone,
           let url = URL(string: "tel://\(tel)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc
    func emailClick() {
        if let mail = model?.mail,
           let url = URL(string: "mailto:\(mail)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func chatClicked() {
        if let phoneNumber = model?.phone, let whatsappURL = URL(string: "whatsapp://send?phone=\(phoneNumber)&text=Oi)") {
            if UIApplication.shared.canOpenURL(whatsappURL) {
                UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
            } else {
                if let appStoreURL = URL(string: "https://apps.apple.com/app/whatsapp-messenger/id310633997") {
                    UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    @objc
    func close() {
        dismiss(animated: true)
    }
    
    
    func pegarDados() {
        showLoadingView()
        let url = Endpoints.contactUs
        AF.shared.request(url, method: .get, parameters: nil, headers: nil) { result in
            self.removeLoadingView()
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
        if let message = luaContactUsView.textView.text, luaContactUsView.textView.text.count > 0 {
            let parameters: [String: String] = [
                "email": email,
                "mensagem": message
            ]
            showLoadingView()
            let url = Endpoints.sendMessage
            AF.shared.request(url, method: .post, parameters: parameters, headers: nil) { result in
                self.removeLoadingView()
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
