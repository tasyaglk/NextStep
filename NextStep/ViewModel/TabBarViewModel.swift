//
//  TabBarViewModel.swift
//  NextStep
//
//  Created by Тася Галкина on 13.01.2025.
//

import SwiftUI

class TabBarViewModel: ObservableObject {
    @Published var selectedIndex: Int = 0
    @Published var isTabBarHidden: Bool = false
}
