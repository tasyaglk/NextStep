//
//  GoalsViewModel.swift
//  NextStep
//
//  Created by Тася Галкина on 16.03.2025.
//

import SwiftUI
import Combine

@MainActor
class GoalsViewModel: ObservableObject {
    @Published var goals: [Goal] = []

    private let service = GoalService()
    private let userId = UserService.userID 

    func loadGoals() async {
        do {
            goals = try await service.fetchGoals(for: userId)
        } catch {
            print("Ошибка загрузки целей: \(error)")
        }
    }

    func addGoal(_ goal: Goal) async {
        do {
            try await service.createGoal(goal: goal)
            await loadGoals()
        } catch {
            print("Ошибка создания цели: \(error)")
        }
    }

    func updateGoal(_ goal: Goal) async {
        do {
            try await service.updateGoal(goal)
            await loadGoals()
        } catch {
            print("Ошибка обновления цели: \(error)")
        }
    }

    func deleteGoal(_ goal: Goal) async {
        do {
            try await service.deleteGoal(id: goal.id, userId: userId)
            await loadGoals()
        } catch {
            print("Ошибка удаления цели: \(error)")
        }
    }
}
