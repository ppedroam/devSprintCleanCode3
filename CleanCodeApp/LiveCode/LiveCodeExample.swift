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
        webViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.frame = view.frame
        view.addSubview(webView)
    }
    
    func webViewSetup() {
        guard let content = content else {
            return
        }
        let rHtmlConfig = realmManager.getObjects(HtmlConfig.self)
        let htmlConfig = rHtmlConfig?.last as? HtmlConfig
        let js = htmlConfig?.jsContent ?? ""
        let css = htmlConfig?.cssContent ?? ""
        let body = RuntimeRoutine().runMustache(content: content)
        let htmlFinal = Globals.buildHtml(html: body, css: css, js: js)
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let pathURL = URL(fileURLWithPath: paths[0]).appendingPathComponent (RealmFilesNames.imagesFatherPath.rawValue)
        let htmlURL = URL(fileURLWithPath: "content_html", relativeTo: pathURL).appendingPathExtension ("html")
        guard let data = htmlFinal.data(using: . utf8) else {
            print ("Erro ao converter string html")
            return
        }
        try? data.write(to: htmlURL)
        webView.loadFileURL(htmlURL, allowingReadAccessTo: pathURL.absoluteURL)
    }
}
