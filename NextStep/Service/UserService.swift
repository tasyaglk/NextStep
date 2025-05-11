//
//  UserService.swift
//  NextStep
//
//  Created by Тася Галкина on 14.03.2025.
//

import Foundation

enum UserDefaultsKeys: String {
    case userLoggedIn
    case userID
}

class UserService {
    static var isLoggedIn: Bool {
        get {
            getValue(for: .userLoggedIn) ?? false
        }
        set {
            setValue(value: newValue, for: .userLoggedIn)
        }
    }
    
    static var userID: Int {
        get {
            getValue(for: .userID) ?? 1
        }
        set {
            setValue(value: newValue, for: .userID)
        }
    }
    
    static func login(email: String, password: String, completion: @escaping (UserProfile?) -> Void) {
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
        
        static func register(name: String, surname: String, email: String, password: String, completion: @escaping (Int?) -> Void) {
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
                    completion(nil)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200,
                      let data = data else {
                    completion(nil)
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Int]
                    let userId = json?["id"]
                    completion(userId)
                } catch {
                    print("Decoding error: \(error)")
                    completion(nil)
                }
            }.resume()
        }
        
        static func deleteUser(userID: Int) async throws -> (data: Data, response: URLResponse) {
            let urlString = "http://localhost:8080/users/\(userID)"
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            return try await URLSession.shared.data(for: request)
        }
        
        static func saveUserInfo(userInfo: UserProfile) {
            if let data = try? JSONEncoder().encode(userInfo) {
                UserDefaults.standard.set(data, forKey: "userProfile")
            }
            self.isLoggedIn = true
            self.userID = userInfo.id
        }
        
        static func saveUserInfo(name: String, surname: String, email: String, id: Int) {
            let user = UserProfile(id: id, name: name, surname: surname, email: email)
            if let data = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(data, forKey: "userProfile")
            }
            self.isLoggedIn = true
            self.userID = id
        }
}

extension UserService {
    
    fileprivate static func setValue<T>(value: T, for key: UserDefaultsKeys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    fileprivate static func getValue<T>(for key: UserDefaultsKeys) -> T? {
        return UserDefaults.standard.object(forKey: key.rawValue) as? T
    }
}



