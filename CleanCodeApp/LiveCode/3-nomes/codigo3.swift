//
//  codigo3.swift
//  CleanCode
//
//  Created by Pedro Menezes on 07/02/25.
//

import UIKit
import WebKit

class GameViewController4: UIViewController {
    let htmlBuilder = HtmlBuilder()
    let webView = WKWebView()
    var webViewContent: WebViewContent?
    var coordinator = GameCoordinator2()

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

struct GameCoordinator2 {
    
    weak var viewController: UIViewController?
    
    func openFaqScreen() {
        let faqViewController = FAQViewController(type: .lastUpdates)
        viewController?.navigationController?.pushViewController(faqViewController, animated: true)
    }
    
    func openLastLaunchingScreen() {
        let lastLaunchingsViewController = LastLaunchingsFactory.make()
        viewController?.navigationController?.pushViewController(lastLaunchingsViewController, animated: true)
    }
}

struct HtmlBuilder2 {
    let realmManager = RealmManager()

    func createWebViewUrls(content: WebViewContent) throws -> DeviceUrls {
        let htmlAfterCustomization = try configureHtmlAppearence(content: content)
        let data = try convertHtmlToData(html: htmlAfterCustomization)
        let deviceUrls = getDeviceHtmlPathToSave()
        try data.write(to: deviceUrls.htmlURL)
        return deviceUrls
    }
    
    func configureHtmlAppearence(content: WebViewContent) throws -> String {
        guard let rHtmlConfig = realmManager.getObjects(HtmlConfig.self),
              let htmlConfig = rHtmlConfig.last as? HtmlConfig,
              let js = htmlConfig.jsContent,
              let css = htmlConfig.cssContent else {
            throw CommonsErros.invalidData
        }
        let body = RuntimeRoutine().runMustache(content: content)
        let htmlFinal = Globals.buildHtml(html: body, css: css, js: js)
        return htmlFinal
    }
    
    func convertHtmlToData(html: String) throws -> Data {
        guard let data = html.data(using: .utf8) else {
            print("Erro ao converter string html")
            throw CommonsErros.invalidData
        }
        return data
    }
    
    func getDeviceHtmlPathToSave() -> DeviceUrls {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let pathURL = URL(fileURLWithPath: paths[0]).appendingPathComponent(RealmFilesNames.imagesFatherPath.rawValue)
        let htmlURL = URL(fileURLWithPath: "content_html", relativeTo: pathURL).appendingPathExtension("html")
        let deviceUrls = DeviceUrls(pathURL: pathURL, htmlURL: htmlURL)
        return deviceUrls
    }
}
