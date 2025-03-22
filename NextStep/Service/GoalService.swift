//
//  GoalService.swift
//  NextStep
//
//  Created by Тася Галкина on 21.03.2025.
//

import SwiftUI

class GoalsAPI {
    static let shared = GoalsAPI()
    private let baseURL = URL(string: "http://localhost:8080")!
    @StateObject var viewModel = GoalsViewModel()
    
    private init() {}
    
    func fetchGoals(for userId: Int, completion: @escaping (Result<[CalendarTask], Error>) -> Void) {
        let url = baseURL.appendingPathComponent("goals")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "user_id", value: "\(userId)")]
        
        guard let finalURL = components?.url else { return }
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                print("Ошибка запроса: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                        guard httpResponse.statusCode == 200 else {
                            print("Ошибка сервера: \(httpResponse.statusCode)")
                            return
                        }
                    }
            
            guard let data = data else {
                print("Нет данных")
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let tasks = try decoder.decode([CalendarTask].self, from: data)
                print("Успешно получены задачи: \(tasks)")
//                self.viewModel.tasks = tasks
                DispatchQueue.main.async {
                    completion(.success(tasks))
                }
            } catch {
                DispatchQueue.main.async {
                    print("Ошибка декодирования: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
            

        }.resume()

    }
    
    func addGoal(task: CalendarTask, completion: @escaping (Result<CalendarTask, Error>) -> Void) {
        let url = baseURL.appendingPathComponent("goals")
        
        // Создание URL запроса
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Кодируем данные задачи в JSON
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let jsonData = try encoder.encode(task)
            request.httpBody = jsonData
        } catch {
            print("Ошибка кодирования данных: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        // Выполняем запрос
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка запроса: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 else {
                    print("Ошибка сервера: \(httpResponse.statusCode)")
                    completion(.failure(NSError(domain: "ServerError", code: httpResponse.statusCode, userInfo: nil)))
                    return
                }
            }
            
            guard let data = data else {
                print("Нет данных")
                completion(.failure(NSError(domain: "DataError", code: 0, userInfo: nil)))
                return
            }
            
            // Декодируем ответ
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            DispatchQueue.main.async {
                do {
                    let newTask = try decoder.decode(CalendarTask.self, from: data)
                    print("Успешно добавлена цель: \(newTask)")
                    completion(.success(newTask))
                } catch {
                    print("Ошибка декодирования: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
            
        }.resume()
    }

    
    func updateGoal(_ task: CalendarTask, completion: @escaping (Result<Void, Error>) -> Void) {
        // Убедитесь, что вы передаете правильный ID задачи для обновления
        let url = baseURL.appendingPathComponent("goals")
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Кодируем объект задачи в JSON
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let body = try encoder.encode(task)
            request.httpBody = body
        } catch {
            print("Ошибка кодирования: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        // Выполняем запрос
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Ошибка запроса: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 else {
                    print("Ошибка сервера: \(httpResponse.statusCode)")
                    completion(.failure(NSError(domain: "ServerError", code: httpResponse.statusCode, userInfo: nil)))
                    return
                }
            }
            
            // Успешное обновление
            DispatchQueue.main.async {
                print("Задача успешно обновлена")
                completion(.success(()))
            }
            
        }.resume()
    }

    
    func deleteGoal(id: UUID, userId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        var components = URLComponents(url: baseURL.appendingPathComponent("goals"), resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "id", value: id.uuidString),
            URLQueryItem(name: "user_id", value: "\(userId)")
        ]
        
        guard let finalURL = components?.url else { return }
        var request = URLRequest(url: finalURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            DispatchQueue.main.async {
                completion(.success(()))
            }
        }.resume()
    }
}
