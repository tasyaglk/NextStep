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
    @Published var  subtasks: [Subtask] = []
    
    @Published var title: String = ""
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var selectedColor: Color = .blue

    private let service = GoalService()
    private let userId = UserService.userID 

    func loadGoals() async {
        do {
            goals = try await service.fetchGoals(for: userId)
        } catch {
            print("Ошибка загрузки целей: \(error)")
        }
    }
    
    func loadSubtasks() async {
        do {
            subtasks = try await service.fetchAllSubtasks()
            print(subtasks)
        } catch {
            print("Ошибка загрузки подзадач: \(error)")
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
    
    func togglePin(for goal: Goal) async {
        var updatedGoal = goal
        updatedGoal.isPinned.toggle()
        
        do {
            try await service.updateGoal(updatedGoal)
            await loadGoals()
        } catch {
            print("Ошибка при закреплении цели: \(error)")
        }
    }
    
    func toggleSubtaskCompletion(_ subtask: Subtask) async {
        var updatedSubtask = subtask
//        updatedSubtask.isCompleted.toggle()

        do {
            try await service.updateSubtaskCompletion(updatedSubtask)
            await loadSubtasks()
        } catch {
            print("Ошибка обновления подзадачи:", error)

                if let urlError = error as? URLError {
                    print("URLError:", urlError)
                } else if let decodingError = error as? DecodingError {
                    print("Decoding error:", decodingError)
                } else {
                    print("Другая ошибка:", error.localizedDescription)
                }
        }
    }

}
