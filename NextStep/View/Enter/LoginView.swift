//
//  LoginView.swift
//  NextStep
//
//  Created by Тася Галкина on 03.03.2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @StateObject private var goalsViewModel = GoalsViewModel()
    @Binding var isLoggedIn: Bool
    @State private var isSignUpViewPresented = false
    @State var isPasswordVisible: Bool = false
    
    var body: some View {
        ZStack {
            FloatingCircles()
            
            VStack {
                Text("NextStep")
                    .font(customFont: .onestBold, size: 32)
                    .foregroundStyle(Color.blackColor)
                    .padding(.leading, 8)
                    .padding(.vertical, 172)
                
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("login")
                                .font(customFont: .onestMedium, size: 16)
                                .foregroundStyle(Color.blackColor)
                            
                            
                            Text("welcome back")
                                .font(customFont: .onestMedium, size: 24)
                                .foregroundStyle(Color.blackColor)
                        }
                        .padding(.leading, 8)
                        
                        Spacer()
                    }
                    
                    TextField("Email", text: $viewModel.email)
                        .padding()
                        .background(Color.textBackgroundField)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.textBorderField, lineWidth: 1)
                        )
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .font(.custom("Onest-Regular", size: 14))                    
                    PasswordFieldView(
                        isPasswordVisible: $isPasswordVisible,
                        hint: "password",
                        password: $viewModel.password,
                        isTextChanged: { (changed) in
                            
                        }
                    )
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        ButtonView(title: "Login") {
                            viewModel.loginUser()
                            print(viewModel.isLoggedIn)
                        }
                        
                        ButtonView(title: "Apple login") {
                            print("apple")
                        }
                    }
                    
                    
                    HStack {
                        Text("Don't have any account?")
                            .font(customFont: .onestMedium, size: 12)
                            .foregroundStyle(Color.grayColor)
                        Button(action: {
                            isSignUpViewPresented = true
                        }) {
                            Text("Sign Up")
                                .font(customFont: .onestMedium, size: 12)
                                .foregroundStyle(Color.grayColor)
                                .underline()
                        }
                    }
                    .padding(.bottom, 36)
                    .padding(.top, 16)
                    
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .background(Color.white)
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Сообщение"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                }
                .onChange(of: viewModel.isLoggedIn) { newValue in
                    isLoggedIn = newValue
                }
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 48,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 0
                    )
                )
                .ignoresSafeArea()
                
                NavigationLink(
                    destination: TabBarView(),
                    isActive: $viewModel.isLoggedIn
                ) {
                    EmptyView()
                }
                
                NavigationLink(
                    destination: RegistrationView(isLoggedIn: $viewModel.isLoggedIn),
                    isActive: $isSignUpViewPresented
                ) {
                    EmptyView()
                }
                
            }
//            .background(Color.white)
        }
    }
}
//galkina.tasya@mail.ru
