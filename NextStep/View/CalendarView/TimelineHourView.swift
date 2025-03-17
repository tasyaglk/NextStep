//
//  TimelineHourView.swift
//  NextStep
//
//  Created by Тася Галкина on 16.03.2025.
//

import SwiftUI


struct TimelineHourView: View {
    let hour: Int
    
    private var timeString: String {
        String(format: "%d:00", hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour))
    }
    
    private var amPm: String {
        hour < 12 ? "AM" : "PM"
    }
    
    var body: some View {
        VStack(alignment: .trailing) {
            Text(timeString)
            Text(amPm)
        }
        .font(.custom("Onest-SemiBold", size: 14))
        .foregroundStyle(Color.blackColor)
        .frame(height: 30)
        .id("hour-\(hour)")
    }
}
