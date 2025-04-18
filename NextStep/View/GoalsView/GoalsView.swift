//
//  GoalsView.swift
//  NextStep
//
//  Created by Тася Галкина on 16.03.2025.
//

import SwiftUI

struct GoalsView: View {
    @EnvironmentObject var viewModel: GoalsViewModel
        @State private var isShowingEventModal = false
        @State private var searchText = ""
        @State private var selectedTask: Goal?
        
        private var filteredTasks: [Goal] {
            viewModel.goals
                .filter {
                    searchText.isEmpty ||
                    $0.title.localizedCaseInsensitiveContains(searchText)
                }
                .sorted {
                    if $0.isPinned != $1.isPinned {
                        return $0.isPinned
                    }
                    return $0.startTime < $1.startTime
                }
        }
        
        var body: some View {
            VStack {
                Header
                
                SearchBar(text: $searchText)
                    .padding(.horizontal, 8)
                
                ScrollView {
                    ForEach(filteredTasks) { task in
                        TaskView(task: task)
                            .padding(.top, 8)
                            .contextMenu {
                                Button {
                                    Task {
                                        await viewModel.togglePin(for: task)
                                    }
                                } label: {
                                    Label(task.isPinned ? "Открепить" : "Закрепить", systemImage: task.isPinned ? "pin.slash" : "pin")
                                }

                                Button {
                                    selectedTask = task
                                    isShowingEventModal = true
                                } label: {
                                    Label("Редактировать", systemImage: "pencil")
                                }
                                
                                Button(role: .destructive) {
                                    Task {
                                        await viewModel.deleteGoal(task)
                                    }
                                } label: {
                                    Label("Удалить", systemImage: "trash")
                                }
                            }
                    }
                    .padding(.horizontal, 8)
                    
                    if filteredTasks.isEmpty {
                        Text("Нет задач")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .id(viewModel.goals.count)
            }
            .padding(.horizontal, 8)
            .sheet(isPresented: $isShowingEventModal) {
                EventModal(taskToEdit: selectedTask)
                    .environmentObject(viewModel)
                    .onDisappear { selectedTask = nil }
            }
            .onAppear {
                Task {
                    await viewModel.loadGoals()
                }
            }
        }
    
    
    private var Header: some View {
        HStack {
            Spacer()
            Text("Все цели")
                .font(customFont: .onestBold, size: 20)
            Spacer()
            Button(action: { isShowingEventModal = true }) {
                Image(systemName: "plus")
                    .foregroundColor(.blackColor)
            }
        }
        .padding()
    }
        
}
