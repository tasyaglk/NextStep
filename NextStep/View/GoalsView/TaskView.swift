//
//  TaskView.swift
//  NextStep
//
//  Created by Тася Галкина on 16.03.2025.
//

import SwiftUI

struct TaskView: View {
    var task: CalendarTask
    let isUsualView: Bool
    @EnvironmentObject var viewModel: GoalsViewModel
    @State var isCompleted: Bool 
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(task.title)
                    .font(customFont: .onestSemiBold, size: 16)
                    .foregroundStyle(Color.blackColor)
                
                Text(task.description)
                    .font(customFont: .onestRegular, size: 14)
                    .foregroundStyle(Color.grayColor)
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
                    Button(action: {
                        var updatedTask = task
                        updatedTask.isCompleted = !task.isCompleted
                        viewModel.updateTask(updatedTask)
                        isCompleted.toggle()
                    }) {
                        Image(systemName: isCompleted ? "checkmark.circle.fill" : "plus.circle.fill")
                            .foregroundColor(.appContainer)
                            .font(.system(size: 32))
                    }
                }
                
            }
        }
        .onAppear {
            isCompleted = task.isCompleted
        }
//        .onChange(of: <#T##Equatable#>, <#T##action: (Equatable, Equatable) -> Void##(Equatable, Equatable) -> Void##(_ oldValue: Equatable, _ newValue: Equatable) -> Void#>)
        .padding()
        .background(Color(hex: task.color))
        .cornerRadius(10)
    }
}
