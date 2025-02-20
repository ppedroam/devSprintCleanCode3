//
//  HomeViewModel.swift
//  CleanCode
//
//  Created by Pedro Menezes on 19/02/25.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func presentLoading()
    func hideLoading()
    func showAlert(text: String)
    func updateTextFields()
}

protocol HomeViewModeling  {
    var delegate: HomeViewModelDelegate? { get set }
    var conversionRate: Double { get }
    var currencyOriginTitle: String { get }
    var currencyDestinyPluralTitle: String { get }
    
    func fetchConversionRate()
    func getAvailablaCurrencies(filterOrigin: Bool) -> [CurrencyTypeProtocol]
    func didUpdateCurrency(isOriginCurrency: Bool, currency: CurrencyTypeProtocol)
}

extension HomeViewModeling {
    func getAvailablaCurrencies() -> [CurrencyTypeProtocol] {
        getAvailablaCurrencies(filterOrigin: false)
    }
}

class HomeViewModel: HomeViewModeling {
    private let availableCurrencies: [CurrencyTypeProtocol]
    private var selectedCurrencyFrom: CurrencyTypeProtocol
    private var selectedCurrencyTo: CurrencyTypeProtocol
    private var conversionRate_: Double = 0.0
    
    var conversionRate: Double {
        return conversionRate_
    }
    
    var currencyDestinyPluralTitle: String {
        return selectedCurrencyTo.titlePlural
    }
    
    var currencyOriginTitle: String {
        return selectedCurrencyFrom.title
    }
    
    init(
        selectedCurrencyFrom: CurrencyTypeProtocol,
        selectedCurrencyTo: CurrencyTypeProtocol,
        availableCurrencies: [CurrencyTypeProtocol]
    ) {
        self.selectedCurrencyFrom = selectedCurrencyFrom
        self.selectedCurrencyTo = selectedCurrencyTo
        self.availableCurrencies = availableCurrencies
    }
    
    weak var delegate: HomeViewModelDelegate?
    
    func getAvailablaCurrencies(filterOrigin: Bool) -> [CurrencyTypeProtocol] {
        if filterOrigin {
            return availableCurrencies
        } else {
            let returnCurrencies = availableCurrencies.filter({ $0.title != selectedCurrencyFrom.title})
            return returnCurrencies
        }
    }
    
    func didUpdateCurrency(isOriginCurrency: Bool, currency: CurrencyTypeProtocol) {
        if isOriginCurrency {
            self.selectedCurrencyFrom = currency
        } else {
            self.selectedCurrencyTo = currency

        }
        self.fetchConversionRate()

    }
    
    func fetchConversionRate() {
        let originCurrencyIdentifier = selectedCurrencyFrom.identifier
        let destinyCurrencyIdentifier = selectedCurrencyTo.identifier
        
        let urlString = ApiEndpoints.createFetchConversionRate(from: originCurrencyIdentifier,
                                                               to: destinyCurrencyIdentifier)
        
        guard let url = URL(string: urlString) else { return }
        delegate?.presentLoading()
        
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self,
                        let data = data else {
                    self?.delegate?.showAlert(text: "Oops... Algo de errado aconteceu")
                    return
                }
                self.delegate?.hideLoading()

                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let dataMap = jsonObject?["data"] as? [String: Any],
                       let currencyInfo = dataMap[originCurrencyIdentifier] as? [String: Any],
                       let value = currencyInfo["value"] as? Double {
                        self.conversionRate_ = value
                        self.delegate?.updateTextFields()

                    } else {
                        self.delegate?.showAlert(text: "Erro ao obter dados")
                    }
                } catch {
                    self.delegate?.showAlert(text: "Erro ao obter dados")
                }
            }
        }.resume()
    }
}
