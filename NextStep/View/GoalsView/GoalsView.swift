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
    @State private var editingTask: CalendarTask? = nil
    
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
                        .contextMenu {
                            Button {
                                editTask(task)
                            } label: {
                                Label("Редактировать", systemImage: "pencil")
                                    .font(.custom("Onest-Regular", size: 16))
                                    .foregroundStyle(Color.blackColor)
                            }
                            
                            Button(role: .destructive) {
                                viewModel.deleteTask(task)
                            } label: {
                                Label("Удалить", systemImage: "trash")
                                    .font(.custom("Onest-Regular", size: 16))
                                    .foregroundStyle(Color.blackColor)
                            }
                        }
                }
            }
            .padding()
        }
        .sheet(isPresented: $isShowingEventModal) {
            EventModal(
                taskToEdit: editingTask,
                onSave: { updatedTask in
                    if let index = viewModel.tasks.firstIndex(where: { $0.id == updatedTask.id }) {
                        viewModel.tasks[index] = updatedTask
                    }
                    editingTask = nil
                }
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
    
    private var Header: some View {
        HStack {
            
            Spacer()
            
            
            HStack(spacing: 16) {
                Text("Все цели")
                    .font(customFont: .onestBold, size: 20)
                    .foregroundStyle(Color.blackColor)
            }
            
            
            Spacer()
            
            Button(action: {
                isShowingEventModal = true
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.blackColor)
                    .frame(width: 40, height: 40)
                    .font(.system(size: 24))
            }
            
        }
        .padding(.horizontal)
        .padding(.top, 16)
    }
    
    private func editTask(_ task: CalendarTask) {
        editingTask = task
        isShowingEventModal = true
    }
}



