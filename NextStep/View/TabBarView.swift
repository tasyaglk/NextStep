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
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("calendar")
                }
                .tag(0)
            
            ProfileView(profileViewModel: profileViewModel)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("profile")
                }
                .tag(1)
        }
    }
}
