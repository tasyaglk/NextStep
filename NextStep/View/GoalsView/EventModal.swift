//
//  EventModal.swift
//  NextStep
//
//  Created by Тася Галкина on 16.03.2025.
//

import SwiftUI

struct EventModal: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: GoalsViewModel
    
    var taskToEdit: Goal?
    var onSave: ((Goal) -> Void)?
    
    @StateObject private var editor = GoalEditorViewModel()
    
    @State private var newSubtaskTitle = ""
    @State private var newSubtaskDate = Date()
    
    init(taskToEdit: Goal? = nil, onSave: ((Goal) -> Void)? = nil) {
        self.taskToEdit = taskToEdit
        self.onSave = onSave
        _editor = StateObject(wrappedValue: GoalEditorViewModel(goal: taskToEdit))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Название цели", text: $editor.title)
                }
                .font(.custom("Onest-Regular", size: 16))
                .foregroundStyle(Color.blackColor)
                
                Section {
                    DatePicker("Начало", selection: $editor.startDate, displayedComponents: [.date, .hourAndMinute])
                        .font(.custom("Onest-Regular", size: 16))
                        .foregroundStyle(Color.blackColor)
                    DatePicker("Окончание", selection: $editor.endDate, in: editor.startDate..., displayedComponents: [.date, .hourAndMinute])
                        .font(.custom("Onest-Regular", size: 16))
                        .foregroundStyle(Color.blackColor)
                }
                .listRowSeparator(.hidden)
                
                Section {
                    Text("Подзадачи")
                        .font(.custom("Onest-Regular", size: 16))
                        .foregroundStyle(Color.blackColor)
                    
                    ForEach($editor.subtasks) { $subtask in
                        DatePicker(subtask.title, selection: $subtask.deadline, in: editor.startDate...)
                    }
                    .onDelete { indices in
                        editor.subtasks.remove(atOffsets: indices)
                    }
                    
                    HStack {
                        TextField("Новая подзадача", text: $newSubtaskTitle)
                            .font(.custom("Onest-Regular", size: 16))
                            .foregroundStyle(Color.blackColor)
                        DatePicker("", selection: $newSubtaskDate, displayedComponents: [.date, .hourAndMinute])
                        
                        Button {
                            editor.addSubtask(title: newSubtaskTitle, deadline: newSubtaskDate, goalName: editor.title)
                            newSubtaskTitle = ""
                            newSubtaskDate = Date()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .backgroundStyle(Color.appTeal)
                        }
                        .disabled(newSubtaskTitle.isEmpty)
                    }
                }
                .listRowSeparator(.hidden)
                
                Section {
                    ColorPicker("Цвет задачи", selection: $editor.selectedColor)
                }
            }
            .onChange(of: editor.selectedColor) { _ in
                editor.updateSubtask()
                
            }
            .onChange(of: editor.title) { _ in
                editor.updateSubtask()
                
            }
            .navigationTitle(taskToEdit == nil ? "Новая цель" : "Редактировать")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                    .foregroundColor(.appTeal)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(taskToEdit == nil ? "Добавить" : "Сохранить") {
                        let goal = editor.buildGoal(existingGoal: taskToEdit)
                        
                        if taskToEdit != nil {
                            Task { await viewModel.updateGoal(goal) }
                        } else {
                            Task { await viewModel.addGoal(goal) }
                        }
                        
                        onSave?(goal)
                        dismiss()
                    }
                    .disabled(editor.title.isEmpty)
                    .foregroundColor(.appTeal)
                }
            }
        }
    }
}
