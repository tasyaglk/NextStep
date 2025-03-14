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
        
        guard isPasswordValid(password) else {
            alertMessage = "Пароль должен содержать минимум 8 символов, включая цифры и специальные символы (!@#$%^&*)."
            showAlert = true
            return
        }
        
        guard isValidEmail(email) else {
            alertMessage = "Некорректный email."
            showAlert = true
            return
        }
        
        login(email: email, password: password) { user in
            DispatchQueue.main.async {
                if let user = user {
                    self.isLoggedIn = true
                } else {
                    self.alertMessage = "Ошибка авторизации. Проверьте email и пароль."
                    self.showAlert = true
                }
            }
        }
    }
    
    func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[0-9])(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func login(email: String, password: String, completion: @escaping (UserProfile?) -> Void) {
        let url = URL(string: "http://localhost:8080/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            if let data = data {
                do {
                    let user = try JSONDecoder().decode(UserProfile.self, from: data)
                    self.saveUserInfo(userInfo: user)
                    completion(user)
                } catch {
                    print("Decoding error: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }
    
    private func saveUserInfo(userInfo: UserProfile) {
        if let data = try? JSONEncoder().encode(userInfo) {
            UserDefaults.standard.set(data, forKey: "userProfile")
        }
        UserService.isLoggedIn = true
    }
}
