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
    var body: some View {
        List(currencies, id: \.self) {
            currency in Button(currency) {
                selectedCurrency = currency
                showCurrencySelection = false
            }
        }.navigationTitle("Choose Currency")
    }
}
