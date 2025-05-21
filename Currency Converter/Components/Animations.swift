//
//  Animations.swift
//  Currency Converter
//
//  Created by User on 20.05.2025.
//
import SwiftUI

struct Animations: View {
    @State private var bounce = false

        var body: some View {
            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    Circle()
                        .frame(width: 5, height: 5)
                        .foregroundColor(.black)
                        .offset(y: bounce ? -5 : 5)
                        .animation(
                            Animation
                                .easeInOut(duration: 0.6)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                            value: bounce
                        )
                }
            }
            .onAppear {
                bounce = true
            }
        }
}


#Preview {
    Animations()
}
