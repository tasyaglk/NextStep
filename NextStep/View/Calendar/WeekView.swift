//
//  WeekView.swift
//  NextStep
//
//  Created by Тася Галкина on 16.03.2025.
//

import SwiftUI
import SwiftUI
//
//struct WeekView: View {
//    @Binding var selectedDate: Date
//    @Binding var weekOffset: Int
//    @Binding var showDatePicker: Bool
//    
//    @StateObject private var viewModel = CalendarViewModel()
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            // Заголовок с датой и кнопкой "Today"
//            headerView
//            
//            // Таб-вью с неделями
//            weekTabView
//        }
//        .padding(.horizontal)
//        .onChange(of: selectedDate) { _, newDate in
//            handleDateChange(newDate)
//        }
//    }
//    
//    // Заголовок с датой и кнопкой "Today"
//    private var headerView: some View {
//        HStack(spacing: 16) {
//            Text("\(viewModel.monthYearString(for: viewModel.getDateForWeek(weekOffset)))")
//                .font(.title3)
//                .fontWeight(.bold)
//                .foregroundColor(.blackColor)
//            
//            Image(systemName: "chevron.down")
//                .foregroundColor(.appTextSecondary)
//                .frame(width: 40, height: 40)
//                .font(.system(size: 18))
//            
//            Spacer()
//            
//            Button(action: {
//                withAnimation {
//                    weekOffset = 0
//                    selectedDate = Date()
//                }
//            }) {
//                HStack(spacing: 4) {
//                    Image(systemName: "calendar")
//                        .font(.system(size: 12))
//                    Text("Today")
//                        .font(.subheadline)
//                }
//                .padding(8)
//                .background(
//                    ZStack {
//                        Color.appContainer
//                        RoundedRectangle(cornerRadius: 8)
//                            .stroke(Color.appBorder, lineWidth: 1)
//                    }
//                )
//                .foregroundColor(.appTextPrimary)
//                .cornerRadius(8)
//            }
//            .opacity(viewModel.isDateInDisplayedWeek(Date(), for: weekOffset) ? 0 : 1)
//            .offset(y: viewModel.isDateInDisplayedWeek(Date(), for: weekOffset) ? 20 : 0)
//            .scaleEffect(viewModel.isDateInDisplayedWeek(Date(), for: weekOffset) ? 0.9 : 1)
//            .animation(.easeInOut(duration: 0.3), value: viewModel.isDateInDisplayedWeek(Date(), for: weekOffset))
//        }
//        .padding(.leading, 8)
//        .onTapGesture {
//            showDatePicker = true
//        }
//        .overlay {
//            if showDatePicker {
//                DatePicker(
//                    "Test",
//                    selection: $selectedDate,
//                    displayedComponents: .date
//                )
//                .labelsHidden()
//                .datePickerStyle(.compact)
//                .accentColor(.blue)
//                .onChange(of: selectedDate) { _, _ in
//                    showDatePicker = false
//                }
//                .blendMode(.destinationOver)
//            }
//        }
//    }
//    
//    // Таб-вью с неделями
//    private var weekTabView: some View {
//        TabView(selection: $weekOffset) {
//            ForEach(viewModel.centerIndex..<viewModel.centerIndex, id: \.self) { offset in
//                VStack {
//                    WeekRowView(
//                        baseDate: viewModel.getDateForWeek(offset),
//                        selectedDate: $selectedDate
//                    )
//                    .padding(.horizontal, 4)
//                }
//                .tag(offset)
//            }
//        }
//        .tabViewStyle(.page(indexDisplayMode: .never))
//        .frame(height: 70)
//    }
//    
//    // Обработка изменения даты
//    private func handleDateChange(_ newDate: Date) {
//        let startOfNewDateWeek = viewModel.calendar.date(from: viewModel.calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: newDate))!
//        
//        if startOfNewDateWeek != viewModel.getDateForWeek(weekOffset) {
//            let newOffset = viewModel.calendar.dateComponents([.weekOfYear], from: viewModel.currentWeekStart, to: startOfNewDateWeek).weekOfYear ?? 0
//            
//            withAnimation {
//                weekOffset = newOffset
//            }
//        }
//    }
//}
