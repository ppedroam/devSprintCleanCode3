//
//  HomeViewController.swift
//  CleanCode
//
//  Created by Pedro Menezes on 17/02/25.
//

import UIKit

class HomeViewController2: UIViewController, UITextFieldDelegate {
    private let homeView = HomeView()
    private var selectedCurrencyFrom: CurrencyTypeProtocol
    private var selectedCurrencyTo: CurrencyTypeProtocol
    private var conversionRate: Double = 0.0
    private let availableCurrencies: [CurrencyTypeProtocol]
    
    override func loadView() {
        self.view = homeView
    }
    
    init(selectedCurrencyFrom: CurrencyTypeProtocol, selectedCurrencyTo: CurrencyTypeProtocol, availableCurrencies: [CurrencyTypeProtocol]) {
        self.selectedCurrencyFrom = selectedCurrencyFrom
        self.selectedCurrencyTo = selectedCurrencyTo
        self.availableCurrencies = availableCurrencies
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
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
    
    private func setupActions() {
        homeView.selectCurrencyToButton.addTarget(self, action: #selector(selectCurrencyToTapped), for: .touchUpInside)
        homeView.currencyInputField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        homeView.selectCurrencyFromButton.addTarget(self, action: #selector(selectCurrencyFromTapped), for: .touchUpInside)
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

    
    @objc private func selectCurrencyFromTapped() {
        let alert = UIAlertController(title: "Selecione a moeda", message: nil, preferredStyle: .actionSheet)
        
        for currency in availableCurrencies {
            alert.addAction(UIAlertAction(title: currency.title, style: .default, handler: { _ in
                self.selectedCurrencyFrom = currency
                self.homeView.currencySelectedLabel.text = currency.title
                self.fetchConversionRate()
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func selectCurrencyToTapped() {
        let alert = UIAlertController(title: "Selecione a moeda de destino", message: nil, preferredStyle: .actionSheet)
        
        for currency in availableCurrencies where currency.title != selectedCurrencyFrom.title {
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
        homeView.currencyInputField.text = "1.00"
        homeView.convertedValueLabel.text = "--"
    }
    
    @objc private func textFieldDidChange() {
        guard let text = homeView.currencyInputField.text,
              let value = Double(text) else {
            homeView.convertedValueLabel.text = "--"
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
            homeView.convertedValueLabel.text = "\(formattedValue) \(selectedCurrencyTo.titlePlural)"
        } else {
            homeView.convertedValueLabel.text = "--"
        }
    }
    
    private func fetchConversionRate() {
        let urlString = "https://api.currencyapi.com/v3/latest?apikey=cur_live_JhWFLtfhpMPH6AElpf3PMcZQmg8dI9kHMnWhLLlM&currencies=\(selectedCurrencyTo.identifier)&base_currency=\(selectedCurrencyFrom.identifier)"
        
        guard let url = URL(string: urlString) else { return }
        
        showLoading(true)
        
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.showLoading(false)
                if let _ = error {
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
            homeView.convertedValueLabel.text = ""
            homeView.loadingIndicator.startAnimating()
        } else {
            homeView.loadingIndicator.stopAnimating()
        }
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
