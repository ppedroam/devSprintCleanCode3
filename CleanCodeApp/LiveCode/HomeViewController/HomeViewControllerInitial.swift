//
//  HomeViewController.swift
//  CleanCode
//
//  Created by Pedro Menezes on 01/02/25.
//

import UIKit

enum CurrencyTypeI: CaseIterable {
    case brl, usd, eur
    
    var identifier: String {
        switch self {
        case .brl: return "BRL"
        case .usd: return "USD"
        case .eur: return "EUR"
        }
    }
    
    var title: String {
        switch self {
        case .brl: return "Real"
        case .usd: return "Dólar Americano"
        case .eur: return "Euro"
        }
    }
    
    var titlePlural: String {
        switch self {
        case .brl: return "Reais"
        case .usd: return "Dólares Americanos"
        case .eur: return "Euros"
        }
    }
}

class HomeViewControllerI: UIViewController, UITextFieldDelegate {
    
    private var selectedCurrencyFrom: CurrencyType = .brl
    private var selectedCurrencyTo: CurrencyType = .usd
    private var conversionRate: Double = 0.0
    
    private lazy var selectCurrencyFromButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Selecionar moeda origem", for: .normal)
        button.addTarget(self, action: #selector(selectCurrencyFromTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var currencyInputField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.keyboardType = .decimalPad
        textField.placeholder = "Digite um valor"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var currencySelectedLabel: UILabel = {
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
    
    private lazy var selectCurrencyToButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Selecionar moeda destino", for: .normal)
        button.addTarget(self, action: #selector(selectCurrencyToTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var convertedValueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        updateLabels()
        fetchConversionRate()
        
        title = "Conversor de Moeda"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sair",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(logoutTapped))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didClickView))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func didClickView() {
        view.endEditing(true)
    }
    
    @objc private func logoutTapped() {
        UserDefaultsManager.UserInfos.shared.delete()
        let storyboard = UIStoryboard(name: "SolUser", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SolLoginViewController") as! SolLoginViewController
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
    private func setupUI() {
        view.addSubview(selectCurrencyFromButton)
        view.addSubview(currencyInputField)
        view.addSubview(currencySelectedLabel)
        view.addSubview(equivalenceLabel)
        view.addSubview(selectCurrencyToButton)
        view.addSubview(convertedValueLabel)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            selectCurrencyFromButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selectCurrencyFromButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            
            currencyInputField.topAnchor.constraint(equalTo: selectCurrencyFromButton.bottomAnchor, constant: 10),
            currencyInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            currencyInputField.heightAnchor.constraint(equalToConstant: 40),
            currencyInputField.widthAnchor.constraint(equalToConstant: 120),
            
            currencySelectedLabel.centerYAnchor.constraint(equalTo: currencyInputField.centerYAnchor),
            currencySelectedLabel.leadingAnchor.constraint(equalTo: currencyInputField.trailingAnchor, constant: 16),
            
            equivalenceLabel.topAnchor.constraint(equalTo: currencyInputField.bottomAnchor, constant: 20),
            equivalenceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            selectCurrencyToButton.topAnchor.constraint(equalTo: equivalenceLabel.bottomAnchor, constant: 20),
            selectCurrencyToButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            convertedValueLabel.centerYAnchor.constraint(equalTo: equivalenceLabel.centerYAnchor),
            convertedValueLabel.leadingAnchor.constraint(equalTo: equivalenceLabel.trailingAnchor, constant: 16),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: convertedValueLabel.centerXAnchor, constant: 16),
            loadingIndicator.centerYAnchor.constraint(equalTo: convertedValueLabel.centerYAnchor)
        ])
    }
    
    @objc private func selectCurrencyFromTapped() {
        let alert = UIAlertController(title: "Selecione a moeda", message: nil, preferredStyle: .actionSheet)
        
        for currency in CurrencyType.allCases {
            alert.addAction(UIAlertAction(title: currency.title, style: .default, handler: { _ in
                self.selectedCurrencyFrom = currency
                self.currencySelectedLabel.text = currency.title
                self.fetchConversionRate()
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func selectCurrencyToTapped() {
        let alert = UIAlertController(title: "Selecione a moeda de destino", message: nil, preferredStyle: .actionSheet)
        
        for currency in CurrencyType.allCases where currency != selectedCurrencyFrom {
            alert.addAction(UIAlertAction(title: currency.title, style: .default, handler: { _ in
                self.selectedCurrencyTo = currency
                self.updateLabels()
                self.fetchConversionRate()
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func updateLabels() {
        currencyInputField.text = "1.00"
        convertedValueLabel.text = "--"
    }
    
    @objc private func textFieldDidChange() {
        guard let text = currencyInputField.text, let value = Double(text) else {
            convertedValueLabel.text = "--"
            return
        }
        let convertedValue = value * conversionRate
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."
        
        if let formattedValue = formatter.string(from: NSNumber(value: convertedValue)) {
            convertedValueLabel.text = "\(formattedValue) \(selectedCurrencyTo.titlePlural)"
        } else {
            convertedValueLabel.text = "--"
        }
    }
    
    private func fetchConversionRate() {
        let urlString = "https://api.currencyapi.com/v3/latest?apikey=cur_live_JhWFLtfhpMPH6AElpf3PMcZQmg8dI9kHMnWhLLlM&currencies=\(selectedCurrencyTo.identifier)&base_currency=\(selectedCurrencyFrom.identifier)"
        
        guard let url = URL(string: urlString) else { return }
        
        showLoading(true)
        
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.showLoading(false)
                if let error = error {
                    self.showErrorAlert(message: "Erro ao obter dados")
                    return
                }
                
                guard let data = data else {
                    self.showErrorAlert(message: "Erro ao obter dados")
                    return
                }
                
                let destinyCode = self.selectedCurrencyTo.identifier
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let dataMap = jsonObject?["data"] as? [String: Any],
                       let currencyInfo = dataMap[destinyCode] as? [String: Any],
                       let value = currencyInfo["value"] as? Double {
                        self.conversionRate = value
                        self.textFieldDidChange()
                    } else {
                        self.showErrorAlert(message: "Erro ao obter dados")
                    }
                } catch {
                    self.showErrorAlert(message: "Erro ao obter dados")
                }
            }
        }.resume()
    }
    
    func showLoading(_ isLoading: Bool) {
        if isLoading {
            convertedValueLabel.text = ""
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
