//
//  CalendarManager.swift
//  NextStep
//
//  Created by Тася Галкина on 22.04.2025.
//
//

import EventKit
import Foundation

class CalendarManager {
    static let shared = CalendarManager()
    private let eventStore = EKEventStore()
    
    private init() {}
    
    // Запрашиваем полный доступ к календарю
    func requestCalendarAccess() async throws -> Bool {
        do {
            return try await eventStore.requestFullAccessToEvents()
        } catch {
            throw NSError(domain: "CalendarAccessError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось получить доступ к календарю: \(error.localizedDescription)"])
        }
    }
    
    // Добавляем событие для подзадачи
    func addEvent(for subtask: Subtask) async throws -> String {
        guard try await requestCalendarAccess() else {
            throw NSError(domain: "CalendarAccessError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Нет доступа к календарю"])
        }
        
        let event = EKEvent(eventStore: eventStore)
        event.title = subtask.title
        event.startDate = subtask.deadline
        event.endDate = subtask.deadline.addingTimeInterval(60 * 60) // 1 час
        event.calendar = eventStore.defaultCalendarForNewEvents
        event.notes = "Из цели: \(subtask.goalName) из приложения NextStep"
        
        try eventStore.save(event, span: .thisEvent)
        guard let eventID = event.eventIdentifier else {
            throw NSError(domain: "CalendarError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Не удалось получить ID события"])
        }
        return eventID
    }
    
    // Удаляем события для цели
    func removeEvents(for goal: Goal) async throws {
        guard try await requestCalendarAccess() else {
            throw NSError(domain: "CalendarAccessError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Нет доступа к календарю"])
        }
        
        for subtask in goal.subtasks ?? [] {
            if let eventID = subtask.calendarEventID,
               let event = eventStore.event(withIdentifier: eventID) {
                do {
                    try eventStore.remove(event, span: .thisEvent)
//                    print("✅ Удалено событие: \(String(describing: event.title))")
                } catch {
//                    print("❌ Ошибка удаления события: \(error.localizedDescription)")
                    throw error
                }
            }
        }
    }
    
    // Синхронизируем подзадачи
    func synchronizeSubtasks(goal: Goal) async throws -> Goal {
        try await removeEvents(for: goal)
        
        var updatedSubtasks: [Subtask] = []
        for var subtask in goal.subtasks ?? [] {
            do {
                let eventID = try await addEvent(for: subtask)
                subtask.calendarEventID = eventID
                updatedSubtasks.append(subtask)
            } catch {
//                print("❌ Ошибка добавления события для подзадачи '\(subtask.title)': \(error.localizedDescription)")
                throw error
            }
        }
        
        var updatedGoal = goal
        updatedGoal.subtasks = updatedSubtasks
        return updatedGoal
    }
}
