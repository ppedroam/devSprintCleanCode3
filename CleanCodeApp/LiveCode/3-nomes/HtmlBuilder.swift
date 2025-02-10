//
//  HtmlBuilder.swift
//  CleanCode
//
//  Created by Pedro Menezes on 10/02/25.
//

import Foundation

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
