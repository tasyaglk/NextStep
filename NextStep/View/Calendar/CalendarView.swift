//
//  CalendarView.swift
//  NextStep
//
//  Created by Тася Галкина on 13.01.2025.
//

import SwiftUI
import SwiftUI

struct CalendarView: View {
    @State private var isShowingEventModal = false
    @State private var selectedDate = Date()
    
    var body: some View {
        Text("lllll")
//        NavigationView {
//            ZStack {
//                Color.appBackground.ignoresSafeArea()
//                
//                VStack(spacing: 16) {
//                    Header(isShowingEventModal: $isShowingEventModal)
//                    
//                    WeekView(selectedDate: $selectedDate)
//                        .padding(.bottom, 4)
//                    
//                    TaskListView(selectedDate: selectedDate)
//                }
//                .padding(.top)
//            }
//        }
//        .sheet(isPresented: $isShowingEventModal) {
//            EventModal()
//                .presentationDetents([.large])
//                .presentationDragIndicator(.visible)
//        }
    }
}
//
//struct Header: View {
//    @Binding var isShowingEventModal: Bool
//    
//    var body: some View {
//        HStack {
//            Button(action: {
//                
//            }) {
//                Image(systemName: "chevron.left")
//                    .foregroundColor(.appTextPrimary)
//                    .frame(width: 40, height: 40)
//                    .font(.system(size: 18))
//            }
//            
//            Spacer()
//            
//            Button(action: {
//                
//            }) {
//                HStack(spacing: 16) {
//                    Text("Calendar")
//                        .font(.title3)
//                        .fontWeight(.bold)
//                        .foregroundColor(.appTextPrimary)
//                }
//            }
//            
//            Spacer()
//            
//            Button(action: {
//                isShowingEventModal = true
//            }) {
//                Image(systemName: "plus")
//                    .foregroundColor(.appTextPrimary)
//                    .frame(width: 40, height: 40)
//                    .font(.system(size: 24))
//            }
//        }
//        .padding(.horizontal)
//    }
//}
//
//struct WeekView: View {
//    @Binding var selectedDate: Date
//    @State private var showDatePicker = false
//    @State private var weekOffset = 0
//    
//    private let calendar = Calendar.current
//    private let weekCount = 301
//    private let centerIndex = 150
//    
//    private var currentWeekStart: Date {
//        calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
//    }
//    
//    private func getDateForWeek(_ offset: Int) -> Date {
//        calendar.date(byAdding: .weekOfYear, value: offset, to: currentWeekStart)!
//    }
//    
//    private func isDateInDisplayedWeek(_ date: Date, for offset: Int) -> Bool {
//        let displayedWeek = getDateForWeek(offset)
//        return calendar.isDate(date, equalTo: displayedWeek, toGranularity: .weekOfYear)
//    }
//    
//    private func monthYearString(for date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMMM yyyy"
//        
//        // If we're in the displayed week, use selected date
//        if isDateInDisplayedWeek(selectedDate, for: weekOffset) {
//            return formatter.string(from: selectedDate)
//        }
//        
//        return formatter.string(from: date)
//    }
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            HStack(spacing: 16) {
//                Text("\(monthYearString(for: getDateForWeek(weekOffset)))")
//                    .font(.title3)
//                    .fontWeight(.bold)
//                    .foregroundColor(.appTextPrimary)
//                
//                Image(systemName: "chevron.down")
//                    .foregroundColor(.appTextSecondary)
//                    .frame(width: 40, height: 40)
//                    .font(.system(size: 18))
//                
//                Spacer()
//                
//                Button(action: {
//                    withAnimation {
//                        weekOffset = 0
//                        selectedDate = Date()
//                    }
//                }) {
//                    HStack(spacing: 4) {
//                        Image(systemName: "calendar")
//                            .font(.system(size: 12))
//                        Text("Today")
//                            .font(.subheadline)
//                    }
//                    .padding(8)
//                    .background(
//                        ZStack {
//                            Color.appContainer
//                            RoundedRectangle(cornerRadius: 8)
//                                .stroke(Color.appBorder, lineWidth: 1)
//                        }
//                    )
//                    .foregroundColor(.appTextPrimary)
//                    .cornerRadius(8)
//                }
//                // OPACITY EFFECT
////                .opacity(isDateInDisplayedWeek(Date(), for: weekOffset) ? 0 : 1)
//                
//                // SCALED EFFECT
////                .scaleEffect(isDateInDisplayedWeek(Date(), for: weekOffset) ? 0.8 : 1)
////                .opacity(isDateInDisplayedWeek(Date(), for: weekOffset) ? 0 : 1)
////                .animation(.easeInOut, value: isDateInDisplayedWeek(Date(), for: weekOffset))
//                
//                // FADE WITH BLUR EFFECT
////                .opacity(isDateInDisplayedWeek(Date(), for: weekOffset) ? 0 : 1)
////                .blur(radius: isDateInDisplayedWeek(Date(), for: weekOffset) ? 10 : 0)
////                .animation(.easeInOut, value: isDateInDisplayedWeek(Date(), for: weekOffset))
//                
//                // COMBINE MULTIPLE EFFECT
//                .opacity(isDateInDisplayedWeek(Date(), for: weekOffset) ? 0 : 1)
//                .offset(y: isDateInDisplayedWeek(Date(), for: weekOffset) ? 20 : 0)
//                .scaleEffect(isDateInDisplayedWeek(Date(), for: weekOffset) ? 0.9 : 1)
//                .animation(.easeInOut(duration: 0.3), value: isDateInDisplayedWeek(Date(), for: weekOffset))
//
//            }
//            .padding(.leading, 8)
//            .onTapGesture {
//                showDatePicker = true
//            }
//            .overlay {
//                if showDatePicker {
//                    DatePicker(
//                        "Test",
//                        selection: $selectedDate,
//                        displayedComponents: .date
//                    )
//                    .labelsHidden()
//                    .datePickerStyle(.compact)
//                    .accentColor(.blue)
//                    .onChange(of: selectedDate) { _, _ in
//                        showDatePicker = false
//                    }
//                    .blendMode(.destinationOver)
//                }
//            }
//            
//            TabView(selection: $weekOffset) {
//                ForEach(-centerIndex..<centerIndex, id: \.self) { offset in
//                    VStack {
//                        WeekRowView(
//                            baseDate: getDateForWeek(offset),
//                            selectedDate: $selectedDate
//                        )
//                        .padding(.horizontal, 4)
//                    }
//                    .tag(offset)
//                }
//            }
//            .tabViewStyle(.page(indexDisplayMode: .never))
//            .frame(height: 70)
//            
//        }
//        .padding(.horizontal)
//        .onChange(of: selectedDate) { _, newDate in
//            let startOfNewDateWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: newDate))!
//            
//            if startOfNewDateWeek != getDateForWeek(weekOffset) {
//                let newOffset = calendar.dateComponents([.weekOfYear], from: currentWeekStart, to: startOfNewDateWeek).weekOfYear ?? 0
//                
//                withAnimation {
//                    weekOffset = newOffset
//                }
//            }
//        }
//    }
//}
//
//struct WeekRowView: View {
//    let baseDate: Date
//    @Binding var selectedDate: Date
//    
//    private let calendar = Calendar.current
//    private var datesForWeek: [Date] {
//        (0..<7).compactMap { index in
//            calendar.date(byAdding: .day, value: index, to: baseDate)
//        }
//    }
//    
//    var body: some View {
//        HStack(spacing: 8) {
//            ForEach(datesForWeek, id: \.timeIntervalSince1970) { date in
//                DayView(
//                    date: date,
//                    isSelected: calendar.isDate(date, inSameDayAs: selectedDate)
//                )
//                .onTapGesture {
//                    selectedDate = date
//                }
//            }
//        }
//    }
//}
//
//struct DayView: View {
//    let date: Date
//    let isSelected: Bool
//    
//    private let calendar = Calendar.current
//    
//    private var weekdayString: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEE"
//        return formatter.string(from: date).uppercased()
//    }
//    
//    private var dayString: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "d"
//        return formatter.string(from: date)
//    }
//    
//    private var isToday: Bool {
//        calendar.isDateInToday(date)
//    }
//    
//    private var isWeekend: Bool {
//        let weekday = calendar.component(.weekday, from: date)
//        return weekday == 1 || weekday == 7
//    }
//    
//    private var textColor: Color {
//        if isSelected {
//            return .white
//        }
//        if isToday {
//            return .appTeal
//        }
//        return isWeekend ? .appTextPrimary : .appTextSecondary
//    }
//    
//    private var borderColor: Color {
//        if isSelected {
//            return .appTeal
//        }
//        return isToday ? .appTeal : .appBorder
//    }
//    
//    var body: some View {
//        VStack(spacing: 8) {
//            Text(weekdayString)
//                .font(.caption)
//                .fontWeight(isSelected ? .semibold : .regular)
//            
//            Text(dayString)
//                .font(.title3)
//                .fontWeight(isSelected ? .bold : .semibold)
//        }
//        .frame(maxWidth: .infinity)
//        .foregroundColor(textColor)
//        .padding(.vertical, 8)
//        .background(
//            ZStack {
//                Color(isSelected ? Color.appTeal : Color.appContainer)
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(borderColor, lineWidth: isToday ? 2 : 1)
//            }
//        )
//        .cornerRadius(10)
//    }
//}
//
//struct TaskListView: View {
//    let tasks = CalendarTask.sampleTasks
//    let selectedDate: Date
//    
//    @State private var initialScrollPerformed = false
//    @State private var timeSlotScale: CGFloat = 1.0
//    @State private var lastScale: CGFloat = 1.0
//    
//    private let minScale: CGFloat = 0.5
//    private let maxScale: CGFloat = 2.0
//    private let defaultHourSpacing: CGFloat = 40
//    
//    private var hourSpacing: CGFloat {
//        defaultHourSpacing * timeSlotScale
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            VStack(alignment: .leading, spacing: 8) {
//                Text(dateFormatter.string(from: selectedDate))
//                    .font(.headline)
//                    .fontWeight(.semibold)
//                    .foregroundColor(.appTextPrimary)
//                
//                Text("You have 5 tasks scheduled for today")
//                    .font(.callout)
//                    .foregroundColor(.appTextSecondary)
//            }
//            GeometryReader { geometry in
//                ScrollViewReader { scrollProxy in
//                    ScrollView(.vertical, showsIndicators: false) {
//                        HStack(alignment: .top, spacing: 16) {
//                            
//                            TimelineView(hourSpacing: hourSpacing)
//                            
//                            CurrentTimeIndicator(hourSpacing: hourSpacing)
//                            
//                            VStack(spacing: hourSpacing) {
//                                ForEach(tasks) { task in
//                                    TaskView(task: task)
//                                }
//                            }
//                        }
//                        .frame(minHeight: geometry.size.height)
//                    }
//                    .onAppear {
//                        if !initialScrollPerformed {
//                            let calendar = Calendar.current
//                            let currentHour = calendar.component(.hour, from: Date())
//                            
//                            let targetHour = max(currentHour - 2, 0)
//                            
//                            scrollProxy.scrollTo("hour-\(targetHour)", anchor: .top)
//                            initialScrollPerformed = true
//                            
//                        }
//                    }
//                }
//            }
//        }
//        .padding()
//        .background(
//            ZStack {
//                Color.appContainer
//                RoundedRectangle(cornerRadius: 20)
//                    .stroke(Color.appBorder, lineWidth: 1)
//            }
//        )
//        .cornerRadius(20)
//        .gesture(
//            MagnificationGesture()
//                .onChanged { value in
//                    let delta = value / lastScale
//                    lastScale = value
//                    
//                    let newScale = timeSlotScale * delta
//                    timeSlotScale = min(maxScale, max(minScale, newScale))
//                }
//                .onEnded { value in
//                    lastScale = 1.0
//                }
//        )
//        .simultaneousGesture(
//            TapGesture(count: 2)
//                .onEnded { _ in
//                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
//                        timeSlotScale = 3.0
//                        lastScale = 1.0
//                    }
//                }
//        )
//        .simultaneousGesture(
//            TapGesture(count: 1)
//                .onEnded { _ in
//                    if timeSlotScale != 1.0 {
//                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
//                            timeSlotScale = 1.0
//                            lastScale = 1.0
//                        }
//                    }
//                }
//        )
//        .animation(.interactiveSpring(
//            response: 0.3, dampingFraction: 0.7, blendDuration: 0.1
//        ), value: timeSlotScale)
//    }
//    
//    var dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEEE, MMMM d, yyyy"
//        return formatter
//    }()
//    
//}
//
//struct TimelineView: View {
//    let hourSpacing: CGFloat
//    
//    var body: some View {
//        VStack(alignment: .trailing, spacing: hourSpacing) {
//            ForEach(0..<25) { hour in
//                TimelineHourView(hour: hour)
//            }
//        }
//        .padding(.bottom, 40)
//    }
//}
//
//struct TimelineHourView: View {
//    let hour: Int
//    
//    private var timeString: String {
//        String(format: "%d:00", hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour))
//    }
//    
//    private var amPm: String {
//        hour < 12 ? "AM" : "PM"
//    }
//    
//    var body: some View {
//        VStack(alignment: .trailing) {
//            Text(timeString)
//            Text(amPm)
//        }
//        .font(.footnote)
//        .fontWeight(.semibold)
//        .foregroundColor(.appTextPrimary)
//        .frame(height: 30)
//        .id("hour-\(hour)")
//    }
//}
//
//struct CurrentTimeIndicator: View {
//    @State private var currentTime = Date()
//    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
//    
//    private var timeString: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "h:mm"
//        return formatter.string(from: currentTime)
//    }
//    
//    let hourSpacing: CGFloat
//    private let timelineHourHeight: CGFloat = 30
//    
//    private var indicatorOffset: CGFloat {
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.hour, .minute], from: currentTime)
//        let hour = CGFloat(components.hour ?? 0)
//        let minute = CGFloat(components.minute ?? 0)
//        
//        return (hour + minute / 60) * (hourSpacing + timelineHourHeight)
//    }
//    
//    var body: some View {
//        HStack {
//            ZStack(alignment: .top) {
//                Rectangle()
//                    .fill(Color.appBackground)
//                    .frame(width: 4)
//                    .cornerRadius(2)
//                
//                Rectangle()
//                    .fill(Color.appTeal)
//                    .frame(width: 4, height: indicatorOffset + 10)
//                    .cornerRadius(2)
//                
//                ZStack {
//                    RoundedRectangle(cornerRadius: 4)
//                        .fill(Color.appTeal)
//                        .frame(width: 35, height: 20)
//                    
//                    Text(timeString)
//                        .font(.caption2)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.appTextPrimary)
//                }
//                .offset(y: indicatorOffset)
//            }
//        }
//        .onReceive(timer) { _ in
//            currentTime = Date()
//        }
//    }
//}
//
//struct TaskView: View {
//    let task: CalendarTask
//    
//    var body: some View {
//        HStack(alignment: .top) {
//            VStack(alignment: .leading, spacing: 8) {
//                Text(task.title)
//                    .font(.subheadline)
//                    .fontWeight(.semibold)
//                    .foregroundColor(.appTextPrimary)
//                
//                Text(task.description)
//                    .font(.caption)
//                    .foregroundColor(.appTextSecondary)
//            }
//            Spacer()
//            
//            Button(action: {
//                
//            }) {
//                Image(systemName: "plus.circle.fill")
//                    .foregroundColor(.appContainer)
//                    .font(.system(size: 32))
//            }
//        }
//        .padding()
//        .background(task.color)
//        .cornerRadius(10)
//    }
//}
//
//struct CalendarTask: Identifiable {
//    let id = UUID()
//    let title: String
//    let description: String
//    let startTime: Date
//    let duration: TimeInterval
//    let color: Color
//}
//
//extension CalendarTask {
//    static let sampleTasks: [CalendarTask] = {
//        let calendar = Calendar.current
//        let now = Date()
//        
//        func time(hour: Int, minute: Int = 0) -> Date {
//            calendar.date(bySettingHour: hour, minute: minute, second: 0, of: now) ?? now
//        }
//        
//        return [
//            CalendarTask(
//                title: "Team Stand-up Meeting",
//                description: "Review progress and plan tasks for the week",
//                startTime: time(hour: 9, minute: 30),
//                duration: 3600,
//                color: .appPurple
//            ),
//            
//            CalendarTask(
//                title: "Client Call",
//                description: "Discuss project updates and next steps with the client",
//                startTime: time(hour: 11),
//                duration: 1800,
//                color: .appGreen
//            ),
//            
//            CalendarTask(
//                title: "Gym Workout",
//                description: "Go for a 1 hour workout session",
//                startTime: time(hour: 13),
//                duration: 3600,
//                color: .appPink
//            ),
//            
//            CalendarTask(
//                title: "Vet Appointment",
//                description: "Take the dog to the vet for a check-up",
//                startTime: time(hour: 15, minute: 30),
//                duration: 1800,
//                color: .appOrange
//            ),
//            
//            CalendarTask(
//                title: "Design Review",
//                description: "Go over the latest UI updates",
//                startTime: time(hour: 17),
//                duration: 3600,
//                color: .appBlue
//            )
//        ]
//    }()
//}
