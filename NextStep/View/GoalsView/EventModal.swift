//
//  EventModal.swift
//  NextStep
//
//  Created by Тася Галкина on 16.03.2025.
//

import SwiftUI

struct EventModal: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var location: String = ""
    @State private var isAllDay = false
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(3600)
    @State private var url: String = ""
    @State private var notes: String = ""
    @State private var selectedSegment = 0
    @EnvironmentObject var viewModel: GoalsViewModel
    
    let taskToEdit: CalendarTask?
    var onSave: ((CalendarTask) -> Void)?
    @State private var color: Color = .appBlue
    
    init(taskToEdit: CalendarTask? = nil, onSave: ((CalendarTask) -> Void)? = nil) {
            self.taskToEdit = taskToEdit
            self.onSave = onSave
            
            if let task = taskToEdit {
                _title = State(initialValue: task.title)
                _description = State(initialValue: task.description)
                _startDate = State(initialValue: task.startTime)
                _endDate = State(initialValue: task.startTime.addingTimeInterval(task.duration))
                _color = State(initialValue: task.color)
            }
        }

//    private let segments = ["Event", "Reminder"]
    
    var body: some View {
        NavigationView {
            List {
//                Picker("Type", selection: $selectedSegment) {
//                    ForEach(0...1, id: \.self) { index in
//                        Text(segments[index]).tag(index)
//                    }
//                }
//                .pickerStyle(.segmented)
//                .listRowBackground(Color.clear)
                
                Section {
                    TextField("Заголовок", text: $title)
                        .customTextFieldStyle()
                    TextField("Описание", text: $description)
                        .customTextFieldStyle()
                }
                .listRowBackground(Color(UIColor.secondarySystemGroupedBackground))
                
                Section {
                    HStack {
                        Text("Начинается")
                            .font(customFont: .onestRegular, size: 16)
                            .foregroundStyle(Color.blackColor)
                        Spacer()
                        DatePicker(
                            "",
                            selection: $startDate,
                            displayedComponents: isAllDay ? .date : [.date, .hourAndMinute]
                        )
                        .labelsHidden()
                    }
                    
                    HStack {
                        Text("Заканчивается")
                            .font(customFont: .onestRegular, size: 16)
                            .foregroundStyle(Color.blackColor)
                        Spacer()
                        DatePicker(
                            "",
                            selection: $endDate,
                            in: startDate...,
                            displayedComponents: isAllDay ? .date : [.date, .hourAndMinute]
                        )
                        .labelsHidden()
                    }
                }
                .listRowBackground(Color(UIColor.secondarySystemGroupedBackground))
                
                ColorPicker("Цвет задачи", selection: $color)
                    .font(.custom("Onest-Regular", size: 16))
                    .foregroundStyle(Color.blackColor)
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Новая цель")
            .font(.custom("Onest-Bold", size: 24))
            .foregroundStyle(Color.blackColor)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена", role: .cancel) {
                        dismiss()
                    }
                    .font(.custom("Onest-SemiBold", size: 16))
                    .foregroundColor(.red)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Добавить") {
                        addTask()
                        
                        dismiss()
                    }
                    .font(.custom("Onest-SemiBold", size: 16))
                    .foregroundColor(.red)
                }
            }
        }
    }
    
    private func addTask() {
            let duration = endDate.timeIntervalSince(startDate)
            let newTask = CalendarTask(
                title: title,
                description: description,
                startTime: startDate,
                duration: duration,
                color: .appBlue
            )
        print(newTask)
        
//            viewModel.addTask(newTask)
        if taskToEdit != nil {
                    onSave?(newTask)
                } else {
                    viewModel.addTask(newTask)
                }
        }
}

//#Preview() {
//    EventModal()
//}


