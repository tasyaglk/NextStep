//
//  DeepSeekAPIManager.swift
//  NextStep
//
//  Created by Тася Галкина on 24.04.2025.
//

import Foundation

class DeepSeekAPIManager {
    static let shared = DeepSeekAPIManager()
    
    private let baseURL = "https://api.deepseek.com/v1/chat/completions"
    private let apiKey = "sk-5f43682799c54539bed59121f9b02615" // Замените на ваш ключ
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private init() {}
    
    func reformulateGoal(_ goal: String) async throws -> String {
        let prompt = """
                Переформулируй следующую цель кратко и четко, сохраняя ее суть: "\(goal)".
                Ответ должен быть не длиннее 10 слов, понятным и конкретным.
                Выведи только переформулированную цель, без дополнительных комментариев и без кавычек.
                """
        
        let response = try await sendRequest(prompt: prompt)
        let trimmedResponse = response.trimmingCharacters(in: .whitespacesAndNewlines)
        // Удаляем начальные и конечные двойные кавычки, если они есть
        return trimmedResponse.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
    }
    
    func validateGoal(_ goal: String) async throws -> Bool {
        let prompt = """
        Оцени следующую цель на моральную и социальную приемлемость: "\(goal)".
        Ответь только "true" или "false".
        Если цель нарушает моральные или социальные нормы (например, связана с насилием, дискриминацией, незаконной деятельностью), верни "false".
        Если цель нейтральна или позитивна (например, связана с обучением, саморазвитием, творчеством), верни "true".
        """
        
        let response = try await sendRequest(prompt: prompt)
        return response.trimmingCharacters(in: .whitespacesAndNewlines) == "true"
    }
    
    func validatePlanFeedback(feedback: String, goal: String) async throws -> Bool {
        let prompt = """
        Проверь, относится ли следующее пожелание к цели: "\(feedback)".
        Цель: "\(goal)".
        Ответь только "true" или "false".
        Если пожелание связано с изменением плана для достижения цели (например, уточнение шагов, добавление деталей, изменение подхода), верни "true".
        Если пожелание не связано с целью (например, отвлеченная тема, не относящаяся к достижению цели), верни "false".
        """
        
        let response = try await sendRequest(prompt: prompt)
        return response.trimmingCharacters(in: .whitespacesAndNewlines) == "true"
    }
    
    func validateScheduleFeedback(feedback: String) async throws -> Bool {
        let prompt = """
        Проверь, относится ли следующее пожелание к расписанию: "\(feedback)".
        Ответь только "true" или "false".
        Если пожелание связано с изменением расписания (например, изменение времени, частоты, порядка задач), верни "true".
        Если пожелание не связано с расписанием (например, отвлеченная тема, не относящаяся к планированию времени), верни "false".
        """
        
        let response = try await sendRequest(prompt: prompt)
        return response.trimmingCharacters(in: .whitespacesAndNewlines) == "true"
    }
    
    func generateSteps(goal: String, knowledge: String, feedback: String? = nil) async throws -> [String] {
        let prompt = createPrompt(goal: goal, knowledge: knowledge, feedback: feedback)
        let response = try await sendRequest(prompt: prompt)
        return parseSteps(from: response)
    }
    
    private func createPrompt(goal: String, knowledge: String, feedback: String?) -> String {
        var prompt = """
        Пользователь хочет: \(goal)
        Уже знает: \(knowledge)
        Сгенерируй четкие шаги для достижения цели. Только пункты списка, без пояснений.
        Формат ответа: каждый пункт с новой строки без номеров
        """
        
        if let feedback = feedback {
            prompt += "\nДополнительные пожелания: \(feedback)"
        }
        
        prompt += "\nСгенерируй четкие шаги для достижения цели с учетом всех пожеланий. Только пункты списка, без пояснений."
        
        return prompt
    }
    
    func generateSchedule(steps: [String], availability: String, frequency: String, feedback: String? = nil) async throws -> String {
        var prompt = """
        Одобренные шаги для выполнения (не добавляй новые шаги, используй только эти):
        \(steps.joined(separator: "\n"))
        
        Доступность пользователя: \(availability)
        Частота занятий: \(frequency)
        
        Создай расписание в формате (это очень важно):
        Задача - ДД-ММ-ГГГГ в ЧЧ:мм
        
        Учитывай:
        - Используй ТОЛЬКО предоставленные шаги, не придумывай новые.
        - Минимальная длительность каждого задания должна быть 1 час.
        - Доступность и частоту, указанные пользователем.
        - Реальные сроки выполнения задач.
        - Перерывы между задачами.
        - Текущая дата: \(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)).
        """
        
        if let feedback = feedback {
            prompt += "\nДополнительные пожелания к расписанию: \(feedback)"
        }
        
        prompt += "\nВыведи только расписание, без дополнительных комментариев."
        
        return try await sendRequest(prompt: prompt)
    }
    
    private func sendRequest(prompt: String) async throws -> String {
        let request = try createRequest(prompt: prompt)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw parseError(response: response, data: data)
        }
        
        return try decodeResponse(data: data)
    }
    
    private func createRequest(prompt: String) throws -> URLRequest {
        guard let url = URL(string: baseURL) else {
            throw NSError(domain: "Invalid URL", code: 1)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "model": "deepseek-chat",
            "messages": [
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7,
            "max_tokens": 1000,
            "top_p": 1.0,
            "frequency_penalty": 0.0,
            "presence_penalty": 0.0
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        return request
    }
    
    private func decodeResponse(data: Data) throws -> String {
        let apiResponse = try jsonDecoder.decode(DeepSeekResponse.self, from: data)
        guard let content = apiResponse.choices.first?.message.content else {
            throw NSError(domain: "Empty response content", code: 3)
        }
        return content
    }
    
    private func parseSteps(from response: String) -> [String] {
        response.components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
    
    private func parseError(response: URLResponse?, data: Data) -> Error {
        do {
            let errorResponse = try jsonDecoder.decode(DeepSeekError.self, from: data)
            return NSError(
                domain: "API Error: \(errorResponse.error.message)",
                code: errorResponse.error.code
            )
        } catch {
            if data.isEmpty {
                return NSError(domain: "Empty error response", code: 4)
            }
            return NSError(domain: "Decoding error: \(error.localizedDescription)", code: 5)
        }
    }
}


