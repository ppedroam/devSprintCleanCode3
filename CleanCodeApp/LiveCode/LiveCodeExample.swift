//
//  LiveCodeExample.swift
//  DeliveryAppChallenge
//
//  Created by Pedro Menezes on 03/11/23.
//

import Foundation
import UIKit
import WebKit

class GameViewController: UIViewController {
    
    let webView = WKWebView()
    var content: WebViewContent?
    let realmManager = RealmManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Messages",
            style: .plain,
            target: self,
            action: #selector(openFAQ)
        )        
        let launchButton = UIButton(type: .system)
        launchButton.setTitle("Ver lançamentos", for: .normal)
        launchButton.addTarget(self, action: #selector(openNextScreen), for: .touchUpInside)
        
        launchButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(launchButton)
        
        NSLayoutConstraint.activate([
            launchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            launchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        guard let content = content else { return }
        let rHtmlConfig = realmManager.getObjects(HtmlConfig.self)
        let htmlConfig = rHtmlConfig?.last as? HtmlConfig
        let js = htmlConfig?.jsContent ?? ""
        let css = htmlConfig?.cssContent ?? ""
        let body = RuntimeRoutine().runMustache(content: content)
        let htmlFinal = Globals.buildHtml(html: body, css: css, js: js)
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let pathURL = URL(fileURLWithPath: paths[0]).appendingPathComponent(RealmFilesNames.imagesFatherPath.rawValue)
        let htmlURL = URL(fileURLWithPath: "content_html", relativeTo: pathURL).appendingPathExtension("html")
        
        guard let data = htmlFinal.data(using: .utf8) else {
            print("Erro ao converter string html")
            return
        }
        
        try? data.write(to: htmlURL)
        webView.loadFileURL(htmlURL, allowingReadAccessTo: pathURL.absoluteURL)
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
        let analytics = LastLaunchAnallytics()
        let service = LastLaunchingsService()
        let viewModel = LastLaunchingsViewModel(service: service, analytics: analytics)
        let lastLaunchingsVC = LastLaunchingsViewController(viewModel: viewModel)
        navigationController?.pushViewController(lastLaunchingsVC, animated: true)
    }
}
