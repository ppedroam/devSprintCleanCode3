//
//  GameViewController5.swift
//  CleanCode
//
//  Created by Pedro Menezes on 11/02/25.
//

import UIKit
import WebKit

enum GameFactory5 {
    static func make() -> UIViewController {
        let htmlBuilder5 = HtmlBuilder5()
        let coordinator5 = GameCoordinator5()
        let analytics = MixpanelAnalytics()
        let webViewContent = WebViewContent()
        let rootViewController = GameViewController5(htmlBuilder: htmlBuilder5, coordinator: coordinator5, analytics: analytics, webViewContent: webViewContent)
        return rootViewController
    }
}

struct GameDependencies {
    let htmlBuilder: HtmlBuilderProtocol
    var coordinator: GameCoordinatorProtocol
    let analytics: Analytics
}

final class GameViewController5: UIViewController {
    private let htmlBuilder: HtmlBuilderProtocol
    private var coordinator: GameCoordinatorProtocol
    private let analytics: Analytics
//    private let dependencies: GameDependencies
    private let webViewContent: WebViewContent
    
    private let webView = WKWebView()

    private lazy var goToLauchingsButton : UIButton = {
        let launchButton = UIButton(type: .system)
        launchButton.setTitle("Ver lançamentos", for: .normal)
        launchButton.addTarget(self, action: #selector(openLastLaunchingsScreen), for: .touchUpInside)
        launchButton.translatesAutoresizingMaskIntoConstraints = false
        return launchButton
    }()
    
    init(htmlBuilder: HtmlBuilderProtocol = HtmlBuilder5(), coordinator: GameCoordinatorProtocol, analytics: Analytics, webViewContent: WebViewContent) {
//    init(dependencies: GameDependencies, webViewContent: WebViewContent) {
        self.htmlBuilder = htmlBuilder
        self.coordinator = coordinator
        self.analytics = analytics
        self.webViewContent = webViewContent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
}

// MARK: Setup Layout

private extension GameViewController5 {
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
        do {
            let deviceUrls = try htmlBuilder.createWebViewUrls(content: webViewContent)
            webView.loadFileURL(deviceUrls.htmlURL, allowingReadAccessTo: deviceUrls.pathURL.absoluteURL)
        } catch {
            Globals.showAlertMessage(title: "Oops...", message: "Tente novamente mais tarde", targetVC: self)
        }
    }
}
