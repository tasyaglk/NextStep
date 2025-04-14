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
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var subtasks: [Subtask] = []
    @State private var selectedColor: Color = .blue
    
    @State private var newSubtaskTitle = ""
    @State private var newSubtaskDate = Date()
    
    init(taskToEdit: Goal? = nil, onSave: ((Goal) -> Void)? = nil) {
        self.taskToEdit = taskToEdit
        if let task = taskToEdit {
            _title = State(initialValue: task.title)
            _startDate = State(initialValue: task.startTime)

            if let duration = TimeInterval(task.duration) {
                _endDate = State(initialValue: task.startTime.addingTimeInterval(duration))
            } else {
                _endDate = State(initialValue: task.startTime)
            }
            _subtasks = State(initialValue: task.subtasks ?? [])
            _selectedColor = State(initialValue: Color(hex: task.color) ?? .blue)
        }
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Название цели", text: $title)
                    
                }
                .font(.custom("Onest-Regular", size: 16))
                .foregroundStyle(Color.blackColor)
                
                Section {
                    DatePicker("Начало", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                        .font(.custom("Onest-Regular", size: 16))
                        .foregroundStyle(Color.blackColor)
                    DatePicker("Окончание", selection: $endDate, in: startDate..., displayedComponents: [.date, .hourAndMinute])
                        .font(.custom("Onest-Regular", size: 16))
                        .foregroundStyle(Color.blackColor)
                }
                .listRowSeparator(.hidden)
                
                Section  {
                    Text("Подзадачи")
                        .font(.custom("Onest-Regular", size: 16))
                        .foregroundStyle(Color.blackColor)
                    
                    ForEach($subtasks) { $subtask in
                        HStack {
                            DatePicker(subtask.title, selection: $subtask.deadline, in: Date()...)
                        }
                    }
                    .onDelete { indices in
                        subtasks.remove(atOffsets: indices)
                    }
                    
                    HStack {
                        TextField("Новая подзадача", text: $newSubtaskTitle)
                            .font(.custom("Onest-Regular", size: 16))
                            .foregroundStyle(Color.blackColor)
                        DatePicker("", selection: $newSubtaskDate, displayedComponents: [.date, .hourAndMinute])
                        
                        Button(action: {
                            let newSubtask = Subtask(
                                id: UUID(),
                                title: newSubtaskTitle,
                                deadline: newSubtaskDate,
                                isCompleted: false
                            )
                            subtasks.append(newSubtask)
                            newSubtaskTitle = ""
                            newSubtaskDate = Date()
                            print(newSubtask)
                        }) {
                            Image(systemName: "plus.circle.fill")
                        }
                        .disabled(newSubtaskTitle.isEmpty)
                    }
                }
                .listRowSeparator(.hidden)
                
                
                Section {
                    ColorPicker("Цвет задачи", selection: $selectedColor)
                        .font(.custom("Onest-Regular", size: 16))
                        .foregroundStyle(Color.blackColor)
                }
            }
            .navigationTitle(taskToEdit == nil ? "Новая цель" : "Редактировать")
            .foregroundStyle(Color.blackColor)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                    .font(.custom("Onest-SemiBold", size: 16))
                    .foregroundColor(.appTeal)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(taskToEdit == nil ? "Добавить" : "Сохранить") {
                        saveTask()
                        dismiss()
                    }
                    .font(.custom("Onest-SemiBold", size: 16))
                    .foregroundColor(.appTeal)
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveTask() {
        let durationString = ISO8601DurationFormatter.string(from: endDate.timeIntervalSince(startDate))

        let colorString = selectedColor.toHex ?? "#000000"

        let task = Goal(
            id: taskToEdit?.id ?? UUID(),
            userId: UserService.userID,
            title: title,
            startTime: startDate,
            duration: durationString,
            color: colorString,
            isPinned: taskToEdit?.isPinned ?? false,
            subtasks: subtasks.filter { !$0.title.isEmpty }
        )

        if taskToEdit != nil {
            Task {
               await viewModel.updateGoal(task)
            }
        } else {
            Task {
                await viewModel.addGoal(task)
            }
        }
        onSave?(task)
    }
}
