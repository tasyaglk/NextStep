////
////  WeekRowView.swift
////  NextStep
////
////  Created by Тася Галкина on 16.03.2025.
////
//
//import SwiftUI
//
//struct WeekRowView: View {
//    let baseDate: Date
////    @Binding var selectedDate: Date
//    @State var viewModel = CalendarViewModel()
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
//                    isSelected: calendar.isDate(date, inSameDayAs: viewModel.selectedDate)
//                )
//                .onTapGesture {
//                    viewModel.selectedDate = date
//                }
//            }
//        }
//    }
//}
