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

    var body: some Scene {
        WindowGroup {
            NavigationView {
                TabBarView()
            }
            .navigationViewStyle(.stack)
        }
    }
}
