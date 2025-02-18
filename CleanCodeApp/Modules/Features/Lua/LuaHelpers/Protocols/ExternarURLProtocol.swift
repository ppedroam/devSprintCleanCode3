//
//  ExternarURLProtocol.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 15/02/25.
//


import UIKit

public protocol ExternalURLProtocol {
    func openExternalURL(
        _ url: URL,
        options: [UIApplication.OpenExternalURLOptionsKey: Any],
        completionHandler: (@MainActor @Sendable (Bool) -> Void)?
    )
    
    func canOpenURL(_ url: URL) -> Bool
}

extension ExternalURLProtocol {
    public func openExternalURL(
        _ url: URL,
        options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:],
        completionHandler: (@MainActor @Sendable (Bool) -> Void)? = nil
    ) {
        UIApplication.shared.open(url, options: options, completionHandler: completionHandler)
    }
    
    public func canOpenURL(_ url: URL) -> Bool {
        return UIApplication.shared.canOpenURL(url)
    }
}

extension UIViewController: ExternalURLProtocol { }
