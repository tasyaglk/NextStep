//
//  ISO8601DurationFormatter.swift
//  NextStep
//
//  Created by Тася Галкина on 22.03.2025.
//

import Foundation

class ISO8601DurationFormatter {
    static func string(from timeInterval: TimeInterval) -> String {
        let totalSeconds = Int(timeInterval)
            let hours = totalSeconds / 3600
            let minutes = (totalSeconds % 3600) / 60
            let seconds = totalSeconds % 60

            return "\(hours)h\(minutes)m\(seconds)s"
    }
    
    static func timeInterval(from string: String) -> TimeInterval? {
        let scanner = Scanner(string: string)
        var total: TimeInterval = 0
        
        scanner.charactersToBeSkipped = CharacterSet.uppercaseLetters.union(.lowercaseLetters)
        
        while !scanner.isAtEnd {
            var value: Double = 0
            if scanner.scanDouble(&value) {
                if scanner.scanString("H") != nil {
                    total += value * 3600
                } else if scanner.scanString("M") != nil {
                    total += value * 60
                } else if scanner.scanString("S") != nil {
                    total += value
                }
            }
        }
        return total
    }
}
