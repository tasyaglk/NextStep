//
//  PasswordViewModel.swift
//  NextStep
//
//  Created by Тася Галкина on 17.01.2025.
//

import SwiftUI

class PasswordViewModel: ObservableObject  {
    @Published var isNext: Bool = false
    @Published var oldPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var alertMessage = ""
    @Published var showAlert = false
    @Published var userInfo: UserProfile?
    @Published var isChanged: Bool = false
    
    init() {
        if let savedData = UserDefaults.standard.data(forKey: "userProfile"),
           let decodedProfile = try? JSONDecoder().decode(UserProfile.self, from: savedData) {
            userInfo = decodedProfile
        }
    }
    
    func previousScreen() {
        isNext.toggle()
    }
    
    func changePassword(email: String, oldPassword: String, newPassword: String, completion: @escaping (Bool, String) -> Void) {
        let url = URL(string: "http://localhost:8080/change-password")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "oldPassword": oldPassword,
            "newPassword": newPassword
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "Ошибка сети: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion(true, "Пароль успешно изменен!")
                } else {
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
                        completion(false, json["message"] ?? "Ошибка сервера")
                    } else {
                        completion(false, "Ошибка: \(httpResponse.statusCode)")
                    }
                }
            }
        }.resume()
    }
    
    func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[0-9])(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    func passwordsMatch(_ password1: String, _ password2: String) -> Bool {
        return password1 == password2
    }
    
    func changePassword() {
        
        guard !oldPassword.isEmpty, !newPassword.isEmpty, !confirmPassword.isEmpty else {
            alertMessage = "Все поля обязательны для заполнения."
            showAlert = true
            return
        }
        
        guard passwordsMatch(newPassword, confirmPassword) else {
            alertMessage = "Пароли не совпадают."
            showAlert = true
            return
        }
        
        guard isPasswordValid(newPassword) else {
            alertMessage = "Пароль должен содержать минимум 8 символов, включая цифры и специальные символы (!@#$%^&*)."
            showAlert = true
            return
        }
        print(newPassword)
        print(oldPassword)
        
        changePassword(email: userInfo!.email, oldPassword: oldPassword, newPassword: newPassword) { success, message in
            DispatchQueue.main.async {
                if success {
                    self.isChanged = true
                } else {
                    self.alertMessage = message
                    self.showAlert = true
                }
                
            }
            
        }
    }
}

