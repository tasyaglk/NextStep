//
//  TaskListView.swift
//  NextStep
//
//  Created by Тася Галкина on 16.03.2025.
//

import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var viewModel: GoalsViewModel
    let selectedDate: Date
    
    @State private var initialScrollPerformed = false
    @State private var timeSlotScale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    private let minScale: CGFloat = 0.5
    private let maxScale: CGFloat = 2.0
    private let defaultHourSpacing: CGFloat = 40
    
    private var hourSpacing: CGFloat {
        defaultHourSpacing * timeSlotScale
    }
    
    private var filteredTasks: [Subtask] {
        viewModel.subtasks
            .filter { subTask in
                Calendar.current.isDate(subTask.deadline, inSameDayAs: selectedDate)
            }
            .sorted { $0.deadline < $1.deadline }
    }

    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(dateFormatter.string(from: selectedDate))
                    .font(customFont: .onestSemiBold, size: 20)
                    .foregroundStyle(Color.blackColor)
                
                Text("You have \(filteredTasks.count) tasks scheduled for today")
                    .font(customFont: .onestRegular, size: 16)
                    .foregroundColor(.grayColor)
            }
            GeometryReader { geometry in
                ScrollViewReader { scrollProxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 16) {
                            
                            VStack(spacing: hourSpacing) {
                                ForEach(filteredTasks) { task in
                                    SubtaskView(
                                        subtask: task,
                                        onToggleCompletion: { subtask in
                                            print("???")
                                            print(subtask)
                                            print("???")
                                            await viewModel.toggleSubtaskCompletion(subtask)
                                            print("+++")
                                            print(subtask)
                                            print("+++")
                                        }
                                    )
                                }
                                Spacer()
                            }
                        }
                        .frame(minHeight: geometry.size.height)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadSubtasks()
            }
        }
        .padding()
        .background(.white
//            ZStack {
//                Color.appContainer
//                RoundedRectangle(cornerRadius: 20)
//                    .stroke(Color.grayColor, lineWidth: 1)
//            }
        )
        .cornerRadius(20)
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    let delta = value / lastScale
                    lastScale = value
                    
                    let newScale = timeSlotScale * delta
                    timeSlotScale = min(maxScale, max(minScale, newScale))
                }
                .onEnded { value in
                    lastScale = 1.0
                }
        )
        .simultaneousGesture(
            TapGesture(count: 2)
                .onEnded { _ in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        timeSlotScale = 3.0
                        lastScale = 1.0
                    }
                }
        )
        .simultaneousGesture(
            TapGesture(count: 1)
                .onEnded { _ in
                    if timeSlotScale != 1.0 {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            timeSlotScale = 1.0
                            lastScale = 1.0
                        }
                    }
                }
        )
        .animation(.interactiveSpring(
            response: 0.3, dampingFraction: 0.7, blendDuration: 0.1
        ), value: timeSlotScale)
        
    }
}
