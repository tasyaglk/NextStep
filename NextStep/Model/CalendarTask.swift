//
//  CalendarTask.swift
//  NextStep
//
//  Created by Тася Галкина on 16.03.2025.
//

import SwiftUI

struct CalendarTask: Codable, Identifiable {
    let id: UUID
    let userId: Int
    var title: String
    var description: String
    var startTime: Date
    var duration: String
    var color: String
    var isPinned: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case title
        case description
        case startTime = "start_time"
        case duration
        case color
        case isPinned = "is_pinned"
    }
}



