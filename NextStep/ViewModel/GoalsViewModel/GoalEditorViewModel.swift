//
//  GoalEditorViewModel.swift
//  NextStep
//
//  Created by Тася Галкина on 15.04.2025.
//

import SwiftUI

class GoalEditorViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var selectedColor: Color = .blue
    @Published var subtasks: [Subtask] = []
    @Published var errorMessage: String?
    private var deletedSubtaskEventIDs: [String] = []
    private let calendarManager = CalendarManager.shared

    init(goal: Goal? = nil) {
        if let goal = goal {
            self.title = goal.title
            self.startDate = goal.startTime
            self.selectedColor = Color(hex: goal.color) ?? .blue

            // Парсим duration из строки (ISO 8601 или HH:MM:SS)
            if let duration = parseDuration(goal.duration) {
                self.endDate = goal.startTime.addingTimeInterval(duration)
                print("✅ Parsed duration: \(goal.duration) -> \(duration) seconds, endDate: \(self.endDate)")
            } else {
                print("⚠️ Не удалось распарсить duration: \(goal.duration), устанавливаем endDate = startTime")
                self.endDate = goal.startTime
            }

            self.subtasks = goal.subtasks ?? []
        }
    }

    func addSubtask(title: String, deadline: Date, goalName: String) {
        guard !title.isEmpty else {
            errorMessage = "Название подзадачи не может быть пустым"
            return
        }
        guard deadline >= startDate && deadline <= endDate else {
            errorMessage = "Дата подзадачи должна быть в пределах цели"
            return
        }

        let subtask = Subtask(
            id: UUID(),
            title: title,
            deadline: deadline,
            isCompleted: false,
            color: selectedColor.toHex ?? "#000000",
            goalName: goalName,
            calendarEventID: nil
        )
        subtasks.append(subtask)
        errorMessage = nil
    }

    func removeSubtask(atOffsets indices: IndexSet) async {
        let subtasksToDelete = indices.map { subtasks[$0] }
        for subtask in subtasksToDelete {
            if let eventID = subtask.calendarEventID, !eventID.isEmpty {
                deletedSubtaskEventIDs.append(eventID)
                do {
                    try await calendarManager.removeEvent(for: subtask)
                    print("✅ Удалено событие для подзадачи: \(subtask.title), eventID: \(eventID)")
                } catch {
                    errorMessage = "Ошибка удаления события подзадачи: \(error.localizedDescription)"
                    print("⚠️ Не удалось удалить событие для подзадачи \(subtask.title): \(error)")
                }
            }
        }
        subtasks.remove(atOffsets: indices)
    }

    func updateSubtask() {
        let hex = selectedColor.toHex ?? "#000000"
        let goalName = title
        for i in subtasks.indices {
            subtasks[i].color = hex
            subtasks[i].goalName = goalName
        }
    }

    func buildGoal(existingGoal: Goal?) -> Goal {
        guard !title.isEmpty else {
            errorMessage = "Название цели не может быть пустым"
            return Goal(id: UUID(), userId: UserService.userID, title: "", startTime: startDate, duration: "", color: "#000000", isPinned: false, subtasks: [], completedSubtaskCount: 0)
        }
        guard endDate >= startDate else {
            errorMessage = "Дата окончания не может быть раньше начала"
            return Goal(id: UUID(), userId: UserService.userID, title: "", startTime: startDate, duration: "", color: "#000000", isPinned: false, subtasks: [], completedSubtaskCount: 0)
        }

        // Формируем duration в формате HH:MM:SS для совместимости с сервером
        let timeInterval = endDate.timeIntervalSince(startDate)
        let durationString = formatDurationToHHMMSS(timeInterval)
        print("✅ Built goal with duration: \(durationString) (\(timeInterval) seconds)")
        
        let createdGoal = Goal(
            id: existingGoal?.id ?? UUID(),
            userId: UserService.userID,
            title: title,
            startTime: startDate,
            duration: durationString,
            color: selectedColor.toHex ?? "#000000",
            isPinned: existingGoal?.isPinned ?? false,
            subtasks: subtasks,
            completedSubtaskCount: subtasks.filter { $0.isCompleted }.count
        )
        
        errorMessage = nil
        return createdGoal
    }

    func cleanupDeletedSubtaskEvents() async throws {
        for eventID in deletedSubtaskEventIDs {
            let subtask = Subtask(
                id: UUID(),
                title: "Deleted",
                deadline: Date(),
                isCompleted: false,
                color: "#000000",
                goalName: "",
                calendarEventID: eventID
            )
            try await calendarManager.removeEvent(for: subtask)
            print("✅ Очищено событие для удалённой подзадачи, eventID: \(eventID)")
        }
        deletedSubtaskEventIDs.removeAll()
    }

    // Парсер для duration (поддерживает ISO 8601 и HH:MM:SS)
    private func parseDuration(_ duration: String) -> TimeInterval? {
        // Проверка на пустую строку
        guard !duration.isEmpty else {
            print("⚠️ Пустой duration")
            return nil
        }

        // 1. Формат HH:MM:SS
        let hhmmssRegex = try! NSRegularExpression(pattern: "^(\\d+):(\\d{2}):(\\d{2})$")
        if let match = hhmmssRegex.firstMatch(in: duration, options: [], range: NSRange(duration.startIndex..., in: duration)) {
            if let hoursRange = Range(match.range(at: 1), in: duration),
               let minutesRange = Range(match.range(at: 2), in: duration),
               let secondsRange = Range(match.range(at: 3), in: duration),
               let hours = Double(duration[hoursRange]),
               let minutes = Double(duration[minutesRange]),
               let seconds = Double(duration[secondsRange]) {
                let totalSeconds = hours * 3600 + minutes * 60 + seconds
                if totalSeconds > 0 {
                    return totalSeconds
                }
                print("⚠️ Нулевая длительность: \(duration)")
                return nil
            }
        }

        // 2. Формат ISO 8601 (PTxHyMzS)
        if duration.starts(with: "PT") {
            let isoRegex = try! NSRegularExpression(pattern: "PT(?:(\\d+)H)?(?:(\\d+)M)?(?:(\\d+)S)?")
            if let match = isoRegex.firstMatch(in: duration, options: [], range: NSRange(duration.startIndex..., in: duration)) {
                var seconds: Double = 0
                if let hoursRange = Range(match.range(at: 1), in: duration), let hours = Double(duration[hoursRange]) {
                    seconds += hours * 3600
                }
                if let minutesRange = Range(match.range(at: 2), in: duration), let minutes = Double(duration[minutesRange]) {
                    seconds += minutes * 60
                }
                if let secondsRange = Range(match.range(at: 3), in: duration), let sec = Double(duration[secondsRange]) {
                    seconds += sec
                }
                if seconds > 0 {
                    return seconds
                }
                print("⚠️ Нулевая длительность ISO 8601: \(duration)")
                return nil
            }
        }

        print("⚠️ Неверный формат duration: \(duration)")
        return nil
    }

    // Форматирование TimeInterval в HH:MM:SS
    private func formatDurationToHHMMSS(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%d:%02d:%02d", hours, minutes, seconds)
    }
}
