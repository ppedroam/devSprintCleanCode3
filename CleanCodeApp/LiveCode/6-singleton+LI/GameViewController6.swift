//
//  GameViewController6.swift
//  CleanCode
//
//  Created by Pedro Menezes on 12/02/25.
//

import WebKit

enum GameFactory6 {
    static func make() -> UIViewController {
        let runtimeRoutine = RuntimeRoutine6()
        let htmlBuilder5 = HtmlBuilder6(runtimeRoutine: runtimeRoutine)
        let coordinator5 = GameCoordinator5()
        let analytics = MixpanelAnalytics()
        let webViewContent = WebViewContent(htmlContent: "")
        let rootViewController = GameViewController5(htmlBuilder: htmlBuilder5, coordinator: coordinator5, analytics: analytics, webViewContent: webViewContent)
        return rootViewController
    }
}

//final class GameViewController6: ParentViewController {
final class GameViewController6: UIViewController, AlertAvailable {
    
    private let htmlBuilder: HtmlBuilderProtocol
    private var coordinator: GameCoordinatorProtocol
    private let analytics: Analytics
    private let webViewContent: WebViewContent
    private let uiapplication: UIApplicationProxy
    
    private let webView = WKWebView()

    private lazy var goToLauchingsButton : UIButton = {
        let button = UIButton()// UIButton.applyStyle(title: GameViewStrings.launchingsButtonTitle)
        button.applyStyle(title: GameViewStrings.launchingsButtonTitle)
        button.addTarget(self, action: #selector(openLastLaunchingsScreen), for: .touchUpInside)
        return button
    }()
    
    init(
        htmlBuilder: HtmlBuilderProtocol = HtmlBuilder5(),
        coordinator: GameCoordinatorProtocol,
        analytics: Analytics,
        webViewContent: WebViewContent,
        uiApplication: UIApplicationProxy = UIApplication.shared
    ) {
        self.htmlBuilder = htmlBuilder
        self.coordinator = coordinator
        self.analytics = analytics
        self.webViewContent = webViewContent
        self.uiapplication = uiApplication
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        fillWebViewContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.frame = view.frame
        view.addSubview(webView)
    }
    

}

extension GameViewController6: SetupView {
    func addSubviews() {
        view.addSubview(goToLauchingsButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            goToLauchingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToLauchingsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}

// MARK: Setup Layout

private extension GameViewController6 {
    @objc
    func openFAQ() {
        guard let url = URL(string: GameUrls.faqUrl) else {
            return
        }
        Task.init {
            await uiapplication.open(url)
        }
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
        do {
            let deviceUrls = try htmlBuilder.createWebViewUrls(content: webViewContent)
            webView.loadFileURL(deviceUrls.htmlURL, allowingReadAccessTo: deviceUrls.pathURL.absoluteURL)
        } catch {
            showAlert(title: GameViewStrings.errorTitle, message: GameViewStrings.errorDescription, actionTitle: "Ok") {
                self.dismiss(animated: true)
            }
//            Globals.showAlertMessage(title: "Oops...", message: "Tente novamente mais tarde", targetVC: self)
        }
    }
}

protocol UIApplicationProxy {
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any]) async -> Bool
}

extension UIApplicationProxy {
    func open(_ url: URL) async -> Bool {
        await open(url, options: [:])
    }
}

extension UIApplication: UIApplicationProxy {}
