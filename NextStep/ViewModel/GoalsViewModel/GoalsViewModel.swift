//
//  GoalsViewModel.swift
//  NextStep
//
//  Created by Тася Галкина on 16.03.2025.
//

import SwiftUI

class GoalsViewModel: ObservableObject {
    @Published var tasks: [CalendarTask] = CalendarTask.sampleTasks
    
    func addTask(_ task: CalendarTask) {
            tasks.append(task)
        print(tasks)
        }
    
    func deleteTask(_ task: CalendarTask) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
        }
    }
    
    func updateTask(_ updatedTask: CalendarTask) {
            if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
                tasks[index] = updatedTask
            }
        }
}
