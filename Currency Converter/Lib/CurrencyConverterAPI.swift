//
//  CurrencyConverterAPI.swift
//  Currency Converter
//
//  Created by User on 19.05.2025.
//
import Foundation


func getApiKey() throws -> String {
    if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
       let dict = NSDictionary(contentsOfFile: path) {
        let API_KEY = dict["EXCHANGE_API_KEY"] as? String ?? ""
        return API_KEY
    }
    throw ExchangeError.missingApiKey
}

func fetchData(currency: String, amount: Double) async -> ApiResponse? {
    do {
        let API_KEY = try getApiKey()

        let urlString = "https://api.fxratesapi.com/latest?base=\(currency)&currencies=USD,GBP,JPY, EUR&resolution=1m&amount=\(amount)&places=6&format=json"
        guard let url = URL(string: urlString) else {return nil }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        if let httpResponse = response as? HTTPURLResponse {
            print("Status code: \(httpResponse.statusCode)")
            if httpResponse.statusCode != 200 {
                print("Sent: Currenc \(currency), API KEY: \(API_KEY)")
                print("URL: \(urlString)")
                return nil
            }
        }
        let decoded = try JSONDecoder().decode(ApiResponse.self, from: data)
        print(decoded)
        return decoded
    }
    catch {
        print("Error: \(error)")
        return nil
    }
}

func convertCurrency(baseCurrency: String, targetCurrency: String, amount: Double) async -> Double {
    guard let apiResponse = await fetchData(currency: baseCurrency, amount: amount) else {
        return 0.0
    }
    // Calculation is done by the API
    let targetRate = apiResponse.rates[targetCurrency.uppercased()] ?? 0.0
    print("TargetRate: \(targetRate) and final calculation: \(amount) * \(targetRate)")
    print("Rates: \(apiResponse.rates)")
    return targetRate
}
