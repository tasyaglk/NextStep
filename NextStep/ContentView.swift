//
//  ContentView.swift
//  NextStep
//
//  Created by Тася Галкина on 13.01.2025.
//

import SwiftUI

//import SwiftUI
//
//struct ContentView: View {
//    @State private var showRegistration = false
//    @State private var showLogin = false
//    @State private var isLoggedIn = false
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                if isLoggedIn {
//                    Text("Вы авторизованы!")
//                        .font(.largeTitle)
//                        .padding()
//                } else {
//                    Text("Добро пожаловать!")
//                        .font(.largeTitle)
//                        .padding()
//                    
//                    Button(action: {
//                        showLogin = true
//                    }) {
//                        Text("Войти")
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    .padding()
//                    
//                    Button(action: {
//                        showRegistration = true
//                    }) {
//                        Text("Зарегистрироваться")
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.green)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    .padding()
//                }
//            }
//            .padding()
//            .navigationTitle("Главная")
//            .sheet(isPresented: $showRegistration) {
//                RegistrationView(isLoggedIn: <#Binding<Bool>#>)
//            }
//            .sheet(isPresented: $showLogin) {
//                LoginView(isLoggedIn: $isLoggedIn)
//            }
//        }
//    }
//}

//struct ContentView: View {
//    @State private var users: [UserProfile] = []
//    @State private var newUser = UserProfile(id: 0, name: "", surname: "", email: "")
//    @State private var showAlert = false
//    @State private var alertMessage = ""
//    
//    // Замените localhost на IP вашего компьютера, если тестируете на устройстве
//    let serverURL = "http://localhost:8080/users"
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                // Форма для добавления пользователя
//                Group {
//                    TextField("Name", text: $newUser.name)
//                    TextField("Surname", text: $newUser.surname)
//                    TextField("Email", text: $newUser.email)
//                    
//                    Button(action: addUser) {
//                        Text("Add User")
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                }
//                .padding(.horizontal)
//                
//                // Список пользователей
//                List(users) { user in
//                    VStack(alignment: .leading) {
//                        Text("\(user.name) \(user.surname)")
//                            .font(.headline)
//                        Text(user.email)
//                            .font(.subheadline)
//                    }
//                }
//            }
//            .navigationTitle("Users")
//            .alert(isPresented: $showAlert) {
//                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//            }
//            .onAppear {
//                loadUsers()
//            }
//        }
//    }
//    
//    // Загрузка пользователей
//    func loadUsers() {
//        guard let url = URL(string: serverURL) else { return }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                showAlert(message: "Error: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let data = data else {
//                showAlert(message: "No data received")
//                return
//            }
//            
//            do {
//                let decodedUsers = try JSONDecoder().decode([UserProfile].self, from: data)
//                DispatchQueue.main.async {
//                    self.users = decodedUsers
//                }
//            } catch {
//                showAlert(message: "Decoding error: \(error.localizedDescription)")
//            }
//        }.resume()
//    }
//    
//    // Добавление пользователя
//    func addUser() {
//        guard let url = URL(string: serverURL) else { return }
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        do {
//            request.httpBody = try JSONEncoder().encode(newUser)
//        } catch {
//            showAlert(message: "Encoding error: \(error.localizedDescription)")
//            return
//        }
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                showAlert(message: "Error: \(error.localizedDescription)")
//                return
//            }
//            
//            // Очищаем форму и обновляем список
//            DispatchQueue.main.async {
//                self.newUser = UserProfile(id: 0, name: "", surname: "", email: "")
//                self.loadUsers()
//                self.showAlert(message: "User added successfully!")
//            }
//        }.resume()
//    }
//    
//    func showAlert(message: String) {
//        DispatchQueue.main.async {
//            self.alertMessage = message
//            self.showAlert = true
//        }
//    }
//}
