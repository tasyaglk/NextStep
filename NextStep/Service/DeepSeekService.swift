//
//  DeepSeekService.swift
//  NextStep
//
//  Created by Тася Галкина on 24.04.2025.
//

import Foundation
import Alamofire
import Combine

class DeepSeekService {
    static let shared = DeepSeekService()
    
    private let baseURL = "http://localhost:8080/deepseek"
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private init() {}
    
    // MARK: - Reformulate Goal
    func reformulateGoal(_ goal: String) async throws -> String {
        let url = "\(baseURL)/reformulate-goal"
        let parameters = ["goal": goal]
        
        let response = await AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .serializingDecodable([String: String].self, decoder: jsonDecoder)
            .response
        
        switch response.result {
        case .success(let result):
            guard let reformulatedGoal = result["result"] else {
                throw NSError(domain: "Invalid response", code: -1, userInfo: nil)
            }
            return reformulatedGoal
        case .failure:
            throw NSError(domain: "Server error", code: -1, userInfo: nil)
        }
    }
    
    func reformulateGoal(_ goal: String) -> AnyPublisher<String, Error> {
        let url = "\(baseURL)/reformulate-goal"
        let parameters = ["goal": goal]
        
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .publishDecodable(type: [String: String].self, decoder: jsonDecoder)
            .tryMap { response in
                guard let reformulatedGoal = response.value?["result"] else {
                    throw NSError(domain: "Invalid response", code: -1, userInfo: nil)
                }
                return reformulatedGoal
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Validate Goal
    func validateGoal(_ goal: String) async throws -> Bool {
        let url = "\(baseURL)/validate-goal"
        let parameters = ["goal": goal]
        
        let response = await AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .serializingDecodable([String: Bool].self, decoder: jsonDecoder)
            .response
        
        switch response.result {
        case .success(let result):
            guard let isValid = result["is_valid"] else {
                throw NSError(domain: "Invalid response", code: -1, userInfo: nil)
            }
            return isValid
        case .failure:
            throw NSError(domain: "Server error", code: -1, userInfo: nil)
        }
    }
    
    func validateGoal(_ goal: String) -> AnyPublisher<Bool, Error> {
        let url = "\(baseURL)/validate-goal"
        let parameters = ["goal": goal]
        
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .publishDecodable(type: [String: Bool].self, decoder: jsonDecoder)
            .tryMap { response in
                guard let isValid = response.value?["is_valid"] else {
                    throw NSError(domain: "Invalid response", code: -1, userInfo: nil)
                }
                return isValid
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Validate Plan Feedback
    func validatePlanFeedback(feedback: String, goal: String) async throws -> Bool {
        let url = "\(baseURL)/validate-plan-feedback"
        let parameters = ["feedback": feedback, "goal": goal]
        
        let response = await AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .serializingDecodable([String: Bool].self, decoder: jsonDecoder)
            .response
        
        switch response.result {
        case .success(let result):
            guard let isValid = result["is_valid"] else {
                throw NSError(domain: "Invalid response", code: -1, userInfo: nil)
            }
            return isValid
        case .failure:
            throw NSError(domain: "Server error", code: -1, userInfo: nil)
        }
    }
    
    func validatePlanFeedback(feedback: String, goal: String) -> AnyPublisher<Bool, Error> {
        let url = "\(baseURL)/validate-plan-feedback"
        let parameters = ["feedback": feedback, "goal": goal]
        
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .publishDecodable(type: [String: Bool].self, decoder: jsonDecoder)
            .tryMap { response in
                guard let isValid = response.value?["is_valid"] else {
                    throw NSError(domain: "Invalid response", code: -1, userInfo: nil)
                }
                return isValid
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Validate Schedule Feedback
    func validateScheduleFeedback(feedback: String) async throws -> Bool {
        let url = "\(baseURL)/validate-schedule-feedback"
        let parameters = ["feedback": feedback]
        
        let response = await AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .serializingDecodable([String: Bool].self, decoder: jsonDecoder)
            .response
        
        switch response.result {
        case .success(let result):
            guard let isValid = result["is_valid"] else {
                throw NSError(domain: "Invalid response", code: -1, userInfo: nil)
            }
            return isValid
        case .failure:
            throw NSError(domain: "Server error", code: -1, userInfo: nil)
        }
    }
    
    func validateScheduleFeedback(feedback: String) -> AnyPublisher<Bool, Error> {
        let url = "\(baseURL)/validate-schedule-feedback"
        let parameters = ["feedback": feedback]
        
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .publishDecodable(type: [String: Bool].self, decoder: jsonDecoder)
            .tryMap { response in
                guard let isValid = response.value?["is_valid"] else {
                    throw NSError(domain: "Invalid response", code: -1, userInfo: nil)
                }
                return isValid
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Generate Steps
    func generateSteps(goal: String, knowledge: String, feedback: String? = nil) async throws -> [String] {
        let url = "\(baseURL)/generate-steps"
        var parameters: [String: String] = ["goal": goal, "knowledge": knowledge]
        if let feedback = feedback {
            parameters["feedback"] = feedback
        }
        
        let response = await AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .serializingDecodable([String: [String]].self, decoder: jsonDecoder)
            .response
        
        switch response.result {
        case .success(let result):
            guard let steps = result["steps"] else {
                throw NSError(domain: "Invalid response", code: -1, userInfo: nil)
            }
            return steps
        case .failure:
            throw NSError(domain: "Server error", code: -1, userInfo: nil)
        }
    }
    
    func generateSteps(goal: String, knowledge: String, feedback: String? = nil) -> AnyPublisher<[String], Error> {
        let url = "\(baseURL)/generate-steps"
        var parameters: [String: String] = ["goal": goal, "knowledge": knowledge]
        if let feedback = feedback {
            parameters["feedback"] = feedback
        }
        
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .publishDecodable(type: [String: [String]].self, decoder: jsonDecoder)
            .tryMap { response in
                guard let steps = response.value?["steps"] else {
                    throw NSError(domain: "Invalid response", code: -1, userInfo: nil)
                }
                return steps
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Generate Schedule
    func generateSchedule(
        steps: [String],
        availability: String,
        frequency: String,
        feedback: String?,
        busySlots: [(start: Date, end: Date)]
    ) async throws -> String {
        let url = "\(baseURL)/generate-schedule"
        let dateFormatter = ISO8601DateFormatter()
        let busySlotsArray = busySlots.map { [dateFormatter.string(from: $0.start), dateFormatter.string(from: $0.end)] }
        
        var parameters: [String: Any] = [
            "steps": steps,
            "availability": availability,
            "frequency": frequency,
            "busy_slots": busySlotsArray
        ]
        if let feedback = feedback {
            parameters["feedback"] = feedback
        }
        
        let response = await AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .serializingDecodable([String: String].self, decoder: jsonDecoder)
            .response
        
        switch response.result {
        case .success(let result):
            guard let schedule = result["schedule"] else {
                throw NSError(domain: "Invalid response", code: -1, userInfo: nil)
            }
            return schedule
        case .failure:
            throw NSError(domain: "Server error", code: -1, userInfo: nil)
        }
    }
    
    func generateSchedule(
        steps: [String],
        availability: String,
        frequency: String,
        feedback: String?,
        busySlots: [(start: Date, end: Date)]
    ) -> AnyPublisher<String, Error> {
        let url = "\(baseURL)/generate-schedule"
        let dateFormatter = ISO8601DateFormatter()
        let busySlotsArray = busySlots.map { [dateFormatter.string(from: $0.start), dateFormatter.string(from: $0.end)] }
        
        var parameters: [String: Any] = [
            "steps": steps,
            "availability": availability,
            "frequency": frequency,
            "busy_slots": busySlotsArray
        ]
        if let feedback = feedback {
            parameters["feedback"] = feedback
        }
        
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .publishDecodable(type: [String: String].self, decoder: jsonDecoder)
            .tryMap { response in
                guard let schedule = response.value?["schedule"] else {
                    throw NSError(domain: "Invalid response", code: -1, userInfo: nil)
                }
                return schedule
            }
            .eraseToAnyPublisher()
    }
}
