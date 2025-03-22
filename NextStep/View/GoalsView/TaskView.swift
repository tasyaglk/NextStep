//
//  TaskView.swift
//  NextStep
//
//  Created by Тася Галкина on 16.03.2025.
//

import SwiftUI

struct TaskView: View {
    let task: CalendarTask
    
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
                
                
                Button(action: {
                    print("complete")
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.appContainer)
                        .font(.system(size: 32))
                }
                
                if task.isPinned {
                    Image(systemName: "pin.fill")
                        .rotationEffect(.degrees(45))
                        .foregroundColor(.appContainer)
                } 
            }
        }
        .padding()
        .background(Color(hex: task.color))
        .cornerRadius(10)
    }
}
