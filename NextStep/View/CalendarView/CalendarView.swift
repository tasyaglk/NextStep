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
    @EnvironmentObject var viewModel: GoalsViewModel
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack(spacing: 16) {
                    Header(isShowingEventModal: $isShowingEventModal)
                    
                    WeekView(selectedDate: $selectedDate)
                        .padding(.bottom, 4)
                    
                    TaskListView(selectedDate: selectedDate)
                        .onAppear {
                            Task {
                                 viewModel.loadUserInfo()
                                await viewModel.loadGoals()
                            }
                        }
                }
                .padding(.top)
            }
        }
        .onAppear {
            Task {
                viewModel.loadUserInfo()
               await viewModel.loadGoals()
            }
        }
    }
}

struct Header: View {
    @Binding var isShowingEventModal: Bool
    
    var body: some View {
        HStack {
            
            Spacer()
            
            HStack(spacing: 16) {
                Text("календарь")
                    .font(customFont: .onestBold, size: 20)
                    .foregroundStyle(Color.blackColor)
            }
            
            Spacer()
            
        }
        .padding(.horizontal)
    }
}

