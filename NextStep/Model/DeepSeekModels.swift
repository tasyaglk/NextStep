//
//  DeepSeekModels.swift
//  NextStep
//
//  Created by Тася Галкина on 24.04.2025.
//

import Foundation

struct DeepSeekResponse: Codable {
    let choices: [DeepSeekChoice]
}

struct DeepSeekChoice: Codable {
    let message: DeepSeekMessage
}

struct DeepSeekMessage: Codable {
    let content: String
}


struct DeepSeekError: Codable {
    let error: APIError
}

struct APIError: Codable {
    let message: String
    let code: Int
}
