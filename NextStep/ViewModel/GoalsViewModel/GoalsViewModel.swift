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
    @Published var subtasks: [Subtask] = []
    
    @Published var title: String = ""
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var selectedColor: Color = .blue
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    private let service = GoalService()
    private let calendarManager = CalendarManager.shared
    private let userId = UserService.userID

    func loadGoals() async {
        do {
            goals = try await service.fetchGoals(for: userId)
            errorMessage = nil
        } catch {
            errorMessage = "Ошибка загрузки целей: \(error.localizedDescription)"
//            print(errorMessage)
        }
    }
    
    func loadSubtasks() async {
        do {
            subtasks = try await service.fetchAllSubtasks(for: userId)
            errorMessage = nil
        } catch {
            errorMessage = "Ошибка загрузки подзадач: \(error.localizedDescription)"
        }
    }

    func addGoal(_ goal: Goal) async {
        do {
            let updatedGoal = try await calendarManager.synchronizeSubtasks(goal: goal)
            try await service.createGoal(goal: updatedGoal)
            await loadGoals()
            successMessage = "Цель и расписание успешно сохранены!"
            errorMessage = nil
        } catch {
            let errorDesc = error.localizedDescription
            errorMessage = "Ошибка создания цели: \(errorDesc.contains("subtasks_pkey") ? "Конфликт подзадач, попробуйте снова" : errorDesc)"
            successMessage = nil
        }
    }

    func updateGoal(_ goal: Goal) async {
//        print("Updating goal: \(goal)")
//        print("Subtasks IDs: \(goal.subtasks?.map { $0.id } ?? [])")
        do {
            let updatedGoal = try await calendarManager.synchronizeSubtasks(goal: goal)
//            print("Updated goal with calendarEventIDs: \(updatedGoal.subtasks?.map { ($0.id, $0.calendarEventID ?? "nil") } ?? [])")
            try await service.updateGoal(updatedGoal)
            await loadGoals()
            successMessage = "Цель успешно обновлена!"
            errorMessage = nil
//            print("Goal updated successfully: \(updatedGoal)")
        } catch {
            let errorDesc = error.localizedDescription
            errorMessage = "Ошибка обновления цели: \(errorDesc.contains("subtasks_pkey") ? "Конфликт подзадач, попробуйте снова" : errorDesc)"
            successMessage = nil
//            print("Error updating goal: \(error)")
        }
    }

    func deleteGoal(_ goal: Goal) async {
//        print("Deleting goal: \(goal.id)")
        do {
            try await calendarManager.removeEvents(for: goal)
            try await service.deleteGoal(id: goal.id, userId: userId)
            await loadGoals()
            await loadSubtasks()
            successMessage = "Цель успешно удалена!"
            errorMessage = nil
            print("Goal deleted successfully: \(goal.id)")
        } catch {
            errorMessage = "Ошибка удаления цели: \(error.localizedDescription)"
            successMessage = nil
            print("Error deleting goal: \(error)")
        }
    }
    
    func togglePin(for goal: Goal) async {
        var updatedGoal = goal
        updatedGoal.isPinned.toggle()
        
//        print("Toggling pin for goal: \(goal.id), isPinned: \(updatedGoal.isPinned)")
        do {
            try await service.updateGoal(updatedGoal)
            await loadGoals()
            successMessage = updatedGoal.isPinned ? "Цель закреплена!" : "Цель откреплена!"
            errorMessage = nil
//            print("Goal pinned successfully: \(updatedGoal.isPinned)")
        } catch {
            errorMessage = "Ошибка при закреплении цели: \(error.localizedDescription)"
            successMessage = nil
//            print("Error pinning goal: \(error)")
        }
    }
    
    func toggleSubtaskCompletion(_ subtask: Subtask) async {
        var updatedSubtask = subtask
//        updatedSubtask.isCompleted.toggle()

        print("Toggling completion for subtask: \(subtask.id), isCompleted: \(updatedSubtask.isCompleted)")
        do {
            try await service.updateSubtaskCompletion(updatedSubtask)
            await loadSubtasks()
            successMessage = "Подзадача обновлена!"
            errorMessage = nil
            print("Subtask updated successfully: \(updatedSubtask)")
        } catch {
            errorMessage = "Ошибка обновления подзадачи: \(error.localizedDescription)"
            successMessage = nil
            print("Error updating subtask: \(error)")
            if let urlError = error as? URLError {
                print("URLError: \(urlError)")
            } else if let decodingError = error as? DecodingError {
                print("Decoding error: \(decodingError)")
            } else {
                print("Other error: \(error.localizedDescription)")
            }
        }
    }
}
