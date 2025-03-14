//
//  ProfileViewModel.swift
//  NextStep
//
//  Created by Тася Галкина on 15.01.2025.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var userInfo: UserProfile = UserProfile(name: "Pupa", surname: "Zalupa", email: "pupaZalupa@mail.ru")
    @Published var logOutAlert: Bool = false
    @Published var changePassword: Bool = false
    @Published var logOut: Bool = false
    
    init() {
        loadUserInfo()
        print(userInfo)
    }
    
    func logOutTaped() {
        logOutAlert.toggle()
    }
    
    func changePasswordTaped() {
       changePassword.toggle()
    }
    
    func loadUserInfo() {
        if let savedData = UserDefaults.standard.data(forKey: "userProfile"),
           let decodedProfile = try? JSONDecoder().decode(UserProfile.self, from: savedData) {
               userInfo = decodedProfile
        }
        
    }
    
    func deleteUserProfile() {
        UserDefaults.standard.removeObject(forKey: "userProfile")
        logOut.toggle()
        UserService.isLoggedIn = false
    }
}
//tasya.galkina@mail.ru
