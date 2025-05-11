//
//  GoalStatisticsView.swift
//  NextStep
//
//  Created by Тася Галкина on 19.04.2025.
//

import SwiftUI

struct GoalStatisticsView: View {
//    @EnvironmentObject var viewModel: GoalStatisticsViewModel
    @StateObject var viewModel: GoalStatisticsViewModel
//    @EnvironmentObject var viewModel: GoalsViewModel
    let selectedGoal: Goal
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.blackColor)
                    }
                    
                    Spacer()
                }
                HStack {
                    
                    Spacer()
                    
                    VStack {
                        Text(selectedGoal.title)
                            .font(.title)
                            .bold()
                            .padding(.top)
                        
                        ProgressRing(progress: viewModel.progress, count: viewModel.completedCount, total: viewModel.subtasks.count, ringColorHex: viewModel.goal.color)
                            .frame(width: 150, height: 150)
                            .padding(.vertical)
                    }
                    Spacer()
                }
            }
            .cardStyle()

//            TaskListView(selectedDate: Date())
//                .onAppear {
//                    Task {
//                        await viewModel.refreshGoal()
//                    }
//                }
            VStack {
                HStack {
                    Text("Этапы")
                        .font(customFont: .onestBold, size: 20)
                        .foregroundStyle(Color.blackColor)
                        
                    Spacer()
                }
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(viewModel.subtasks.sorted(by: { $0.deadline < $1.deadline }), id: \.self) { subtask in
                        SubtaskStatistics(
                            subtask: subtask,
                            onToggleCompletion: { subtask in
                                await viewModel.toggleCompletion(for: subtask)
                            }
                        )
                        .id(subtask.id.uuidString + "\(subtask.isCompleted)")
                    }
                }
            }
            .cardStyle()
        }
        .onAppear {
            Task {
                await viewModel.loadSubtasks(for: selectedGoal)
            }
        }
        .padding()
        .navigationBarHidden(true)
        
    }
}

