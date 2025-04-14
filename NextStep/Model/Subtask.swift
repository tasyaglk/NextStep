//
//  Subtask.swift
//  NextStep
//
//  Created by Тася Галкина on 03.04.2025.
//

import Foundation

struct Subtask: Identifiable, Codable, Hashable {
    var id: UUID
    var title: String
    var deadline: Date
    var isCompleted: Bool
    
    enum CodingKeys: String, CodingKey {
            case id
            case title
            case deadline
            case isCompleted = "is_completed"
        }
}
