//
//  WeekView.swift
//  NextStep
//
//  Created by Тася Галкина on 16.03.2025.
//

import SwiftUI

struct WeekView: View {
    @Binding var selectedDate: Date
    @State private var showDatePicker = false
    @State private var weekOffset = 0
    
    private let calendar = Calendar.current
    private let weekCount = 301
    private let centerIndex = 150
    
    private var currentWeekStart: Date {
        calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
    
    private func getDateForWeek(_ offset: Int) -> Date {
        calendar.date(byAdding: .weekOfYear, value: offset, to: currentWeekStart)!
    }
    
    private func isDateInDisplayedWeek(_ date: Date, for offset: Int) -> Bool {
        let displayedWeek = getDateForWeek(offset)
        return calendar.isDate(date, equalTo: displayedWeek, toGranularity: .weekOfYear)
    }
    
    private func monthYearString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        if isDateInDisplayedWeek(selectedDate, for: weekOffset) {
            return formatter.string(from: selectedDate)
        }
        
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                Text("\(monthYearString(for: getDateForWeek(weekOffset)))")
                    .font(customFont: .onestBold, size: 20)
                    .foregroundStyle(Color.blackColor)
                
                Image(systemName: "chevron.down")
                    .foregroundColor(.grayColor)
                    .frame(width: 40, height: 40)
                    .font(.system(size: 18))
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        weekOffset = 0
                        selectedDate = Date()
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 12))
                        Text("Today")
                            .font(customFont: .onestRegular, size: 15)
                            .foregroundStyle(Color.blackColor)
                    }
                    .padding(8)
                    .background(
                        ZStack {
                            Color.appContainer
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.grayColor, lineWidth: 1)
                        }
                    )
                    .foregroundColor(.blackColor)
                    .cornerRadius(8)
                }

                .opacity(isDateInDisplayedWeek(Date(), for: weekOffset) ? 0 : 1)
                .offset(y: isDateInDisplayedWeek(Date(), for: weekOffset) ? 20 : 0)
                .scaleEffect(isDateInDisplayedWeek(Date(), for: weekOffset) ? 0.9 : 1)
                .animation(.easeInOut(duration: 0.3), value: isDateInDisplayedWeek(Date(), for: weekOffset))

            }
            .padding(.leading, 8)
            .onTapGesture {
                showDatePicker = true
            }
            .overlay {
                if showDatePicker {
                    DatePicker(
                        "Test",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .accentColor(.blue)
                    .onChange(of: selectedDate) { _, _ in
                        showDatePicker = false
                    }
                    .blendMode(.destinationOver)
                }
            }
            
            TabView(selection: $weekOffset) {
                ForEach(-centerIndex..<centerIndex, id: \.self) { offset in
                    VStack {
                        WeekRowView(
                            baseDate: getDateForWeek(offset),
                            selectedDate: $selectedDate
                        )
                        .padding(.horizontal, 4)
                    }
                    .tag(offset)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 70)
            
        }
        .padding(.horizontal)
        .onChange(of: selectedDate) { _, newDate in
            let startOfNewDateWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: newDate))!
            
            if startOfNewDateWeek != getDateForWeek(weekOffset) {
                let newOffset = calendar.dateComponents([.weekOfYear], from: currentWeekStart, to: startOfNewDateWeek).weekOfYear ?? 0
                
                withAnimation {
                    weekOffset = newOffset
                }
            }
        }
    }
}

