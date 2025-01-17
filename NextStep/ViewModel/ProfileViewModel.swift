//
//  ProfileViewModel.swift
//  NextStep
//
//  Created by Тася Галкина on 15.01.2025.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var userInfo: UserProfile = UserProfile(firstName: "Pupa", secondName: "Zalupa", email: "pupaZalupa@mail.ru")
    @Published var logOutAlert: Bool = false
    @Published var changePassword: Bool = false
    
    func logOutTaped() {
        self.logOutAlert.toggle()
    }
    
    func changePasswordTaped() {
        self.changePassword.toggle()
    }
}
