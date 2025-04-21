//
//  Subtask.swift
//  NextStep
//
//  Created by Тася Галкина on 03.04.2025.
//

import Foundation

struct Subtask: Identifiable, Codable, Hashable, Equatable {
    var id: UUID
    var title: String
    var deadline: Date
    var isCompleted: Bool
    var color: String
    var goalName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case deadline
        case isCompleted = "is_completed"
        case color
        case goalName = "goal_name"
    }
}
