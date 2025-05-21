//
//  CurrencySelectionView.swift
//  Currency Converter
//
//  Created by User on 20.05.2025.
//

import SwiftUI

struct CurrencySelectionView: View {
    let currencies = ["USD", "EUR", "RUB", "GBP"]
    @Binding var selectedCurrency: String
    @Binding var showCurrencySelection: Bool
    @Binding var oppositeCurrency: String

    var body: some View {
        NavigationView {
            List {
                ForEach(filterOutUsedCurrency(currencies: currencies, usedCurrency: selectedCurrency, oppositeCurrency: oppositeCurrency), id: \.self) { currency in
                    HStack {
                        Text(currency)
                            .font(.headline)
                            .padding(.vertical, 8)
                        Spacer()
                        if selectedCurrency == currency {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedCurrency = currency
                        showCurrencySelection = false
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Choose Currency")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showCurrencySelection = false
                    }
                }
            }
        }
    }
}

func filterOutUsedCurrency(currencies: [String], usedCurrency: String, oppositeCurrency: String) -> [String] {
    return currencies.filter {$0 != usedCurrency && $0 != oppositeCurrency}
}
