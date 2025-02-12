//
//  Analytics.swift
//  CleanCode
//
//  Created by Pedro Menezes on 11/02/25.
//

import Foundation

struct AnalyticsEvent {
    var description: String
}

protocol Analytics {
    func send(event: AnalyticsEvent)
}

class AnalyticsImpl: Analytics {
    let firebase = FirebaseAnalytics()
    
    func send(event: AnalyticsEvent) {
        firebase.send()
    }
}

class MixpanelAnalytics: Analytics {
    let mixPanel = MockMixPanel()
    
    func send(event: AnalyticsEvent) {
        mixPanel.insertEvent(event.description)
    }
}

struct MockMixPanel {
    func insertEvent(_ string: String) {
        
    }
}

struct FirebaseAnalytics {
    func send() {
        
    }
}
