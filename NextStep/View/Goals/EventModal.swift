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

    private let segments = ["Event", "Reminder"]
    
    var body: some View {
        NavigationView {
            List {
                Picker("Type", selection: $selectedSegment) {
                    ForEach(0...1, id: \.self) { index in
                        Text(segments[index]).tag(index)
                    }
                }
                .pickerStyle(.segmented)
                .listRowBackground(Color.clear)
                
                Section {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                    TextField("Location", text: $location)
                }
                .listRowBackground(Color(UIColor.secondarySystemGroupedBackground))
                
                Section {
                    Toggle("All Day", isOn: $isAllDay)
                    
                    HStack {
                        Text("Starts")
                        Spacer()
                        DatePicker(
                            "",
                            selection: $startDate,
                            displayedComponents: isAllDay ? .date : [.date, .hourAndMinute]
                        )
                        .labelsHidden()
                    }
                    
                    HStack {
                        Text("Ends")
                        Spacer()
                        DatePicker(
                            "",
                            selection: $endDate,
                            in: startDate...,
                            displayedComponents: isAllDay ? .date : [.date, .hourAndMinute]
                        )
                        .labelsHidden()
                    }
                    
                    HStack {
                        Text("Travel Time")
                        Spacer()
                        Text("None")
                            .foregroundColor(.gray)
                    }
                }
                .listRowBackground(Color(UIColor.secondarySystemGroupedBackground))
                
             
                
                Section {
                        HStack {
                            Text("Calendar")
                            Spacer()
                            Circle()
                                .fill(Color.red)
                                .frame(width: 10, height: 10)
                            Text("Home")
                                .foregroundColor(.gray)
                        }
                    
                        HStack {
                            Text("Invitees")
                            Spacer()
                            Text("None")
                                .foregroundColor(.gray)
                        }
                }
                .listRowBackground(Color(UIColor.secondarySystemGroupedBackground))
                
                Section {
                   
                        HStack {
                            Text("Alert")
                            Spacer()
                            Text("None")
                                .foregroundColor(.gray)
                        }
                }
                .listRowBackground(Color(UIColor.secondarySystemGroupedBackground))
                
                Section {
                    Button(action: {
                        addTask()
                    }) {
                        Text("Add attachment...")
                    }
                }
                .listRowBackground(Color(UIColor.secondarySystemGroupedBackground))
                
                Section {
                    TextField("URL", text: $url)
                    TextField("Notes", text: $notes, axis: .vertical)
                        .frame(minHeight: 100, alignment: .top)
                }
                .listRowBackground(Color(UIColor.secondarySystemGroupedBackground))
                
                ColorPicker("Task Color", selection: $color)
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("New Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
//                        dismiss()
                        addTask()
                        
                        dismiss()
                    }
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


