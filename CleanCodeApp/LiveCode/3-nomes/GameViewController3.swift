//
//  codigo3.swift
//  CleanCode
//
//  Created by Pedro Menezes on 07/02/25.
//

import UIKit
import WebKit

class GameViewController3: UIViewController {
    let htmlBuilder = HtmlBuilder()
    let webView = WKWebView()
    var webViewContent: WebViewContent?
    var coordinator = GameCoordinator3()

    lazy var goToLauchingsButton : UIButton = {
        let launchButton = UIButton(type: .system)
        launchButton.setTitle("Ver lançamentos", for: .normal)
        launchButton.addTarget(self, action: #selector(openLastLaunchingsScreen), for: .touchUpInside)
        launchButton.translatesAutoresizingMaskIntoConstraints = false
        return launchButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupGoToLaunchingsButton()
        fillWebViewContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.frame = view.frame
        view.addSubview(webView)
    }
    
    @objc
    func openFAQ() {
        coordinator.openFaqScreen()
    }
    
    @objc func openLastLaunchingsScreen() {
        coordinator.openLastLaunchingScreen()
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "message.square"),
            style: .plain,
            target: self,
            action: #selector(openFAQ)
        )
    }
    
    func setupGoToLaunchingsButton() {
        view.addSubview(goToLauchingsButton)
        NSLayoutConstraint.activate([
            goToLauchingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToLauchingsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    func fillWebViewContent() {
        guard let content = webViewContent else { return }
        do {
            let deviceUrls = try htmlBuilder.createWebViewUrls(content: content)
            webView.loadFileURL(deviceUrls.htmlURL, allowingReadAccessTo: deviceUrls.pathURL.absoluteURL)
        } catch {
            Globals.showAlertMessage(title: "Oops...", message: "Tente novamente mais tarde", targetVC: self)
        }
    }
}
