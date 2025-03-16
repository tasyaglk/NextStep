//
//  CalendarView.swift
//  NextStep
//
//  Created by Тася Галкина on 13.01.2025.
//

import SwiftUI

struct CalendarView: View {
    @State private var isShowingEventModal = false
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack(spacing: 16) {
                    Header(isShowingEventModal: $isShowingEventModal)
                    
                    WeekView(selectedDate: $selectedDate)
                        .padding(.bottom, 4)
                    
                    TaskListView(selectedDate: selectedDate)
                }
                .padding(.top)
            }
        }
//        .sheet(isPresented: $isShowingEventModal) {
//            EventModal()
//                .presentationDetents([.large])
//                .presentationDragIndicator(.visible)
//        }
    }
        
}

struct Header: View {
    @Binding var isShowingEventModal: Bool
    
    var body: some View {
        HStack {
//            Button(action: {
//                
//            }) {
//                Image(systemName: "chevron.left")
//                    .foregroundColor(.blackColor)
//                    .frame(width: 40, height: 40)
//                    .font(.system(size: 18))
//            }
            
            Spacer()
            
            Button(action: {
                
            }) {
                HStack(spacing: 16) {
                    Text("Calendar")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.blackColor)
                }
            }
            
            Spacer()
            
//            Button(action: {
//                isShowingEventModal = true
//            }) {
//                Image(systemName: "plus")
//                    .foregroundColor(.blackColor)
//                    .frame(width: 40, height: 40)
//                    .font(.system(size: 24))
//            }
        }
        .padding(.horizontal)
    }
}

