//
//  DeepSeekModels.swift
//  NextStep
//
//  Created by Тася Галкина on 24.04.2025.
//

import Foundation

struct DeepSeekResponse: Decodable {
    let choices: [Choice]
    
    struct Choice: Decodable {
        let message: Message
    }
    
    struct Message: Decodable {
        let content: String
    }
}

struct DeepSeekError: Decodable {
    let error: ErrorDetails
    
    struct ErrorDetails: Decodable {
        let message: String
        let code: Int
    }
}

struct DeepSeekChoice: Codable {
    let message: DeepSeekMessage
}

struct DeepSeekMessage: Codable {
    let content: String
}

struct APIError: Codable {
    let message: String
    let code: Int
}
