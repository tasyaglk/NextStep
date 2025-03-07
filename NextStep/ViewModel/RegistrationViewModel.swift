//
//  RegistrationViewModel.swift
//  NextStep
//
//  Created by Тася Галкина on 06.03.2025.
//

import Foundation
import Combine

class RegistrationViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var surname: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isSignUp: Bool = false
    
    func registerUser() {
        guard !name.isEmpty, !surname.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            alertMessage = "Все поля обязательны для заполнения."
            showAlert = true
            return
        }
        
        guard password == confirmPassword else {
            alertMessage = "Пароли не совпадают."
            showAlert = true
            return
        }
        
        register(name: name, surname: surname, email: email, password: password) { success in
            DispatchQueue.main.async {
                if success {
//                    self.alertMessage = "Регистрация прошла успешно!"
                    self.isSignUp = true
                } else {
                    self.alertMessage = "Ошибка регистрации. Попробуйте снова."
                    self.showAlert = true
                }
                
            }
        }
    }
    
    private func register(name: String, surname: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "http://localhost:8080/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "name": name,
            "surname": surname,
            "email": email,
            "password": password
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
}
