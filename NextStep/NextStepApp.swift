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
    @State private var isLoggedIn = false
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LoginView(isLoggedIn: $isLoggedIn)
//                ContentView()
            }
            .navigationViewStyle(.stack)
        }
    }
}
