//
//  GoalService.swift
//  NextStep
//
//  Created by Тася Галкина on 21.03.2025.
//

import Foundation
import Combine

final class GoalService {
    private let baseURL = "http://localhost:8080/goals"

    func fetchGoals(for userId: Int) async throws -> [Goal] {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [URLQueryItem(name: "user_id", value: "\(userId)")]

        let (data, _) = try await URLSession.shared.data(from: components.url!)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([Goal].self, from: data)
    }

    func createGoal(goal: Goal) async throws {
        let encoder = JSONEncoder()
        
        encoder.dateEncodingStrategy = .iso8601
        
        let jsonData = try encoder.encode(goal)
        
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("JSON: \(jsonString)")
        }
        
        var request = URLRequest(url: URL(string: "http://localhost:8080/goals")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            print("success")
        } else {
            print("error: \(String(data: data, encoding: .utf8) ?? "")")
        }
    }

    func updateGoal(_ goal: Goal) async throws {
        var request = URLRequest(url: URL(string: "\(baseURL)/\(goal.id)")!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedGoal = try encoder.encode(goal)
        
        if let jsonString = String(data: encodedGoal, encoding: .utf8) {
            print("JSON:\n\(jsonString)")
        }

        request.httpBody = encodedGoal

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server returned error code: \(httpResponse.statusCode)"])
                }
            }

            if let responseBody = String(data: data, encoding: .utf8) {
                print("JSON:\n \(responseBody)")
            }

        } catch {
            print("error \(error.localizedDescription)")
            throw error
        }
    }


    func deleteGoal(id: UUID, userId: Int) async throws {
        var components = URLComponents(string: "\(baseURL)/\(id)")!
        components.queryItems = [URLQueryItem(name: "user_id", value: "\(userId)")]

        var request = URLRequest(url: components.url!)
        request.httpMethod = "DELETE"
        _ = try await URLSession.shared.data(for: request)
    }
    
    func fetchAllSubtasks() async throws -> [Subtask] {
        guard let url = URL(string: "http://localhost:8080/subtasks") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode([Subtask].self, from: data)
    }
    
    func updateSubtaskCompletion(_ subtask: Subtask) async throws {
        guard let url = URL(string: "http://localhost:8080/subtasks/\(subtask.id)/complete") else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedSubtask = try encoder.encode(subtask)
        
        if let jsonString = String(data: encodedSubtask, encoding: .utf8) {
            print("🚀 JSON отправляемый на сервер:")
            print(jsonString)
        }

        request.httpBody = encodedSubtask
        
        let (data, response) = try await URLSession.shared.data(for: request)
        if let responseBody = String(data: data, encoding: .utf8) {
            print("JSON:\n \(responseBody)")
        }
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }


}
