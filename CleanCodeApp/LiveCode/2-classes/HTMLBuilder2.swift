//
//  HTMLBuilder.swift
//  CleanCode
//
//  Created by Pedro Menezes on 05/02/25.
//

import Foundation

struct HtmlBuilder {
    let realmManager = RealmManager()

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
        let body = RuntimeRoutine.shared.runMustache(content: content)
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
}
