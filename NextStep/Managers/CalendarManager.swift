//
//  CalendarManager.swift
//  NextStep
//
//  Created by Тася Галкина on 22.04.2025.
//

import Foundation
import EventKit

//
//  CalendarManager.swift
//  NextStep
//
//  Created by Тася Галкина on 22.04.2025.
//

import EventKit
import UIKit

class CalendarManager {
    private let eventStore = EKEventStore()
    
    func addEvent(for subtask: Subtask, completion: @escaping (Result<String, Error>) -> Void) {
//        requestAccessIfNeeded { granted, error in
//            guard granted, error == nil else {
//                completion(.failure(error ?? NSError(domain: "CalendarAccess", code: 1)))
//                return
//            }
        eventStore.requestWriteOnlyAccessToEvents() { (granted, error) in
            if granted && error == nil {
                let event = EKEvent(eventStore: self.eventStore)
                event.title = subtask.title
                event.startDate = subtask.deadline
                event.endDate = subtask.deadline.addingTimeInterval(60 * 60) // default 1 hour
                event.calendar = self.eventStore.defaultCalendarForNewEvents
                event.notes = "Из цели: \(subtask.goalName) из приложения NextStep"
                
                do {
                            try self.eventStore.save(event, span: .thisEvent)
                            if let id = event.eventIdentifier {
                                completion(.success(id)) // ✅ возвращаем ID
                            } else {
                                completion(.failure("hui" as! Error))
                            }
                        } catch {
                            completion(.failure(error))
                        }
            }
        }
    }
    
//    func removeEvents(for goal: Goal) {
//            for subtask in goal.subtasks ?? [] {
//                if let eventID = subtask.calendarEventID,
//                   let event = eventStore.event(withIdentifier: eventID) {
//                    do {
//                        try eventStore.remove(event, span: .thisEvent)
//                        print("✅ Удалено событие: \(String(describing: event.title))")
//                    } catch {
//                        print("❌ Ошибка удаления события:", error)
//                    }
//                }
//            }
//        }
//    
//    func synchronizeSubtasks(goal: Goal, completion: @escaping (Goal) -> Void) {
//        removeEvents(for: goal)
//        
//        let dispatchGroup = DispatchGroup()
//        var updatedSubtasks: [Subtask] = []
//        
//        for var subtask in goal.subtasks ?? [] {
//            dispatchGroup.enter()
//            addEvent(for: subtask) { result in
//                switch result {
//                case .success(let eventID):
//                    subtask.calendarEventID = eventID
//                case .failure(let error):
//                    print("Ошибка при добавлении события:", error.localizedDescription)
//                }
//                updatedSubtasks.append(subtask)
//                dispatchGroup.leave()
//            }
//        }
//        
//        dispatchGroup.notify(queue: .main) {
//            var updatedGoal = goal
//            updatedGoal.subtasks = updatedSubtasks
//            completion(updatedGoal)
//        }
//    }


    
//    private func requestAccessIfNeeded(completion: @escaping (Bool, Error?) -> Void) {
//        let status = EKEventStore.authorizationStatus(for: .event)
//        switch status {
//        case .notDetermined:
//            eventStore.requestAccess(to: .event) { granted, error in
//                DispatchQueue.main.async {
//                    completion(granted, error)
//                }
//            }
//        case .authorized:
//            completion(true, nil)
//        default:
//            completion(false, nil)
//        }
//    }
}
