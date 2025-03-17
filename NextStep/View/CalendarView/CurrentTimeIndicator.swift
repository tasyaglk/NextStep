//
//  CurrentTimeIndicator.swift
//  NextStep
//
//  Created by Тася Галкина on 16.03.2025.
//

import SwiftUI

struct CurrentTimeIndicator: View {
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter.string(from: currentTime)
    }
    
    let hourSpacing: CGFloat
    private let timelineHourHeight: CGFloat = 30
    
    private var indicatorOffset: CGFloat {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: currentTime)
        let hour = CGFloat(components.hour ?? 0)
        let minute = CGFloat(components.minute ?? 0)
        
        return (hour + minute / 60) * (hourSpacing + timelineHourHeight)
    }
    
    var body: some View {
        HStack {
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 4)
                    .cornerRadius(2)
                
                Rectangle()
                    .fill(Color.appTeal)
                    .frame(width: 4, height: indicatorOffset + 10)
                    .cornerRadius(2)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.appTeal)
                        .frame(width: 35, height: 20)
                    
                    Text(timeString)
                        .font(customFont: .onestSemiBold, size: 11)
                        .foregroundStyle(Color.blackColor)
                }
                .offset(y: indicatorOffset)
            }
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
    }
}
