//
//  2LiveCode.swift
//  CleanCode
//
//  Created by Pedro Menezes on 05/02/25.
//

//
//  1LiveCodeFunctions.swift
//  CleanCode
//
//  Created by Pedro Menezes on 04/02/25.
//

import UIKit
import WebKit
// A -> B
// B -> A

class GameViewController2: UIViewController {
    let htmlBuilder = HtmlBuilder()
    let webView = WKWebView()
    var content: WebViewContent?
    var coordinator = GameCoordinator()

    lazy var bottomButton: UIButton = {
        let launchButton = UIButton(type: .system)
        launchButton.setTitle("Ver lançamentos", for: .normal)
        launchButton.addTarget(self, action: #selector(openNextScreen), for: .touchUpInside)
        launchButton.translatesAutoresizingMaskIntoConstraints = false
        return launchButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupBottomButton()
        setupWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.frame = view.frame
        view.addSubview(webView)
    }
    
    func teste() {
        
    }
    
    @objc 
    func openFAQ() {
        coordinator.openFaq()
    }
    
    @objc func openNextScreen() {
        coordinator.openNextScreen()
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "message.square"),
            style: .plain,
            target: self,
            action: #selector(openFAQ)
        )
    }
    
    func setupBottomButton() {
        view.addSubview(bottomButton)
        NSLayoutConstraint.activate([
            bottomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    func setupWebView() {
        guard let content = content else { return }
        do {
            let deviceUrls = try htmlBuilder.createWebViewUrls(content: content)
            webView.loadFileURL(deviceUrls.htmlURL, allowingReadAccessTo: deviceUrls.pathURL.absoluteURL)
        } catch {
            Globals.alertMessage(title: "Oops...", message: "Tente novamente mais tarde", targetVC: self)
        }
    }
}




