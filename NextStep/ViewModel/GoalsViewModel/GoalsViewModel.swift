//
//  GoalsViewModel.swift
//  NextStep
//
//  Created by Тася Галкина on 16.03.2025.
//

import SwiftUI
import Combine

class GoalsViewModel: ObservableObject {
    @Published var tasks: [CalendarTask] = []
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    
    func loadTasks(for userId: Int) {
        GoalsAPI.shared.fetchGoals(for: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tasks):
                    self?.tasks = tasks
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    
    func addTask(_ task: CalendarTask) {
        GoalsAPI.shared.addGoal(task: task) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.tasks.append(task)
                    self?.loadTasks(for: UserService.userID)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func updateTask(_ task: CalendarTask) {
        GoalsAPI.shared.updateGoal(task) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let index = self?.tasks.firstIndex(where: { $0.id == task.id }) {
                        self?.tasks[index] = task
                        self?.loadTasks(for: UserService.userID)
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func deleteTask(_ task: CalendarTask) {
        GoalsAPI.shared.deleteGoal(id: task.id, userId: task.userId) { [weak self] result in
            switch result {
            case .success:
                self?.tasks.removeAll { $0.id == task.id }
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
}
