//
//  ProfileViewModel.swift
//  NextStep
//
//  Created by Тася Галкина on 15.01.2025.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var userInfo: UserProfile = UserProfile(id: 123, name: "Pupa", surname: "Zalupa", email: "pupaZalupa@mail.ru")
    @Published var logOutAlert: Bool = false
    @Published var changePassword: Bool = false
    
    func logOutTaped() {
        logOutAlert.toggle()
    }
    
    func changePasswordTaped() {
       changePassword.toggle()
    }
}
//tasya.galkina@mail.ru
