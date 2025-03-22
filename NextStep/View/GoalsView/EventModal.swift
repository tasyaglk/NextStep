//
//  EventModal.swift
//  NextStep
//
//  Created by Тася Галкина on 16.03.2025.
//

import SwiftUI

struct EventModal: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = GoalsViewModel()
    var taskToEdit: CalendarTask?
    var onSave: ((CalendarTask) -> Void)?
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var selectedColor: Color = .blue
    
//    var reloadData: ((CalendarTask) -> Void)?
    
    init(taskToEdit: CalendarTask? = nil, onSave: ((CalendarTask) -> Void)? = nil) {
        self.taskToEdit = taskToEdit
        if let task = taskToEdit {
            _title = State(initialValue: task.title)
            _description = State(initialValue: task.description)
            _startDate = State(initialValue: task.startTime)

            // Преобразуем duration из строки в TimeInterval
            if let duration = TimeInterval(task.duration) {
                _endDate = State(initialValue: task.startTime.addingTimeInterval(duration))
            } else {
                _endDate = State(initialValue: task.startTime) // Если ошибка, используем startTime
            }

            // Преобразуем цвет из HEX-строки в Color
            _selectedColor = State(initialValue: Color(hex: task.color) ?? .blue)
        }
        self.onSave = onSave
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
        // Преобразуем duration в строку формата ISO 8601
        let durationString = ISO8601DurationFormatter.string(from: endDate.timeIntervalSince(startDate))

        // Преобразуем выбранный цвет в HEX-строку
        let colorString = selectedColor.toHex ?? "#000000" // Если преобразование не удается, используем черный цвет по умолчанию

        let task = CalendarTask(
            id: taskToEdit?.id ?? UUID(),
            userId: UserService.userID, // Укажите правильный user_id, если он доступен
            title: title,
            description: description,
            startTime: startDate,
            duration: durationString,
            color: colorString,
            isPinned: taskToEdit?.isPinned ?? false
        )

        if taskToEdit != nil {
            viewModel.updateTask(task)
        } else {
            viewModel.addTask(task)
        }
        onSave?(task)
//        onSave?(task)
    }

}
