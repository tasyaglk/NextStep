//
//  RegistrationView.swift
//  NextStep
//
//  Created by Тася Галкина on 06.03.2025.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject private var viewModel = RegistrationViewModel()
    @State private var isSignUpViewPresented = false
    @State var isPasswordVisible: Bool = false
    @State var isConfirmPasswordVisible: Bool = false
    @Binding var isLoggedIn: Bool
    @Environment(\.dismiss) var dismiss
    
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
                        Text("регистрация")
                            .font(customFont: .onestMedium, size: 16)
                            .foregroundStyle(Color.blackColor)
                        
                        Spacer()
                    }
                    
                    TextField("имя", text: $viewModel.name)
                        .padding()
                        .background(Color.textBackgroundField)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.textBorderField, lineWidth: 1)
                        )
                        .autocapitalization(.none)
                        .font(.custom("Onest-Regular", size: 14))
                    
                    TextField("фамилия", text: $viewModel.surname)
                        .padding()
                        .background(Color.textBackgroundField)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.textBorderField, lineWidth: 1)
                        )
                        .autocapitalization(.none)
                        .font(.custom("Onest-Regular", size: 14))
                    
                    TextField("почта", text: $viewModel.email)
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
                        hint: "пароль",
                        password: $viewModel.password,
                        isTextChanged: { (changed) in
                            
                        }
                    )
                    
                    PasswordFieldView(
                        isPasswordVisible: $isConfirmPasswordVisible,
                        hint: "подтвердите пароль",
                        password: $viewModel.confirmPassword,
                        isTextChanged: { (changed) in
                            
                        }
                    )
                    
                    Spacer()
                    
                    ButtonView(title: "Зарегистрироваться") {
                        viewModel.registerUser()
                    }
                    
                    
                    HStack {
                        Text("Уже есть аккаунт?")
                            .font(customFont: .onestMedium, size: 12)
                            .foregroundStyle(Color.grayColor)
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Войти")
                                .font(customFont: .onestMedium, size: 12)
                                .foregroundStyle(Color.grayColor)
                                .underline()
                        }
                    }
                    .padding(.bottom, 36)
                    .padding(.top, 32)
                    
                }
                .padding(.horizontal, 24)
                .padding(.top, 36)
                .background(Color.white)
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Сообщение"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                }
                .onChange(of: isLoggedIn) { newValue in
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
                    isActive: $viewModel.isSignUp
                ) {
                    EmptyView()
                }
            }
        }
        .background(Color.white)
        .navigationBarHidden(true)
        
    }
}

