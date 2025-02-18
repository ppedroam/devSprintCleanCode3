//
//  HomeView.swift
//  CleanCode
//
//  Created by Pedro Menezes on 17/02/25.
//

import UIKit

final class HomeView: UIView {
    
    lazy var selectCurrencyFromButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Selecionar moeda origem", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var currencyInputField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.keyboardType = .decimalPad
        textField.placeholder = "Digite um valor"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var currencySelectedLabel: UILabel = {
        let label = UILabel()
        label.text = "Real"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var equivalenceLabel: UILabel = {
        let label = UILabel()
        label.text = "Equivale a"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var selectCurrencyToButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Selecionar moeda destino", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var convertedValueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubviews()
        setupConstraints()
    }
}

private extension HomeView {
    func addSubviews() {
        addSubview(selectCurrencyFromButton)
        addSubview(currencyInputField)
        addSubview(currencySelectedLabel)
        addSubview(equivalenceLabel)
        addSubview(selectCurrencyToButton)
        addSubview(convertedValueLabel)
        addSubview(loadingIndicator)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            selectCurrencyFromButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DefaultsConstraints.leading),
            selectCurrencyFromButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50),
            
            currencyInputField.topAnchor.constraint(equalTo: selectCurrencyFromButton.bottomAnchor, constant: 10),
            currencyInputField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            currencyInputField.heightAnchor.constraint(equalToConstant: 40),
            currencyInputField.widthAnchor.constraint(equalToConstant: 120),
            
            currencySelectedLabel.centerYAnchor.constraint(equalTo: currencyInputField.centerYAnchor),
            currencySelectedLabel.leadingAnchor.constraint(equalTo: currencyInputField.trailingAnchor, constant: 16),
            
            equivalenceLabel.topAnchor.constraint(equalTo: currencyInputField.bottomAnchor, constant: 20),
            equivalenceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            selectCurrencyToButton.topAnchor.constraint(equalTo: equivalenceLabel.bottomAnchor, constant: 20),
            selectCurrencyToButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            convertedValueLabel.centerYAnchor.constraint(equalTo: equivalenceLabel.centerYAnchor),
            convertedValueLabel.leadingAnchor.constraint(equalTo: equivalenceLabel.trailingAnchor, constant: 16),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: convertedValueLabel.centerXAnchor, constant: 16),
            loadingIndicator.centerYAnchor.constraint(equalTo: convertedValueLabel.centerYAnchor)
        ])
    }
}

enum DefaultsConstraints {
    static let leading: CGFloat = 16
}
