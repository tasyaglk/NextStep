//
//  DeepSeekService.swift
//  NextStep
//
//  Created by Тася Галкина on 24.04.2025.
//

import Foundation

class DeepSeekService {
    static let shared = DeepSeekService()
    
    private let baseURL = "http://localhost:8080/deepseek" 
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private init() {}
    
    func reformulateGoal(_ goal: String) async throws -> String {
        let url = URL(string: "\(baseURL)/reformulate-goal")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["goal": goal]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "Server error", code: -1, userInfo: nil)
        }
        
        let result = try JSONDecoder().decode([String: String].self, from: data)
        guard let reformulatedGoal = result["result"] else {
            throw NSError(domain: "Invalid response", code: -1, userInfo: nil)
        }
        
        return reformulatedGoal
    }
    
    func validateGoal(_ goal: String) async throws -> Bool {
        let url = URL(string: "\(baseURL)/validate-goal")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["goal": goal]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "Server error", code: -1, userInfo: nil)
        }
        
        let result = try JSONDecoder().decode([String: Bool].self, from: data)
        guard let isValid = result["is_valid"] else {
            throw NSError(domain: "Invalid response", code: -1, userInfo: nil)
        }
        
        return isValid
    }
    
    func validatePlanFeedback(feedback: String, goal: String) async throws -> Bool {
        let url = URL(string: "\(baseURL)/validate-plan-feedback")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["feedback": feedback, "goal": goal]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "Server error", code: -1, userInfo: nil)
        }
        
        let result = try JSONDecoder().decode([String: Bool].self, from: data)
        guard let isValid = result["is_valid"] else {
            throw NSError(domain: "Invalid response", code: -1, userInfo: nil)
        }
        
        return isValid
    }
    
    func validateScheduleFeedback(feedback: String) async throws -> Bool {
        let url = URL(string: "\(baseURL)/validate-schedule-feedback")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["feedback": feedback]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "Server error", code: -1, userInfo: nil)
        }
        
        let result = try JSONDecoder().decode([String: Bool].self, from: data)
        guard let isValid = result["is_valid"] else {
            throw NSError(domain: "Invalid response", code: -1, userInfo: nil)
        }
        
        return isValid
    }
    
    func generateSteps(goal: String, knowledge: String, feedback: String? = nil) async throws -> [String] {
        let url = URL(string: "\(baseURL)/generate-steps")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var body: [String: String] = ["goal": goal, "knowledge": knowledge]
        if let feedback = feedback {
            body["feedback"] = feedback
        }
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "Server error", code: -1, userInfo: nil)
        }
        
        let result = try JSONDecoder().decode([String: [String]].self, from: data)
        guard let steps = result["steps"] else {
            throw NSError(domain: "Invalid response", code: -1, userInfo: nil)
        }
        
        return steps
    }
    
    func generateSchedule(
        steps: [String],
        availability: String,
        frequency: String,
        feedback: String?,
        busySlots: [(start: Date, end: Date)]
    ) async throws -> String {
        let url = URL(string: "\(baseURL)/generate-schedule")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dateFormatter = ISO8601DateFormatter()
        let busySlotsArray = busySlots.map { [dateFormatter.string(from: $0.start), dateFormatter.string(from: $0.end)] }
        
        var body: [String: Any] = [
            "steps": steps,
            "availability": availability,
            "frequency": frequency,
            "busy_slots": busySlotsArray
        ]
        if let feedback = feedback {
            body["feedback"] = feedback
        }
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "Server error", code: -1, userInfo: nil)
        }
        
        let result = try JSONDecoder().decode([String: String].self, from: data)
        guard let schedule = result["schedule"] else {
            throw NSError(domain: "Invalid response", code: -1, userInfo: nil)
        }
        
        return schedule
    }
}
