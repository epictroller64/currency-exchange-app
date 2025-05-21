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
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 20) {
            CurrencyFrom()
                .environmentObject(currencyModel)
            CurrencySwapButton()
                .environmentObject(currencyModel)
            CurrencyTo()
                .environmentObject(currencyModel)
            ConversionButton(currencyModel: currencyModel, isPressed: $isPressed )
            
        }
        .padding(40)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.mint)
                .padding(10)
        }
    }
}

struct CurrencySwapButton: View {
    @EnvironmentObject var currencyModel: CurrencyModel
    var body: some View {
        Button(action: {
            let toCurrency = currencyModel.toCurrency
            let fromCurrency = currencyModel.fromCurrency
            currencyModel.toCurrency = fromCurrency
            currencyModel.fromCurrency = toCurrency
        }) {
            Image(systemName: "arrow.up.arrow.down")
        }
        .foregroundStyle(.white)
        .bold(true)
    }
}


struct ConversionButton:  View {
    @ObservedObject var currencyModel: CurrencyModel
    @Binding var isPressed: Bool

    var body: some View {
        Button("Convert") {
            Task {
                if currencyModel.amount.isNaN {
                    return
                }
                if currencyModel.amount == 0 {
                    return
                }
                withAnimation {
                    currencyModel.loading = true
                }
                let conversionResult = await convertCurrency(baseCurrency: currencyModel.fromCurrency, targetCurrency:currencyModel.toCurrency, amount:currencyModel.amount)
                currencyModel.result = conversionResult
                print("Final result: \(conversionResult)")
                withAnimation {
                    currencyModel.loading = false
                }
            }
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isPressed)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .padding(.horizontal, 50)
        .padding(.vertical, 20)
        .bold(true)
    }
}


class CurrencyModel: ObservableObject {
    @Published var fromCurrency: String = "USD"
    @Published var toCurrency: String = "EUR"
    @Published var amount: Double = 0
    @Published var result: Double = 0
    @Published var currencies = ["USD", "EUR", "GBP", "RUB", "YEN"]
    @Published var loading: Bool = false
}


struct CurrencyFrom: View {
    @FocusState private var isFocused: Bool
    @EnvironmentObject var currencyModel: CurrencyModel
    let formatter = NumberFormatter()
    @State var showCurrencyPicker: Bool = false

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
                Button(action: {
                    showCurrencyPicker = true
                }) {
                    FlagView(countryCode: Country.countryCode(fromCurrencyCode: currencyModel.fromCurrency) ?? "USD", style: .circle)
                        .frame(width: 30, height: 30)
                        .padding(.leading, 10)
                }
                .sheet(isPresented: $showCurrencyPicker) {
                    CurrencySelectionView(selectedCurrency: $currencyModel.fromCurrency, showCurrencySelection: $showCurrencyPicker, oppositeCurrency: $currencyModel.toCurrency)
                }
                Text("\(currencyModel.fromCurrency)")
                    .font(.system(size: 20))
                TextField("Amount", value: $currencyModel.amount, formatter: numberFormatter)
                    .padding()
                    .keyboardType(.decimalPad)
                    .focused($isFocused)
                    .foregroundStyle(.white)
                    .font(.system(size: 20))
                    .bold(true)
                    .animation(.easeInOut(duration: 0.4), value: currencyModel.result)
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
    @State var showCurrencyPicker: Bool = false
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
                Button(action: {
                    showCurrencyPicker = true
                }) {
                    FlagView(countryCode: Country.countryCode(fromCurrencyCode: currencyModel.toCurrency) ?? "USD", style: .circle)
                        .frame(width: 30, height: 30)
                        .padding(.leading, 10)
                }
                .sheet(isPresented: $showCurrencyPicker) {
                    CurrencySelectionView(selectedCurrency: $currencyModel.toCurrency, showCurrencySelection: $showCurrencyPicker, oppositeCurrency: $currencyModel.fromCurrency)
                }
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
                .animation(.easeInOut(duration: 0.4), value: currencyModel.result)
            }
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1)
            }
        }
    }
}
