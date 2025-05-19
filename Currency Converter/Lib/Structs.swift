//
//  Structs.swift
//  Currency Converter
//
//  Created by User on 19.05.2025.
//

// Using https://exchangeratesapi.io/documentation/
struct ApiResponse: Codable {
    let success: Bool
    let timestamp: Int
    let base: String
    let date: String
    let privacy: String
    let terms: String
    let rates: [String: Double]
}
