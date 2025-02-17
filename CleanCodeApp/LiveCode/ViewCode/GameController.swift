//
//  GameViewController.swift
//  CleanCode
//
//  Created by Pedro Menezes on 10/02/25.
//

import UIKit

final class GameViewControllerViewCode: UIViewController {
    private let htmlBuilder = HtmlBuilder4()
    private var webViewContent: WebViewContent?
    private var coordinator = GameCoordinator4()
    private let gameView = GameView()
    
    override func loadView() {
        view = gameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        gameView.configureButton(target: self, action: #selector(openLastLaunchingsScreen))
        fillWebViewContent()
    }
}

private extension GameViewControllerViewCode {
    @objc func openFAQ() {
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
    
    func fillWebViewContent() {
        guard let content = webViewContent else { return }
        do {
            let deviceUrls = try htmlBuilder.createWebViewUrls(content: content)
            gameView.webView.loadFileURL(deviceUrls.htmlURL, allowingReadAccessTo: deviceUrls.pathURL.absoluteURL)
        } catch {
            Globals.showAlertMessage(title: "Oops...", message: "Tente novamente mais tarde", targetVC: self)
        }
    }
}
