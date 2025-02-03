//
//  FilesForLiveCode.swift
//  DeliveryAppChallenge
//
//  Created by Pedro Menezes on 03/11/23.
//

import Foundation


class WebViewContent {
    
}

class RealmManager {
    func getObjects(_ type: Any) -> [Any]? {
        return []
    }
}

class HtmlConfig {
    var jsContent: String?
    var cssContent: String?
}

class RuntimeRoutine {
    func runMustache(content: WebViewContent) -> String {
        return ""
    }
}

extension Globals {
    static func buildHtml(html: String, css: String, js: String) -> String {
        return ""
    }
}

enum RealmFilesNames: String {
    case imagesFatherPath = ""
}

