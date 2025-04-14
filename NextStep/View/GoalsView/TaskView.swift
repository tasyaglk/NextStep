//
//  TaskView.swift
//  NextStep
//
//  Created by Тася Галкина on 16.03.2025.
//

import SwiftUI

struct TaskView: View {
    let task: Goal
    let isUsualView: Bool
    let isCompleted: Bool
    @EnvironmentObject var viewModel: GoalsViewModel
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(task.title)
                    .font(customFont: .onestSemiBold, size: 16)
                    .foregroundStyle(Color.blackColor)
            }
            
            Spacer()
            
            VStack {
                if isUsualView {
                    if task.isPinned {
                        Image(systemName: "pin.fill")
                            .rotationEffect(.degrees(45))
                            .foregroundColor(.appContainer)
                    }
                } else {
                    Button {
                        Task {
                            var updatedTask = task
                            await viewModel.updateGoal(updatedTask)
                        }
                    } label: {
                        Image("plus.circle.fill")
                            .foregroundColor(.appContainer)
                            .font(.system(size: 32))
                    }
                }
            }
        }
        .padding()
        .background(Color(hex: task.color))
        .cornerRadius(10)
    }
}
