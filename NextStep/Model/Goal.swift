//
//  Goal.swift
//  NextStep
//
//  Created by Тася Галкина on 16.03.2025.
//

import SwiftUI

struct Goal: Identifiable, Codable, Hashable {
    var id: UUID
    var userId: Int
    var title: String
    var startTime: Date
    var duration: String
    var color: String
    var isPinned: Bool
    var subtasks: [Subtask]?
    
    enum CodingKeys: String, CodingKey {
            case id
            case userId = "user_id"
            case title
            case startTime = "start_time"
            case duration
            case color
            case isPinned = "is_pinned"
            case subtasks
        }
}



