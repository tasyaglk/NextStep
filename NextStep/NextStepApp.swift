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
    @StateObject private var viewModel = GoalsViewModel()
    
    @State private var isLoggedIn = false
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if !UserService.isLoggedIn {
                    LoginView(isLoggedIn: $isLoggedIn)
                } else {
                    TabBarView()
                }
            }
            .environmentObject(viewModel)
            .navigationViewStyle(.stack)
        }
    }
}
