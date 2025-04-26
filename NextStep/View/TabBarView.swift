//
//  TabBarView.swift
//  NextStep
//
//  Created by Тася Галкина on 13.01.2025.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedIndex: Int = 0
    @StateObject private var profileViewModel = ProfileViewModel()
    @StateObject private var chatViewModel = ChatViewModel(userId: UserService.userID)
    
    // Цвета для иконок и текста
    private let activeColor: Color = Color.blueMainColor // Цвет для активной вкладки
    private let inactiveColor: Color = .gray.opacity(0.6) // Цвет для неактивной вкладки
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            CalendarView()
                .tabItem {
                    VStack {
                        Image(systemName: "calendar")
                            .foregroundStyle(selectedIndex == 0 ? activeColor : inactiveColor)
                        Text("календарь")
                            .foregroundStyle(selectedIndex == 0 ? activeColor : inactiveColor)
                    }
                }
                .tag(0)
            
            GoalsView()
                .tabItem {
                    VStack {
                        Image(systemName: "trophy.fill")
                            .foregroundStyle(selectedIndex == 1 ? activeColor : inactiveColor)
                        Text("цели")
                            .foregroundStyle(selectedIndex == 1 ? activeColor : inactiveColor)
                    }
                }
                .tag(1)
            
            ChatView(viewModel: chatViewModel)
                .tabItem {
                    VStack {
                        Image(systemName: "message.fill")
                            .foregroundStyle(selectedIndex == 2 ? activeColor : inactiveColor)
                        Text("чат")
                            .foregroundStyle(selectedIndex == 2 ? activeColor : inactiveColor)
                    }
                }
                .tag(2)
            
            ProfileView(profileViewModel: profileViewModel)
                .tabItem {
                    VStack {
                        Image(systemName: "person.fill")
                            .foregroundStyle(selectedIndex == 3 ? activeColor : inactiveColor)
                        Text("профиль")
                            .foregroundStyle(selectedIndex == 3 ? activeColor : inactiveColor)
                    }
                }
                .tag(3)
        }
        .tint(.blueMainColor)
        .navigationBarBackButtonHidden()
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 12,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 12
            )
        )
    }
}
