//
//  TaskView.swift
//  NextStep
//
//  Created by Тася Галкина on 16.03.2025.
//

import SwiftUI

struct TaskView: View {
    let task: Goal
    @EnvironmentObject var viewModel: GoalsViewModel
    
    
    var body: some View {
        
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(task.title)
                    .font(customFont: .onestSemiBold, size: 20)
                    .foregroundStyle(Color.white)
            }
            
            Spacer()
            
            VStack {
                if task.isPinned {
                    Image(systemName: "pin.fill")
                        .rotationEffect(.degrees(45))
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .background(Color(hex: task.color))
        .cornerRadius(10)
    }
}
