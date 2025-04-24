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
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("calendar")
                }
                .tag(0)
            
            GoalsView()
                .tabItem {
                    Image(systemName: "trophy.fill")
                    Text("goals")
                }
                .tag(1)
            
            
            ChatView(viewModel: chatViewModel)
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("chats")
                }
                .tag(2)
            
            ProfileView(profileViewModel: profileViewModel)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("profile")
                }
                .tag(3)
        }
        .navigationBarBackButtonHidden()
        .background(Color.lightBlue)
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
