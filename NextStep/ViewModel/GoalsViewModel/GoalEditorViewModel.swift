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

    init(goal: Goal? = nil) {
        if let goal = goal {
            self.title = goal.title
            self.startDate = goal.startTime
            self.selectedColor = Color(hex: goal.color) ?? .blue

            if let duration = TimeInterval(goal.duration) {
                self.endDate = goal.startTime.addingTimeInterval(duration)
            } else {
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
            calendarEventID: nil // Используем nil вместо ""
        )
        subtasks.append(subtask)
        errorMessage = nil
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

        let durationString = ISO8601DurationFormatter.string(from: endDate.timeIntervalSince(startDate))
        
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
}

//// Расширение для работы с цветами
//extension Color {
//    init?(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
//        var rgb: UInt64 = 0
//        guard Scanner(string: hex).scanHexInt64(&rgb), hex.count == 6 else { return nil }
//        self.init(
//            red: Double((rgb >> 16) & 0xFF) / 255.0,
//            green: Double((rgb >> 8) & 0xFF) / 255.0,
//            blue: Double(rgb & 0xFF) / 255.0
//        )
//    }
//
//    var toHex: String? {
//        let uiColor = UIColor(self)
//        var red: CGFloat = 0
//        var green: CGFloat = 0
//        var blue: CGFloat = 0
//        var alpha: CGFloat = 0
//        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else { return nil }
//        return String(format: "#%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
//    }
//}
//
//// Расширение для парсинга duration (если нужно для сервера)
//extension TimeInterval {
//    init?(_ duration: String) {
//        let components = duration.components(separatedBy: CharacterSet(charactersIn: "hms"))
//        guard components.count >= 3,
//              let hours = Double(components[0]),
//              let minutes = Double(components[1]),
//              let seconds = Double(components[2]) else { return nil }
//        self = hours * 3600 + minutes * 60 + seconds
//    }
//}
