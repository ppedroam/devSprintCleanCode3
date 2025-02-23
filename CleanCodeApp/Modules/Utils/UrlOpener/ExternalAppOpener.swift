//
//  ExternalAppOpener.swift
//  CleanCode
//
//  Created by Pedro Menezes on 19/02/25.
//

import Foundation
import UIKit

enum UrlErros: Error {
    case invalidUrl
}

protocol ExternalUrlCreator {
    func make() throws -> URL
}

struct WhatsppUrlCreator: ExternalUrlCreator {
    private let phoneNumber: String
    private var urlString: String {
        return "whatsapp://send?phone=\(phoneNumber)&text=Oi"
    }
    
    init(phoneNumber: String) {
        self.phoneNumber = phoneNumber
    }
    
    func make() throws -> URL {
        guard let url = URL(string: urlString) else {
            throw UrlErros.invalidUrl
        }
        return url
    }
}

struct TelephoneUrlCreator: ExternalUrlCreator {
    private let number: String
    private var urlString: String {
        return "tel://\(number)"
    }
    
    init(number: String) {
        self.number = number
    }
    
    func make() throws -> URL {
        guard let url = URL(string: urlString) else {
            throw UrlErros.invalidUrl
        }
        return url
    }
}

struct EmailUrlCreator: ExternalUrlCreator {
    private let email: String
    private var urlString: String {
        return "mailto://\(email)"
    }
    
    init(email: String) {
        self.email = email
    }
    
    func make() throws -> URL {
        guard let url = URL(string: urlString) else {
            throw UrlErros.invalidUrl
        }
        return url
    }
}

//MARK: - ExternalAppOpener


protocol ExternalAppOpening {
    func openUrl(_ urlCreator: ExternalUrlCreator) async throws
}

class ExternalAppOpener: ExternalAppOpening {
    private let application: UIApplicationProxy
    
    init(application: UIApplicationProxy) {
        self.application = application
    }
    
    func openUrl(_ urlCreator: ExternalUrlCreator) async throws {
        let url = try urlCreator.make()
        let _ = await application.open(url)
    }
}

//MARK: - UIApplicationProxy

protocol UIApplicationProxy {
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any]) async -> Bool
}

extension UIApplicationProxy {
    func open(_ url: URL) async -> Bool {
        await open(url, options: [:])
    }
}

extension UIApplication: UIApplicationProxy {}
