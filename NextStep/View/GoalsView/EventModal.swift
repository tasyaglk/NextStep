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
    @State private var showErrorAlert = false
    
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
                        DatePicker(subtask.title, selection: $subtask.deadline, in: editor.startDate...editor.endDate)
                            .font(.custom("Onest-Regular", size: 16))
                            .foregroundStyle(Color.blackColor)
                    }
                    .onDelete { indices in
                        editor.subtasks.remove(atOffsets: indices)
                    }
                    
                    HStack {
                        TextField("Новая подзадача", text: $newSubtaskTitle)
                            .font(.custom("Onest-Regular", size: 16))
                            .foregroundStyle(Color.blackColor)
                        DatePicker("", selection: $newSubtaskDate, in: editor.startDate...editor.endDate, displayedComponents: [.date, .hourAndMinute])
                        
                        Button {
                            editor.addSubtask(title: newSubtaskTitle, deadline: newSubtaskDate, goalName: editor.title)
                            if editor.errorMessage == nil {
                                newSubtaskTitle = ""
                                newSubtaskDate = Date()
                            } else {
                                showErrorAlert = true
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.appTeal)
                        }
                        .disabled(newSubtaskTitle.isEmpty)
                    }
                }
                .listRowSeparator(.hidden)
                
                Section {
                    ColorSelectorView(selectedColor: $editor.selectedColor)
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
                    .foregroundColor(.blackColor)
                    .font(.custom("Onest-Regular", size: 16))
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(taskToEdit == nil ? "Добавить" : "Сохранить") {
                        let goal = editor.buildGoal(existingGoal: taskToEdit)
                        if editor.errorMessage != nil {
                            showErrorAlert = true
                            return
                        }
                        Task {
                            if taskToEdit != nil {
                                await viewModel.updateGoal(goal)
                            } else {
                                await viewModel.addGoal(goal)
                            }
                            if viewModel.errorMessage == nil {
                                onSave?(goal)
                                dismiss()
                            } else {
                                showErrorAlert = true
                            }
                        }
                    }
                    .disabled(editor.title.isEmpty)
                    .foregroundColor(.blackColor)
                    .font(.custom("Onest-Regular", size: 16))
                }
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Ошибка"),
                    message: Text(editor.errorMessage ?? viewModel.errorMessage ?? "Неизвестная ошибка"),
                    dismissButton: .default(Text("OK"))
                )
            }
//            .alert(item: $viewModel.successMessage) { success in
//                Alert(title: Text("Успех"), message: Text(success))
//            }
        }
    }
}
