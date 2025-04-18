//
//  SubtaskView.swift
//  NextStep
//
//  Created by Тася Галкина on 15.04.2025.
//

import SwiftUI

struct SubtaskView: View {
    let subtask: Subtask
    @EnvironmentObject var viewModel: GoalsViewModel
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(subtask.title)
                    .font(customFont: .onestSemiBold, size: 16)
                    .foregroundStyle(Color.blackColor)
                
                Text(subtask.goalName)
                    .font(customFont: .onestRegular, size: 16)
                    .foregroundStyle(Color.grayColor)
            }
            
            Spacer()
            
            VStack {
                Button {
                    Task {
                        await viewModel.toggleSubtaskCompletion(subtask)
                    }
                } label: {
                    Image(systemName: subtask.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(.appContainer)
                        .font(.system(size: 32))
                }
            }
        }
        .padding()
        .background(Color(hex: subtask.color))
        .cornerRadius(10)
    }
}
