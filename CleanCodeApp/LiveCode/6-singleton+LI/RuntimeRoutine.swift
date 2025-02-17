//
//  RuntimeRoutine.swift
//  CleanCode
//
//  Created by Pedro Menezes on 12/02/25.
//

import Foundation
protocol RuntimeRoutinePpotocol {
    func runMustache(content: WebViewContent) -> String
}

class RuntimeRoutine6: RuntimeRoutinePpotocol {
    func runMustache(content: WebViewContent) -> String {
        var customizedHTML = content.htmlContent
        customizedHTML = customizedHTML.replacingOccurrences(of: "<h1>", with: "<h1 style='color:blue;'>")
        customizedHTML = customizedHTML.replacingOccurrences(of: "<body>", with: "<body style='background-color:#f0f0f0;'>")
        return "Customized HTML:\n\(customizedHTML)"
    }
}
