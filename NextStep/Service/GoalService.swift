//
//  GoalService.swift
//  NextStep
//
//  Created by Тася Галкина on 21.03.2025.
//

import Foundation
import Alamofire
import Combine

final class GoalService {
    private let baseURL = "http://localhost:8080/goals"
    private let calendarManager = CalendarManager.shared

    func fetchGoals(for userId: Int) async throws -> [Goal] {
        let parameters: Parameters = ["user_id": userId]
        print("Fetching goals for userID: \(userId)")

        let response = await AF.request("\(baseURL)", parameters: parameters)
            .validate(statusCode: 200..<300)
            .serializingDecodable([Goal].self, decoder: {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return decoder
            }())
            .response

        switch response.result {
        case .success(let goals):
            return goals
        case .failure(let error):
            let errorMessage = response.data.flatMap { String(data: $0, encoding: .utf8) } ?? "Неизвестная ошибка сервера"
            throw NSError(domain: "ServerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось загрузить цели: \(errorMessage)"])
        }
    }

    func createGoal(goal: Goal) async throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let jsonData = try encoder.encode(goal)
        
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("JSON (createGoal): \(jsonString)")
        }

        let response = await AF.upload(jsonData, to: baseURL, method: .post, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .serializingData()
            .response

        switch response.result {
        case .success:
            return
        case .failure(let error):
            let errorMessage = response.data.flatMap { String(data: $0, encoding: .utf8) } ?? "Неизвестная ошибка сервера"
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
        let parameters: Parameters = ["user_id": userId]
        let url = "\(baseURL)/\(id)"

        let response = await AF.request(url, method: .delete, parameters: parameters)
            .validate(statusCode: 200..<300)
            .serializingData()
            .response

        switch response.result {
        case .success:
            return
        case .failure(let error):
            let errorMessage = response.data.flatMap { String(data: $0, encoding: .utf8) } ?? "Неизвестная ошибка сервера"
            throw NSError(domain: "ServerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось удалить цель: \(errorMessage)"])
        }
    }
    
    func fetchAllSubtasks(for userId: Int) async throws -> [Subtask] {
        let parameters: Parameters = ["userId": userId]
        let url = "http://localhost:8080/subtasks"
        
        print("Fetching subtasks: \(url)")

        let response = await AF.request(url, parameters: parameters)
            .validate(statusCode: 200..<300)
            .serializingDecodable([Subtask].self, decoder: {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return decoder
            }())
            .response

        switch response.result {
        case .success(let subtasks):
            return subtasks
        case .failure(let error):
            let errorMessage = response.data.flatMap { String(data: $0, encoding: .utf8) } ?? "Неизвестная ошибка сервера"
            throw NSError(domain: "ServerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось загрузить подзадачи: \(errorMessage)"])
        }
    }
    
    func updateSubtaskCompletion(_ subtask: Subtask) async throws {
        let url = "http://localhost:8080/subtasks/\(subtask.id)/complete"
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedSubtask = try encoder.encode(subtask)
        
        if let jsonString = String(data: encodedSubtask, encoding: .utf8) {
            print("JSON (updateSubtaskCompletion): \(jsonString)")
        }

        let response = await AF.upload(encodedSubtask, to: url, method: .put, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .serializingData()
            .response

        switch response.result {
        case .success:
            if let responseBody = response.data.flatMap { String(data: $0, encoding: .utf8) } {
                print("Response (updateSubtaskCompletion): \(responseBody)")
            }
            return
        case .failure(let error):
            let errorMessage = response.data.flatMap { String(data: $0, encoding: .utf8) } ?? "Неизвестная ошибка сервера"
            throw NSError(domain: "ServerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось обновить подзадачу: \(errorMessage)"])
        }
    }
    
    func fetchSubtasksByGoalId(forGoalID goalID: UUID) async throws -> [Subtask] {
        let url = "http://localhost:8080/goals/\(goalID)/subtasks"

        let response = await AF.request(url)
            .validate(statusCode: 200..<300)
            .serializingDecodable([Subtask].self, decoder: {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return decoder
            }())
            .response

        switch response.result {
        case .success(let subtasks):
            return subtasks
        case .failure(let error):
            let errorMessage = response.data.flatMap { String(data: $0, encoding: .utf8) } ?? "Неизвестная ошибка сервера"
            throw NSError(domain: "ServerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось загрузить подзадачи: \(errorMessage)"])
        }
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
        
        let parameters: Parameters = ["userId": userId]
        let url = "http://localhost:8080/subtasks/\(id)"

        let response = await AF.request(url, method: .delete, parameters: parameters)
            .validate(statusCode: 200..<300)
            .serializingData()
            .response

        switch response.result {
        case .success:
            print("Подзадача удалена с сервера: \(id)")
            return
        case .failure(let error):
            let errorMessage = response.data.flatMap { String(data: $0, encoding: .utf8) } ?? "Неизвестная ошибка сервера"
            throw NSError(domain: "ServerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось удалить подзадачу: \(errorMessage)"])
        }
    }
}
