//
//  ProfileViewModel.swift
//  NextStep
//
//  Created by Тася Галкина on 15.01.2025.
//

import Foundation
import EventKit

class ProfileViewModel: ObservableObject {
    @Published var userInfo: UserProfile
    @Published var logOutAlert: Bool = false
    @Published var changePassword: Bool = false
    @Published var logOut: Bool = false
    @Published var deleteAccountAlert: Bool = false
    @Published var errorMessage: String?
    
    private let goalService = GoalService()
    private let calendarManager = CalendarManager.shared
    
    init() {
        self.userInfo = UserProfile(id: 1, name: "Pupa", surname: "Zalupa", email: "pupaZalupa@mail.ru")
        loadUserInfo()
        print(userInfo)
    }
    
    func logOutTaped() {
        logOutAlert.toggle()
    }
    
    func changePasswordTaped() {
        changePassword.toggle()
    }
    
    func deleteAccountTaped() {
        deleteAccountAlert.toggle()
    }
    
    func loadUserInfo() {
        if let savedData = UserDefaults.standard.data(forKey: "userProfile"),
           let decodedProfile = try? JSONDecoder().decode(UserProfile.self, from: savedData) {
            userInfo = decodedProfile
            UserService.userID = decodedProfile.id
        }
    }
    
    func deleteUserProfile() {
        UserDefaults.standard.removeObject(forKey: "userProfile")
        logOut = true
        UserService.isLoggedIn = false
        print("✅ Logged out")
    }
    
    func deleteUser() async {
//        guard let userID = UserService.userID else {
//            DispatchQueue.main.async {
//                self.errorMessage = "User ID not found"
//            }
//            return
//        }
        let userID = UserService.userID
        // Получаем подзадачи
        do {
            let subtasks = try await goalService.fetchAllSubtasks(for: userID)
            // Удаляем события календаря
            for subtask in subtasks {
                do {
                    try await calendarManager.removeEvent(for: subtask)
                } catch {
                    print("⚠️ Failed to remove calendar event for subtask \(subtask.title): \(error)")
                    // Продолжаем, даже если ошибка
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch subtasks: \(error.localizedDescription)"
            }
            return
        }
        
        // Удаляем пользователя с сервера
        let urlString = "http://localhost:8080/users/\(userID)"
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid response from server"
                }
                return
            }
            
            if httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    self.errorMessage = nil
                    self.deleteUserProfile()
                    print("✅ User deleted successfully")
                }
            } else if httpResponse.statusCode == 404 {
                DispatchQueue.main.async {
                    self.errorMessage = "User not found"
                }
            } else {
                let errorMessage = try? JSONDecoder().decode([String: String].self, from: data)["message"]
                DispatchQueue.main.async {
                    self.errorMessage = errorMessage ?? "Failed to delete user: \(httpResponse.statusCode)"
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to delete user: \(error.localizedDescription)"
            }
        }
    }
}
