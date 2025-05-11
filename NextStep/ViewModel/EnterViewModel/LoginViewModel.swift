//
//  LoginViewModel.swift
//  NextStep
//
//  Created by Тася Галкина on 06.03.2025.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isLoggedIn: Bool = false
    
    func loginUser() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Все поля обязательны для заполнения."
            showAlert = true
            return
        }
        
        UserService.login(email: email, password: password) { user in
            DispatchQueue.main.async {
                if user != nil {
                    self.isLoggedIn = true
                } else {
                    self.alertMessage = "Ошибка авторизации. Проверьте email и пароль."
                    self.showAlert = true
                }
            }
        }
    }
}
