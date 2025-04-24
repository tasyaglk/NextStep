//
//  ChatViewModel.swift
//  NextStep
//
//  Created by Тася Галкина on 24.04.2025.
//

import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = [
        ChatMessage(content: "Привет! Чего ты хочешь достичь?", isUser: false, isTypingIndicator: false)
    ]
    @Published var newMessage: String = ""
    @Published var state: MentorState = .waitingForGoal
    @Published var showInputField: Bool = true
    @Published var isLoading: Bool = false
    
    private var originalGoal: String = ""
    private var userGoal: String = ""
    private var currentKnowledge: String = ""
    private var currentSteps: [String] = []
    private var availability: String = ""
    private var frequency: String = ""
    private var scheduleRegenerationFeedback: String = ""
    private var regenerationContext: String = ""
    private var lastSchedule: String = ""
    
    private let userId: Int
    private let apiManager = DeepSeekAPIManager.shared
    private let goalService = GoalService()
    private let calendarManager = CalendarManager.shared
    
    init(userId: Int) {
        self.userId = userId
    }
    
    func sendMessage() {
        let userText = newMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !userText.isEmpty else { return }
        newMessage = ""
        
        messages.append(ChatMessage(content: userText, isUser: true, isTypingIndicator: false))
        scrollToBottom()
        
        switch state {
        case .waitingForGoal, .waitingForValidGoal:
            validateGoal(userText)
        case .waitingForCurrentKnowledge:
            processKnowledge(userText)
        case .waitingForRegenerationFeedback, .waitingForValidRegenerationFeedback:
            validateRegenerationFeedback(userText)
        case .waitingForSchedulePreferences:
            processSchedulePreferences(userText)
        case .waitingForScheduleRegenerationFeedback, .waitingForValidScheduleRegenerationFeedback:
            validateScheduleRegenerationFeedback(userText)
        case .showingPlan, .showingSchedule:
            break
        }
    }
    
    func startRegeneration() {
        showInputField = true
        state = .waitingForRegenerationFeedback
        messages.append(ChatMessage(
            content: "Что именно вы хотите изменить в текущем плане?",
            isUser: false,
            isTypingIndicator: false
        ))
        scrollToBottom()
    }
    
    func startSchedulePreferences() {
        showInputField = true
        state = .waitingForSchedulePreferences
        messages.append(ChatMessage(
            content: "Когда вы можете заниматься (например, 'по будням с 18:00 до 20:00') и как часто (например, '3 раза в неделю')?",
            isUser: false,
            isTypingIndicator: false
        ))
        scrollToBottom()
    }
    
    func startScheduleRegeneration() {
        showInputField = true
        state = .waitingForScheduleRegenerationFeedback
        messages.append(ChatMessage(
            content: "Что вы хотите изменить в текущем расписании?",
            isUser: false,
            isTypingIndicator: false
        ))
        scrollToBottom()
    }
    
    func saveAndResetChat() {
        let goal = createGoal()
        Task {
            do {
                print("Saving goal: \(goal)")
                print("Subtasks IDs: \(goal.subtasks?.map { $0.id } ?? [])")
                let updatedGoal = try await calendarManager.synchronizeSubtasks(goal: goal)
                print("Updated goal with calendarEventIDs: \(updatedGoal.subtasks?.map { ($0.id, $0.calendarEventID ?? "nil") } ?? [])")
                try await goalService.createGoal(goal: updatedGoal)
                await MainActor.run {
                    messages.append(ChatMessage(
                        content: "✅ Цель и расписание успешно сохранены в календарь!",
                        isUser: false,
                        isTypingIndicator: false
                    ))
                    resetChat()
                }
            } catch {
                let errorDesc = error.localizedDescription
                let errorMessage = errorDesc.contains("subtasks_pkey") ? "❌ Конфликт подзадач, попробуйте снова" : "❌ Ошибка сохранения: \(errorDesc)"
                await MainActor.run {
                    messages.append(ChatMessage(
                        content: errorMessage,
                        isUser: false,
                        isTypingIndicator: false
                    ))
                    scrollToBottom()
                }
                print("Error saving goal: \(error)")
            }
        }
    }
    
    func resetChat() {
        messages = [
            ChatMessage(content: "Привет! Чего ты хочешь достичь?", isUser: false, isTypingIndicator: false)
        ]
        originalGoal = ""
        userGoal = ""
        currentKnowledge = ""
        currentSteps = []
        availability = ""
        frequency = ""
        scheduleRegenerationFeedback = ""
        regenerationContext = ""
        lastSchedule = ""
        showInputField = true
        isLoading = false
        state = .waitingForGoal
        scrollToBottom()
    }
    
    private func createGoal() -> Goal {
        var subtasks: [Subtask] = []
        var earliestDate: Date = Date()
        var latestDate: Date = Date()
        
        if !lastSchedule.isEmpty {
            let scheduleLines = lastSchedule.components(separatedBy: "\n").filter { !$0.isEmpty }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy 'в' HH:mm"
            dateFormatter.timeZone = TimeZone.current
            
            for (index, line) in scheduleLines.enumerated() {
                let components = line.components(separatedBy: " - ")
                if components.count == 2, index < currentSteps.count {
                    let taskTitle = currentSteps[index]
                    let dateString = components[1]
                    if let date = dateFormatter.date(from: dateString) {
                        let subtask = Subtask(
                            id: UUID(),
                            title: taskTitle,
                            deadline: date,
                            isCompleted: false,
                            color: "#007AFF",
                            goalName: userGoal,
                            calendarEventID: nil
                        )
                        subtasks.append(subtask)
                        if subtasks.count == 1 || date < earliestDate {
                            earliestDate = date
                        }
                        if subtasks.count == 1 || date > latestDate {
                            latestDate = date
                        }
                    }
                }
            }
        }
        
        if subtasks.isEmpty {
            let calendar = Calendar.current
            for (index, step) in currentSteps.enumerated() {
                let deadline = calendar.date(byAdding: .day, value: index + 1, to: Date()) ?? Date()
                let subtask = Subtask(
                    id: UUID(),
                    title: step,
                    deadline: deadline,
                    isCompleted: false,
                    color: "#007AFF",
                    goalName: userGoal,
                    calendarEventID: nil
                )
                subtasks.append(subtask)
                if index == 0 {
                    earliestDate = deadline
                }
                latestDate = deadline
            }
        }
        
        let duration = formatDuration(from: earliestDate, to: latestDate)
        
        return Goal(
            id: UUID(),
            userId: userId,
            title: userGoal.isEmpty ? "Новая цель" : userGoal,
            startTime: earliestDate,
            duration: duration,
            color: "#007AFF",
            isPinned: false,
            subtasks: subtasks,
            completedSubtaskCount: 0
        )
    }
    
    private func formatDuration(from start: Date, to end: Date) -> String {
        let interval = end.timeIntervalSince(start)
        let hours = Int(interval / 3600)
        let minutes = Int((interval.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(interval.truncatingRemainder(dividingBy: 60))
        return "\(hours)h\(minutes)m\(seconds)s"
    }
    
    private func validateGoal(_ goal: String) {
        isLoading = true
        originalGoal = goal
        addTypingIndicator()
        
        Task {
            do {
                let isValid = try await apiManager.validateGoal(goal)
                if isValid {
                    let reformulatedGoal = try await apiManager.reformulateGoal(goal)
                    await MainActor.run {
                        removeTypingIndicator()
                        processGoal(reformulatedGoal)
                    }
                } else {
                    await MainActor.run {
                        removeTypingIndicator()
                        messages.append(ChatMessage(
                            content: "⚠️ Ваша цель не соответствует моральным и социальным нормам. Пожалуйста, укажите приемлемую цель.",
                            isUser: false,
                            isTypingIndicator: false
                        ))
                        state = .waitingForValidGoal
                        isLoading = false
                        scrollToBottom()
                    }
                }
            } catch {
                await MainActor.run {
                    removeTypingIndicator()
                    messages.append(ChatMessage(
                        content: "⚠️ Ошибка проверки цели: \(error.localizedDescription)",
                        isUser: false,
                        isTypingIndicator: false
                    ))
                    state = .waitingForValidGoal
                    isLoading = false
                    scrollToBottom()
                }
            }
        }
    }
    
    private func processGoal(_ reformulatedGoal: String) {
        userGoal = reformulatedGoal
        
        messages.append(ChatMessage(
            content: "Отлично! Ваша цель: '\(reformulatedGoal)'. Что вы уже знаете по этой теме?",
            isUser: false,
            isTypingIndicator: false
        ))
        
        state = .waitingForCurrentKnowledge
        isLoading = false
        scrollToBottom()
    }
    
    private func processKnowledge(_ text: String) {
        currentKnowledge = text
        isLoading = true
        addTypingIndicator()
        
        Task {
            do {
                let steps = try await apiManager.generateSteps(
                    goal: userGoal,
                    knowledge: currentKnowledge
                )
                
                await MainActor.run {
                    removeTypingIndicator()
                    currentSteps = steps
                    messages.append(ChatMessage(
                        content: "🎯 Вот ваш план:\n• " + steps.joined(separator: "\n• "),
                        isUser: false,
                        isTypingIndicator: false
                    ))
                    showInputField = false
                    isLoading = false
                    state = .showingPlan(steps: steps)
                    scrollToBottom()
                }
            } catch {
                await MainActor.run {
                    removeTypingIndicator()
                    messages.append(ChatMessage(
                        content: "⚠️ Ошибка генерации плана: \(error.localizedDescription)",
                        isUser: false,
                        isTypingIndicator: false
                    ))
                    isLoading = false
                    scrollToBottom()
                }
            }
        }
    }
    
    private func validateRegenerationFeedback(_ feedback: String) {
        isLoading = true
        addTypingIndicator()
        
        Task {
            do {
                let isValid = try await apiManager.validatePlanFeedback(feedback: feedback, goal: userGoal)
                await MainActor.run {
                    removeTypingIndicator()
                    if isValid {
                        processRegenerationFeedback(feedback)
                    } else {
                        messages.append(ChatMessage(
                            content: "⚠️ Ваши пожелания не относятся к цели. Пожалуйста, укажите изменения, связанные с вашей целью.",
                            isUser: false,
                            isTypingIndicator: false
                        ))
                        state = .waitingForValidRegenerationFeedback
                        isLoading = false
                        scrollToBottom()
                    }
                }
            } catch {
                await MainActor.run {
                    removeTypingIndicator()
                    messages.append(ChatMessage(
                        content: "⚠️ Ошибка проверки пожеланий: \(error.localizedDescription)",
                        isUser: false,
                        isTypingIndicator: false
                    ))
                    state = .waitingForValidRegenerationFeedback
                    isLoading = false
                    scrollToBottom()
                }
            }
        }
    }
    
    private func processRegenerationFeedback(_ feedback: String) {
        isLoading = true
        regenerationContext = feedback
        addTypingIndicator()
        
        Task {
            do {
                let updatedSteps = try await apiManager.generateSteps(
                    goal: userGoal,
                    knowledge: currentKnowledge,
                    feedback: feedback
                )
                
                await MainActor.run {
                    removeTypingIndicator()
                    currentSteps = updatedSteps
                    messages.append(ChatMessage(
                        content: "🔄 Обновленный план:\n• " + updatedSteps.joined(separator: "\n• "),
                        isUser: false,
                        isTypingIndicator: false
                    ))
                    showInputField = false
                    isLoading = false
                    state = .showingPlan(steps: updatedSteps)
                    scrollToBottom()
                }
            } catch {
                await MainActor.run {
                    removeTypingIndicator()
                    messages.append(ChatMessage(
                        content: "⚠️ Ошибка обновления плана: \(error.localizedDescription)",
                        isUser: false,
                        isTypingIndicator: false
                    ))
                    isLoading = false
                    showInputField = true
                    state = .waitingForValidRegenerationFeedback
                    scrollToBottom()
                }
            }
        }
    }
    
    private func processSchedulePreferences(_ text: String) {
        let components = text.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        availability = components.first ?? ""
        frequency = components.count > 1 ? components[1] : ""
        
        guard !availability.isEmpty else {
            messages.append(ChatMessage(
                content: "⚠️ Пожалуйста, укажите, когда вы можете заниматься.",
                isUser: false,
                isTypingIndicator: false
            ))
            scrollToBottom()
            return
        }
        
        generateSchedule()
    }
    
    private func validateScheduleRegenerationFeedback(_ feedback: String) {
        isLoading = true
        addTypingIndicator()
        
        Task {
            do {
                let isValid = try await apiManager.validateScheduleFeedback(feedback: feedback)
                await MainActor.run {
                    removeTypingIndicator()
                    if isValid {
                        processScheduleRegenerationFeedback(feedback)
                    } else {
                        messages.append(ChatMessage(
                            content: "⚠️ Ваши пожелания не относятся к расписанию. Пожалуйста, укажите изменения, связанные с расписанием (например, время, частота).",
                            isUser: false,
                            isTypingIndicator: false
                        ))
                        state = .waitingForValidScheduleRegenerationFeedback
                        isLoading = false
                        scrollToBottom()
                    }
                }
            } catch {
                await MainActor.run {
                    removeTypingIndicator()
                    messages.append(ChatMessage(
                        content: "⚠️ Ошибка проверки пожеланий: \(error.localizedDescription)",
                        isUser: false,
                        isTypingIndicator: false
                    ))
                    state = .waitingForValidScheduleRegenerationFeedback
                    isLoading = false
                    scrollToBottom()
                }
            }
        }
    }
    
    private func processScheduleRegenerationFeedback(_ feedback: String) {
        isLoading = true
        scheduleRegenerationFeedback = feedback
        addTypingIndicator()
        
        Task {
            do {
                // Получаем занятые слоты за следующий месяц
                let startDate = Date()
                let endDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate)!
                let busySlots = try await calendarManager.fetchEvents(from: startDate, to: endDate)
                
                let schedule = try await apiManager.generateSchedule(
                    steps: currentSteps,
                    availability: availability,
                    frequency: frequency,
                    feedback: scheduleRegenerationFeedback,
                    busySlots: busySlots
                )
                
                await MainActor.run {
                    removeTypingIndicator()
                    lastSchedule = schedule
                    messages.append(ChatMessage(
                        content: "📅 Обновленное расписание:\n\(schedule)",
                        isUser: false,
                        isTypingIndicator: false
                    ))
                    showInputField = false
                    isLoading = false
                    state = .showingSchedule(steps: currentSteps)
                    scrollToBottom()
                }
            } catch {
                await MainActor.run {
                    removeTypingIndicator()
                    messages.append(ChatMessage(
                        content: "❌ Ошибка: \(error.localizedDescription)",
                        isUser: false,
                        isTypingIndicator: false
                    ))
                    isLoading = false
                    showInputField = false
                    state = .showingSchedule(steps: currentSteps)
                    scrollToBottom()
                }
                print("Error generating schedule: \(error)")
            }
        }
    }
    
    private func generateSchedule() {
        guard !currentSteps.isEmpty else {
            messages.append(ChatMessage(
                content: "⚠️ Нет шагов для создания расписания.",
                isUser: false,
                isTypingIndicator: false
            ))
            scrollToBottom()
            return
        }
        
        isLoading = true
        messages.append(ChatMessage(
            content: "⌛️ Формирую расписание...",
            isUser: false,
            isTypingIndicator: false
        ))
        scrollToBottom()
        
        Task {
            do {
                // Получаем занятые слоты за следующий месяц
                let startDate = Date()
                let endDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate)!
                let busySlots = try await calendarManager.fetchEvents(from: startDate, to: endDate)
                
                let schedule = try await apiManager.generateSchedule(
                    steps: currentSteps,
                    availability: availability,
                    frequency: frequency,
                    feedback: scheduleRegenerationFeedback,
                    busySlots: busySlots
                )
                
                await MainActor.run {
                    removeTypingIndicator()
                    lastSchedule = schedule
                    messages.append(ChatMessage(
                        content: "📅 Ваше расписание:\n\(schedule)",
                        isUser: false,
                        isTypingIndicator: false
                    ))
                    showInputField = false
                    isLoading = false
                    state = .showingSchedule(steps: currentSteps)
                    scrollToBottom()
                }
            } catch {
                await MainActor.run {
                    removeTypingIndicator()
                    messages.append(ChatMessage(
                        content: "❌ Ошибка: \(error.localizedDescription)",
                        isUser: false,
                        isTypingIndicator: false
                    ))
                    isLoading = false
                    showInputField = false
                    state = .showingSchedule(steps: currentSteps)
                    scrollToBottom()
                }
                print("Error generating schedule: \(error)")
            }
        }
    }
    
    private func addTypingIndicator() {
        messages.removeAll { $0.isTypingIndicator }
        messages.append(ChatMessage(
            content: "Печатает...",
            isUser: false,
            isTypingIndicator: true
        ))
        scrollToBottom()
    }
    
    private func removeTypingIndicator() {
        messages.removeAll { $0.isTypingIndicator }
    }
    
    private func scrollToBottom() {
        // Triggers onChange in ChatView
    }
}
