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
    private let calendarManager = CalendarManager.shared

    func fetchGoals(for userId: Int) async throws -> [Goal] {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [URLQueryItem(name: "user_id", value: "\(userId)")]
        
        print("Fetching goals for userID: \(userId)")

        let (data, response) = try await URLSession.shared.data(from: components.url!)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Неизвестная ошибка сервера"
            throw NSError(domain: "ServerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось загрузить цели: \(errorMessage)"])
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([Goal].self, from: data)
    }

    func createGoal(goal: Goal) async throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let jsonData = try encoder.encode(goal)
        
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("JSON (createGoal): \(jsonString)")
        }
        
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Неизвестная ошибка сервера"
            throw NSError(domain: "ServerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось создать цель: \(errorMessage)"])
        }
    }

    func updateGoal(_ goal: Goal) async throws {
        if let existingGoal = try await fetchGoals(for: goal.userId).first(where: { $0.id == goal.id }) {
            try await deleteGoal(id: goal.id, userId: goal.userId)
        }
        
        let updatedGoal = try await calendarManager.synchronizeSubtasks(goal: goal)
        try await createGoal(goal: updatedGoal)
        
        print("Goal updated by deleting and recreating: \(updatedGoal)")
    }

    func deleteGoal(id: UUID, userId: Int) async throws {
        var components = URLComponents(string: "\(baseURL)/\(id)")!
        components.queryItems = [URLQueryItem(name: "user_id", value: "\(userId)")]

        var request = URLRequest(url: components.url!)
        request.httpMethod = "DELETE"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Неизвестная ошибка сервера"
            throw NSError(domain: "ServerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось удалить цель: \(errorMessage)"])
        }
    }
    
    func fetchAllSubtasks(for userId: Int) async throws -> [Subtask] {
        var components = URLComponents(string: "http://localhost:8080/subtasks")!
        components.queryItems = [
            URLQueryItem(name: "userId", value: "\(userId)")
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        print("Fetching subtasks: \(url)")

        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Неизвестная ошибка сервера"
            throw NSError(domain: "ServerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось загрузить подзадачи: \(errorMessage)"])
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([Subtask].self, from: data)
    }
    
    func updateSubtaskCompletion(_ subtask: Subtask) async throws {
        guard let url = URL(string: "http://localhost:8080/subtasks/\(subtask.id)/complete") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedSubtask = try encoder.encode(subtask)
        
        if let jsonString = String(data: encodedSubtask, encoding: .utf8) {
            print("JSON (updateSubtaskCompletion): \(jsonString)")
        }

        request.httpBody = encodedSubtask
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Неизвестная ошибка сервера"
            throw NSError(domain: "ServerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось обновить подзадачу: \(errorMessage)"])
        }
        
        if let responseBody = String(data: data, encoding: .utf8) {
            print("Response (updateSubtaskCompletion): \(responseBody)")
        }
    }
    
    func fetchSubtasksByGoalId(forGoalID goalID: UUID) async throws -> [Subtask] {
        let url = URL(string: "http://localhost:8080/goals/\(goalID)/subtasks")!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Неизвестная ошибка сервера"
            throw NSError(domain: "ServerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось загрузить подзадачи: \(errorMessage)"])
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([Subtask].self, from: data)
    }
    
    func deleteSubtask(id: UUID, userId: Int) async throws {
        let subtasks = try await fetchAllSubtasks(for: userId)
        if let subtask = subtasks.first(where: { $0.id == id }) {
            do {
                try await calendarManager.removeEvent(for: subtask)
                print("\(subtask.title), eventID: \(subtask.calendarEventID ?? "nil")")
            } catch {
                print("Ошибка удаления события из календаря для подзадачи \(subtask.title): \(error.localizedDescription)")
            }
        } else {
            print("Подзадача с id \(id) не найдена")
        }
        
        var components = URLComponents(string: "http://localhost:8080/subtasks/\(id)")!
        components.queryItems = [URLQueryItem(name: "userId", value: "\(userId)")]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Неизвестная ошибка сервера"
            throw NSError(domain: "ServerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось удалить подзадачу: \(errorMessage)"])
        }
        
        print("Подзадача удалена с сервера: \(id)")
    }
}
