//
//  PasswordViewModel.swift
//  NextStep
//
//  Created by Тася Галкина on 17.01.2025.
//

import SwiftUI

class PasswordViewModel {
    @Published var isNext: Bool = false
    
    func previousScreen() {
        isNext.toggle()
    }
}
