//
//  ChatMessage.swift
//  NextStep
//
//  Created by Тася Галкина on 24.04.2025.
//

import Foundation

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let isTypingIndicator: Bool
}

enum MentorState {
    case waitingForGoal
    case waitingForValidGoal
    case waitingForCurrentKnowledge
    case showingPlan(steps: [String])
    case waitingForRegenerationFeedback
    case waitingForValidRegenerationFeedback
    case waitingForSchedulePreferences
    case waitingForScheduleRegenerationFeedback
    case waitingForValidScheduleRegenerationFeedback
    case showingSchedule(steps: [String])
}
