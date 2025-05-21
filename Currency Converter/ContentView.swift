//
//  ContentView.swift
//  Currency Converter
//
//  Created by User on 19.05.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.mint, .white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            VStack(spacing: 10) {   
                Text("Currency Converter")
                    .font(.largeTitle)
                    .foregroundStyle(Color.black)
                    .bold(true)
                ConverterView()
                        .shadow(radius: 10)
                        .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ContentView()
}
