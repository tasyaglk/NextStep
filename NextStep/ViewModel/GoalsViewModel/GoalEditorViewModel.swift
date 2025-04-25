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
    private var deletedSubtaskEventIDs: [String] = [] // Храним calendarEventID удалённых подзадач
    private let calendarManager = CalendarManager.shared

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
            calendarEventID: nil
        )
        subtasks.append(subtask)
        errorMessage = nil
    }

    func removeSubtask(atOffsets indices: IndexSet) async {
        // Собираем calendarEventID удаляемых подзадач
        let subtasksToDelete = indices.map { subtasks[$0] }
        for subtask in subtasksToDelete {
            if let eventID = subtask.calendarEventID, !eventID.isEmpty {
                deletedSubtaskEventIDs.append(eventID)
                do {
                    try await calendarManager.removeEvent(for: subtask)
                } catch {
                    errorMessage = "Ошибка удаления события подзадачи: \(error.localizedDescription)"
                    print("⚠️ Failed to remove event for subtask \(subtask.title): \(error)")
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

    func cleanupDeletedSubtaskEvents() async throws {
        // Удаляем события для подзадач, которые были удалены ранее
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
        }
        deletedSubtaskEventIDs.removeAll()
    }
}

