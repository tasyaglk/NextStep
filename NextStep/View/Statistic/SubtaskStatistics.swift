//
//  SubtaskStatistics.swift
//  NextStep
//
//  Created by Тася Галкина on 21.04.2025.
//

import SwiftUI

struct SubtaskStatistics: View {
    var subtask: Subtask
    
    let onToggleCompletion: (Subtask) async -> Void
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()
    
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 16) {
                VStack {
                    Button {
                        Task {
                            await onToggleCompletion(subtask)
                        }
                    } label: {
                        Image(systemName: subtask.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(.white)
                            .font(.system(size: 32))
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(subtask.title)
                        .font(customFont: .onestSemiBold, size: 20)
                        .foregroundStyle(Color.white)
                    
                    Text(subtask.goalName)
                        .font(customFont: .onestRegular, size: 16)
                        .foregroundStyle(Color.white)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(Self.dateFormatter.string(from: subtask.deadline))
                        .font(customFont: .onestSemiBold, size: 20)
                        .foregroundStyle(Color.white)
                    
                    Text(Self.timeFormatter.string(from: subtask.deadline))
                        .font(customFont: .onestSemiBold, size: 20)
                        .foregroundStyle(Color.white)
                }
            }
        }
        .padding()
        .background(Color(hex: subtask.color))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 2)
    }
}
