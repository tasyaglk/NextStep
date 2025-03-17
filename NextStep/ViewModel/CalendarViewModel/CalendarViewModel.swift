//
//  CalendarViewModel.swift
//  NextStep
//
//  Created by Тася Галкина on 16.03.2025.
//

import Foundation
import SwiftUI

class CalendarViewModel: ObservableObject {
    @Published var isShowingEventModal = false
    @Published var selectedDate = Date()
    @Published var weekOffset = 0
    @Published var showDatePicker = false
    @Published var timeSlotScale: CGFloat = 1.0
    @Published var lastScale: CGFloat = 1.0
    
    private let calendar = Calendar.current
    
    var currentWeekStart: Date {
        calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
    
    func getDateForWeek(_ offset: Int) -> Date {
        calendar.date(byAdding: .weekOfYear, value: offset, to: currentWeekStart)!
    }
    
    func isDateInDisplayedWeek(_ date: Date, for offset: Int) -> Bool {
        let displayedWeek = getDateForWeek(offset)
        return calendar.isDate(date, equalTo: displayedWeek, toGranularity: .weekOfYear)
    }
    
    func monthYearString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        if isDateInDisplayedWeek(selectedDate, for: weekOffset) {
            return formatter.string(from: selectedDate)
        }
        
        return formatter.string(from: date)
    }
}
