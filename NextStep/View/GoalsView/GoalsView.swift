//
//  GoalsView.swift
//  NextStep
//
//  Created by Тася Галкина on 16.03.2025.
//

import SwiftUI

struct GoalsView: View {
    @State private var isShowingEventModal = false
    @State private var searchText = ""
    @State private var selectedTask: CalendarTask?
    @EnvironmentObject var viewModel: GoalsViewModel
    
    private var filteredTasks: [CalendarTask] {
        if searchText.isEmpty {
            return viewModel.tasks
        } else {
            return viewModel.tasks.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack {
            Header
            
            SearchBar(text: $searchText)
                .padding(.horizontal)
            
            ScrollView {
                ForEach(filteredTasks) { task in
                    TaskView(task: task)
                        .padding(.top, 8)
                        .transition(.opacity)
                        .contextMenu {
                            Button {
                                selectedTask = task
                                isShowingEventModal = true
                            } label: {
                                Label("Редактировать", systemImage: "pencil")
                            }
                            
                            Button(role: .destructive) {
                               
                                    viewModel.deleteTask(task)
                                    if selectedTask?.id == task.id {
                                        selectedTask = nil
                                    }
                                
                            } label: {
                                Label("Удалить", systemImage: "trash")
                            }
                        }
                }
                
                if filteredTasks.isEmpty {
                    Text("Нет задач")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
//            .animation(.default, value: viewModel.tasks)
            .padding()
        }
        .sheet(isPresented: $isShowingEventModal) {
            EventModal(taskToEdit: selectedTask)
                .environmentObject(viewModel)
                .onDisappear { selectedTask = nil }
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
