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

    func addSubtask(title: String, deadline: Date) {
        let subtask = Subtask(
            id: UUID(),
            title: title,
            deadline: deadline,
            isCompleted: false,
            color: selectedColor.toHex ?? "#000000"
        )
        subtasks.append(subtask)
    }

    func updateSubtaskColors() {
        let hex = selectedColor.toHex ?? "#000000"
        for i in subtasks.indices {
            subtasks[i].color = hex
        }
    }

    func buildGoal(existingGoal: Goal?) -> Goal {
        let durationString = ISO8601DurationFormatter.string(from: endDate.timeIntervalSince(startDate))
        return Goal(
            id: existingGoal?.id ?? UUID(),
            userId: UserService.userID,
            title: title,
            startTime: startDate,
            duration: durationString,
            color: selectedColor.toHex ?? "#000000",
            isPinned: existingGoal?.isPinned ?? false,
            subtasks: subtasks
        )
    }
}

