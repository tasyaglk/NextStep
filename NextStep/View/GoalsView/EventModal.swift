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
    var taskToEdit: CalendarTask?
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var selectedColor: Color = .blue
    
    init(taskToEdit: CalendarTask? = nil) {
        self.taskToEdit = taskToEdit
        if let task = taskToEdit {
            _title = State(initialValue: task.title)
            _description = State(initialValue: task.description)
            _startDate = State(initialValue: task.startTime)
            _endDate = State(initialValue: task.startTime.addingTimeInterval(task.duration))
            _selectedColor = State(initialValue: task.color)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Заголовок", text: $title)
                    TextField("Описание", text: $description)
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
                
                Section {
                    ColorPicker("Цвет задачи", selection: $selectedColor)
                        .font(.custom("Onest-Regular", size: 16))
                        .foregroundStyle(Color.blackColor)
                }
            }
            .navigationTitle(taskToEdit == nil ? "Новая цель" : "Редактировать")
            .font(.custom("Onest-Bold", size: 24))
            .foregroundStyle(Color.blackColor)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                    .font(.custom("Onest-SemiBold", size: 16))
                    .foregroundColor(.red)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(taskToEdit == nil ? "Добавить" : "Сохранить") {
                        saveTask()
                        dismiss()
                    }
                    .font(.custom("Onest-SemiBold", size: 16))
                    .foregroundColor(.red)
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveTask() {
        let duration = endDate.timeIntervalSince(startDate)
        let task = CalendarTask(
            id: taskToEdit?.id ?? UUID(),
            title: title,
            description: description,
            startTime: startDate,
            duration: duration,
            color: selectedColor
        )
        
        if taskToEdit != nil {
            viewModel.updateTask(task)
        } else {
            viewModel.addTask(task)
        }
    }
}
