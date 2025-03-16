//
//  CalendarTask.swift
//  NextStep
//
//  Created by Тася Галкина on 16.03.2025.
//

import SwiftUI

struct CalendarTask: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let startTime: Date
    let duration: TimeInterval
    let color: Color
    
    init(
            id: UUID = UUID(),
            title: String,
            description: String,
            startTime: Date,
            duration: TimeInterval,
            color: Color
        ) {
//            self.id = id
            self.title = title
            self.description = description
            self.startTime = startTime
            self.duration = duration
            self.color = color
        }
}

extension CalendarTask {
    static let sampleTasks: [CalendarTask] = {
        let calendar = Calendar.current
        let now = Date()
        
        func time(hour: Int, minute: Int = 0) -> Date {
            calendar.date(bySettingHour: hour, minute: minute, second: 0, of: now) ?? now
        }
        
        return [
            CalendarTask(
                title: "Team Stand-up Meeting",
                description: "Review progress and plan tasks for the week",
                startTime: time(hour: 9, minute: 30),
                duration: 3600,
                color: .appPurple
            ),
            CalendarTask(
                title: "Client Call",
                description: "Discuss project updates and next steps with the client",
                startTime: time(hour: 11),
                duration: 1800,
                color: .appGreen
            ),
            CalendarTask(
                title: "Gym Workout",
                description: "Go for a 1 hour workout session",
                startTime: time(hour: 13),
                duration: 3600,
                color: .appPink
            ),
            CalendarTask(
                title: "Vet Appointment",
                description: "Take the dog to the vet for a check-up",
                startTime: time(hour: 15, minute: 30),
                duration: 1800,
                color: .appOrange
            ),
            CalendarTask(
                title: "Design Review",
                description: "Go over the latest UI updates",
                startTime: time(hour: 17),
                duration: 3600,
                color: .appBlue
            )
        ]
    }()
}
