//
//  ConverterView.swift
//  Currency Converter
//
//  Created by User on 19.05.2025.
//

import SwiftUI
import FlagsKit

struct ConverterView: View {
    @StateObject var currencyModel = CurrencyModel()
    var body: some View {
        VStack {
            CurrencyFrom()
                .environmentObject(currencyModel)
            CurrencyTo()
                .environmentObject(currencyModel)
            Button("Convert") {
                Task {
                    let conversionResult = await convertCurrency(baseCurrency: currencyModel.fromCurrency, targetCurrency:currencyModel.toCurrency, amount:currencyModel.amount)
                        self.currencyModel.result = conversionResult
                        print("Final result: \(conversionResult)")
                }
            }
            .padding(.horizontal, 50)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
            }
            .bold(true)
            
        }
        .padding(40)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.green)
                .padding(10)
        }
        .frame(height: 100)
    }
}

class CurrencyModel: ObservableObject {
    @Published var fromCurrency: String = "USD"
    @Published var toCurrency: String = "EUR"
    @Published var amount: Double = 0
    @Published var result: Double = 0
    @Published var currencies = ["USD", "EUR", "GBP", "RUB", "YEN"]

}


struct CurrencyFrom: View {
    @FocusState private var isFocused: Bool
    @EnvironmentObject var currencyModel: CurrencyModel
    let formatter = NumberFormatter()
    
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text("From")
                .bold(true)
            HStack(spacing: 10) {
                FlagView(countryCode: Country.countryCode(fromCurrencyCode: currencyModel.fromCurrency) ?? "USD", style: .circle)
                    .frame(width: 30, height: 30)
                    .padding(.leading, 10)
                Text("\(currencyModel.fromCurrency)")
                    .font(.system(size: 20))
                TextField("Amount", value: $currencyModel.amount, formatter: numberFormatter)
                    .padding()
                    .keyboardType(.decimalPad)
                    .focused($isFocused)
                    .foregroundStyle(.white)
                    .font(.system(size: 20))
                    .bold(true)
                }
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1)
            }
        }
    }
}

struct CurrencyTo: View {
    @FocusState private var isFocused: Bool
    @EnvironmentObject var currencyModel: CurrencyModel;
    let formatter = NumberFormatter()
    
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("From")
                .bold(true)
            HStack(spacing: 10) {
                FlagView(countryCode: Country.countryCode(fromCurrencyCode: currencyModel.toCurrency) ?? "USD", style: .circle)
                    .frame(width: 30, height: 30)
                    .padding(.leading, 10)
                Text("\(currencyModel.toCurrency)")
                    .font(.system(size: 20))
                TextField("To", value: $currencyModel.result,
                formatter: numberFormatter)
                        .padding()
                        .disabled(true)
                        .focused($isFocused)
                        .foregroundStyle(.white)
                        .font(.system(size: 20))
                        .bold(true)
                        .frame(maxWidth: .infinity)
                }
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1)
            }
        }
    }
}


#Preview {
    ConverterView()
}
