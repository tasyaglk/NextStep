//
//  DayView.swift
//  NextStep
//
//  Created by Тася Галкина on 16.03.2025.
//

import SwiftUI

struct DayView: View {
    let date: Date
    let isSelected: Bool
    
    private let calendar = Calendar.current
    
    private var weekdayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).uppercased()
    }
    
    private var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private var isToday: Bool {
        calendar.isDateInToday(date)
    }
    
    private var isWeekend: Bool {
        let weekday = calendar.component(.weekday, from: date)
        return weekday == 1 || weekday == 7
    }
    
    private var textColor: Color {
        if isSelected {
            return .white
        }
        if isToday {
            return .blueMainColor
        }
        return isWeekend ? .grayColor : .blackColor
    }
    
    private var borderColor: Color {
        if isSelected {
            return .blueMainColor
        }
        return isToday ? .blueMainColor : .grayColor
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(weekdayString)
                .font(customFont: isSelected ? .onestSemiBold : .onestRegular, size: 12)
            
            Text(dayString)
                .font(customFont: isSelected ? .onestBold : .onestSemiBold, size: 20)
        }
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 8)
        .frame(maxWidth: .infinity)
        .foregroundColor(textColor)
        .padding(.vertical, 8)
        .background(
            ZStack {
                Color(isSelected ? Color.blueMainColor : Color.white)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: isToday ? 2 : 1)
            }
        )
        .cornerRadius(10)
    }
}
