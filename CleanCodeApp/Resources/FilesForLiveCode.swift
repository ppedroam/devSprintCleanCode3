//
//  FilesForLiveCode.swift
//  DeliveryAppChallenge
//
//  Created by Pedro Menezes on 03/11/23.
//

import Foundation
import UIKit

class RealmManager {
    func getObjects(_ type: Any) -> [Any]? {
        return []
    }
}

class HtmlConfig {
    var jsContent: String?
    var cssContent: String?
}

struct WebViewContent {
    let htmlContent: String
}

class RuntimeRoutine {
    static let shared = RuntimeRoutine()
    private init() {}
    
    func runMustache(content: WebViewContent) -> String {
        var customizedHTML = content.htmlContent
        customizedHTML = customizedHTML.replacingOccurrences(of: "<h1>", with: "<h1 style='color:blue;'>")
        customizedHTML = customizedHTML.replacingOccurrences(of: "<body>", with: "<body style='background-color:#f0f0f0;'>")
        return "Customized HTML:\n\(customizedHTML)"
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

class FAQViewController: UIViewController {
    let type: FaqTypes
    
    init(type: FaqTypes) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum FaqTypes {
    case lastUpdates
}


class LastLaunchingsService {
    
}

class LastLaunchAnallytics {
    
}

class LastLaunchingsViewModel {
    let service: LastLaunchingsService
    let analytics: LastLaunchAnallytics
    
    init(service: LastLaunchingsService,
         analytics: LastLaunchAnallytics) {
        self.service = service
        self.analytics = analytics
    }
}

class LastLaunchingsViewController: UIViewController {
    let viewModel: LastLaunchingsViewModel
    
    init(viewModel: LastLaunchingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
