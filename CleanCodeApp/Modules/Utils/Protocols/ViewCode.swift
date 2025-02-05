//
//  ViewCode.swift
//  CleanCodeApp
//
//  Created by Bruno Moura on 04/02/25.
//

import Foundation

/// A protocol that defines the basic structure for implementing view setup in a programmatic UI (ViewCode).
///
/// Conforming to this protocol ensures that views are set up with a consistent structure,
/// including the addition of subviews, application of layout constraints, and styling.
///
/// The default implementation provides a `setup()` method that calls the required methods
/// in the proper order: `addSubviews()`, `setupConstraints()`, and `setupStyle`.
protocol ViewCode {
    /// Adds subviews to the main view.
    func addSubviews()
    
    /// Sets up layout constraints for the subviews.
    func setupConstraints()
    
    /// Applies styling to the view.
    func setupStyle()
}

extension ViewCode {
    /// Sets up the view by calling the required methods in the correct order.
    ///
    /// This method first adds subviews, then configures layout constraints, and finally applies styling.
    func setup() {
        addSubviews()
        setupConstraints()
        setupStyle()
    }
}
