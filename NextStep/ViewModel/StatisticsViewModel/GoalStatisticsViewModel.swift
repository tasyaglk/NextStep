//
//  GoalStatisticsViewModel.swift
//  NextStep
//
//  Created by Тася Галкина on 19.04.2025.
//

import SwiftUI

@MainActor
class GoalStatisticsViewModel: ObservableObject {
    @Published var goal: Goal
    private let service = GoalService()
    private let userId = UserService.userID

    @Published var subtasks: [Subtask]
    @Published var completedCount: Int
    @Published var progress: Double

    init(goal: Goal) {
        self.goal = goal
        self.subtasks = goal.subtasks ?? []
        self.completedCount = goal.completedSubtaskCount
        self.progress = Double(goal.completedSubtaskCount) / Double(goal.subtasks?.count ?? 1)
    }
    
    func loadSubtasks(for goal: Goal) async {
        do {
            let subtasks = try await service.fetchSubtasksByGoalId(forGoalID: goal.id)
            self.subtasks = subtasks
        } catch {
            print("Ошибка при загрузке подзадач: \(error.localizedDescription)")
        }
    }

    func toggleCompletion(for subtask: Subtask) async {
        do {
            try await service.updateSubtaskCompletion(subtask)
        } catch {
            print("Ошибка обновления подзадачи: \(error)")
        }
        await refreshGoal()
    }

     func refreshGoal() async {
        do {
            let updatedGoals = try await service.fetchGoals(for: userId)
            if let updated = updatedGoals.first(where: { $0.id == goal.id }) {
                self.goal = updated
                self.subtasks = updated.subtasks ?? []
                self.completedCount = goal.completedSubtaskCount
                self.progress = Double(goal.completedSubtaskCount) / Double(goal.subtasks?.count ?? 1)

            }
        } catch {
            print("Ошибка обновления целей: \(error)")
        }
    }
}

