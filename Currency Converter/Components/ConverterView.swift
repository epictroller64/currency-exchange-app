//
//  ConverterView.swift
//  Currency Converter
//
//  Created by User on 19.05.2025.
//

import SwiftUI
import FlagsKit

struct ConverterView: View {
    var body: some View {
        VStack {
            CurrencyInput(title: "From")
            CurrencyInput(title: "To")
            
        }.padding()
    }
}

struct CurrencyInput: View {
    @State private var amount: String = ""
    @FocusState private var isFocused: Bool
    @State private var selectedCurrency: String = "USD"
    let title: String
    var currencies = ["USD", "EUR", "GBP", "RUB", "YEN"]
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            HStack(spacing: 10) {
                FlagView(countryCode: Country.countryCode(fromCurrencyCode: selectedCurrency) ?? "USD", style: .circle)
                    .frame(width: 30, height: 30)
                    .padding(.leading, 10)
                Text("\(selectedCurrency)")
                    TextField("Amount", value: $amount, formatter: NumberFormatter())
                        .padding()
                        .keyboardType(.decimalPad)
                        .focused($isFocused)
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
