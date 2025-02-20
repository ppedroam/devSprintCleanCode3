//
//  MelURLHandler.swift
//  CleanCodeApp
//
//  Created by Bruno Moura on 15/02/25.
//

import Foundation
import UIKit

final class MelURLHandler {
    public func openURL(_ url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    public func canOpenURL(_ url: URL) -> Bool {
        return UIApplication.shared.canOpenURL(url)
    }
    
    public func makeWhatsAppURL(for phoneNumber: String?) throws -> URL {
        guard let phoneNumber = phoneNumber else { throw ChatError.invalidPhoneNumber }
        guard let url = URL(string: "whatsapp://send?phone=\(phoneNumber)&text=Oi)") else {
            throw ChatError.invalidURL
        }
        return url
    }
    
    public func makeWhatsAppURL() throws -> URL {
        guard let url = URL(string: "https://apps.apple.com/app/whatsapp-messenger/id310633997") else {
            throw ChatError.invalidURL
        }
        return url
    }
}
