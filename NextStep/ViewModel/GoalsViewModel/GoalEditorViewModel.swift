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
        let subtask = Subtask(
            id: UUID(),
            title: title,
            deadline: deadline,
            isCompleted: false,
            color: selectedColor.toHex ?? "#000000",
            goalName: goalName
        )
        subtasks.append(subtask)
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
        let durationString = ISO8601DurationFormatter.string(from: endDate.timeIntervalSince(startDate))
        
        
        var createdGoal = Goal(
            id: existingGoal?.id ?? UUID(),
            userId: UserService.userID,
            title: title,
            startTime: startDate,
            duration: durationString,
            color: selectedColor.toHex ?? "#000000",
            isPinned: existingGoal?.isPinned ?? false,
            subtasks: subtasks,
            completedSubtaskCount: 0
        )
        
        for subtask in createdGoal.subtasks ?? [] {
            CalendarManager().addEvent(for: subtask) { result in
                        switch result {
                        case .success:
                            print("Событие добавлено в календарь")
                        case .failure(let error):
                            print("Ошибка добавления в календарь: \(error.localizedDescription)")
                        }
                    }
            }
        
        return createdGoal
    }
}

