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
    private var userId = UserService.userID
    
    func loadUserInfo() {
        if let savedData = UserDefaults.standard.data(forKey: "userProfile"),
           let decodedProfile = try? JSONDecoder().decode(UserProfile.self, from: savedData) {
            var userInfo = decodedProfile
            userId = decodedProfile.id
            UserService.userID = decodedProfile.id
        }
    }

    func loadGoals() async {
        do {
            goals = try await service.fetchGoals(for: userId)
            errorMessage = nil
        } catch {
            errorMessage = "Ошибка загрузки целей: \(error.localizedDescription)"
            print(errorMessage)
        }
    }
    
    func loadSubtasks() async {
        do {
            subtasks = try await service.fetchAllSubtasks(for: userId)
            print("Subtasks loaded: \(subtasks)")
            errorMessage = nil
        } catch {
            errorMessage = "Ошибка загрузки подзадач: \(error.localizedDescription)"
            print(errorMessage)
        }
    }

    func addGoal(_ goal: Goal) async {
        print("Adding goal: \(goal)")
        print("Subtasks IDs: \(goal.subtasks?.map { $0.id } ?? [])")
        do {
            let updatedGoal = try await calendarManager.synchronizeSubtasks(goal: goal)
            print("-----\nUpdated goal with calendarEventIDs: \(updatedGoal.subtasks?.map { ($0.id, $0.calendarEventID ?? "nil") } ?? [])")
            try await service.createGoal(goal: updatedGoal)
            await loadGoals()
            successMessage = "Цель и расписание успешно сохранены!"
            errorMessage = nil
            print("-----\nGoal added successfully: \(updatedGoal)")
        } catch {
            let errorDesc = error.localizedDescription
            errorMessage = "Ошибка создания цели: \(errorDesc.contains("subtasks_pkey") ? "Конфликт подзадач, попробуйте снова" : errorDesc)"
            successMessage = nil
            print("Error adding goal: \(error)")
        }
    }

    func updateGoal(_ goal: Goal) async {
        print("Updating goal: \(goal)")
        print("Subtasks IDs: \(goal.subtasks?.map { $0.id } ?? [])")
        do {
            try await service.updateGoal(goal)
            await loadGoals()
            await loadSubtasks()
            successMessage = "Цель успешно обновлена!"
            errorMessage = nil
            print("Goal updated successfully: \(goal)")
        } catch {
            let errorDesc = error.localizedDescription
            errorMessage = "Ошибка обновления цели: \(errorDesc.contains("subtasks_pkey") ? "Конфликт подзадач, попробуйте снова" : errorDesc)"
            successMessage = nil
            print("Error updating goal: \(error)")
        }
    }

    func deleteGoal(_ goal: Goal) async {
        print("Deleting goal: \(goal.id)")
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
        
        print("Toggling pin for goal: \(goal.id), isPinned: \(updatedGoal.isPinned)")
        do {
            try await service.updateGoal(updatedGoal)
            await loadGoals()
            successMessage = updatedGoal.isPinned ? "Цель закреплена!" : "Цель откреплена!"
            errorMessage = nil
            print("Goal pinned successfully: \(updatedGoal.isPinned)")
        } catch {
            errorMessage = "Ошибка при закреплении цели: \(error.localizedDescription)"
            successMessage = nil
            print("Error pinning goal: \(error)")
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
                print("DecodingError: \(decodingError)")
            } else {
                print("Other error: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteSubtask(_ subtask: Subtask) async {
        print("Deleting subtask: \(subtask.id)")
        do {
            try await service.deleteSubtask(id: subtask.id, userId: userId)
            await loadSubtasks()
            successMessage = "Подзадача успешно удалена!"
            errorMessage = nil
            print("Subtask deleted successfully: \(subtask.id)")
        } catch {
            errorMessage = "Ошибка удаления подзадачи: \(error.localizedDescription)"
            successMessage = nil
            print("Error deleting subtask: \(error)")
        }
    }
}
