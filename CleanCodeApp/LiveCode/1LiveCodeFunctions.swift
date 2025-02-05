//
//  1LiveCodeFunctions.swift
//  CleanCode
//
//  Created by Pedro Menezes on 04/02/25.
//

import UIKit
import WebKit

class GameViewController2: UIViewController {
    
    let webView = WKWebView()
    var content: WebViewContent?
    let realmManager = RealmManager()

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
            let deviceUrls = try createWebViewUrls(content: content)
            webView.loadFileURL(deviceUrls.htmlURL, allowingReadAccessTo: deviceUrls.pathURL.absoluteURL)
        } catch {
            Globals.alertMessage(title: "Oops...", message: "Tente novamente mais tarde", targetVC: self)
        }
    }
    
    func createWebViewUrls(content: WebViewContent) throws -> DeviceUrls {
        let htmlFinal = try configHtml(content: content)
        let data = try saveHtml(html: htmlFinal)
        let deviceUrls = getDeviceUrls()
        try data.write(to: deviceUrls.htmlURL)
        return deviceUrls
    }
    
    func configHtml(content: WebViewContent) throws -> String {
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
    
    func saveHtml(html: String) throws -> Data {
        guard let data = html.data(using: .utf8) else {
            print("Erro ao converter string html")
            throw CommonsErros.invalidData
        }
        return data
    }
    
    func getDeviceUrls() -> DeviceUrls {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let pathURL = URL(fileURLWithPath: paths[0]).appendingPathComponent(RealmFilesNames.imagesFatherPath.rawValue)
        let htmlURL = URL(fileURLWithPath: "content_html", relativeTo: pathURL).appendingPathExtension("html")
        let deviceUrls = DeviceUrls(pathURL: pathURL, htmlURL: htmlURL)
        return deviceUrls
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.frame = view.frame
        view.addSubview(webView)
    }
    
    
    @objc func openFAQ() {
        let faqVC = FAQViewController(type: .lastUpdates)
        navigationController?.pushViewController(faqVC, animated: true)
    }
    
    @objc func openNextScreen() {
        let service = LastLaunchingsService()
        let viewModel = LastLaunchingsViewModel(service: service)
        let lastLaunchingsVC = LastLaunchingsViewController(viewModel: viewModel)
        navigationController?.pushViewController(lastLaunchingsVC, animated: true)
    }
}

struct DeviceUrls {
    let pathURL: URL
    let htmlURL: URL
}

enum CommonsErros: Error {
    case invalidData
}
