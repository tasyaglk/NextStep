//
//  NextStepApp.swift
//  NextStep
//
//  Created by Тася Галкина on 13.01.2025.
//

import SwiftUI
import SwiftData

@main
struct NextStepApp: App {
    @StateObject private var goalsViewModel = GoalsViewModel()
    @State private var isLoggedIn = false
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if !UserService.isLoggedIn {
                    LoginView()
                } else {
                    TabBarView()
                }
            }
            .environmentObject(goalsViewModel)
            .navigationViewStyle(.stack)
        }
    }
}
