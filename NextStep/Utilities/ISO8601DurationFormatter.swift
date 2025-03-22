//
//  ISO8601DurationFormatter.swift
//  NextStep
//
//  Created by Тася Галкина on 22.03.2025.
//

import Foundation

struct ISO8601DurationFormatter {
    static func string(from timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        return "PT\(hours)H\(minutes)M\(seconds)S" // Пример: "PT2H30M0S"
    }
}

