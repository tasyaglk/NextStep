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
    @Binding var isLoggedIn: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Sign Up")
                .font(customFont: .onestBold, size: 32)
                .foregroundStyle(Color.blackColor)
                .padding(.leading, 8)
                .padding(.vertical, 72)
            
            VStack {
                
                TextField("name", text: $viewModel.name)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .autocapitalization(.none)
//                    .keyboardType(.emailAddress)
                    .font(.custom("Onest-Regular", size: 14))
                    .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 3)
                              
                TextField("surname", text: $viewModel.surname)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .autocapitalization(.none)
//                    .keyboardType(.emailAddress)
                    .font(.custom("Onest-Regular", size: 14))
                    .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 3)
                
                TextField("email", text: $viewModel.email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .font(.custom("Onest-Regular", size: 14))
                    .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 3)
                
                SecureField("password", text: $viewModel.password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .font(.custom("Onest-Regular", size: 14))
                    .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 3)
                
                SecureField("confirm password", text: $viewModel.confirmPassword)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .font(.custom("Onest-Regular", size: 14))
                    .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 3)
                
                Spacer()
                
                ButtonView(title: "Sign Up") {
                    viewModel.registerUser()
                }
                
                
                HStack {
                    Text("Already have any account?")
                        .font(customFont: .onestMedium, size: 12)
                        .foregroundStyle(Color.grayColor)
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Sign In")
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
            .background(Color.backgroundColor)
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
        .background(Color.white)
        .navigationBarHidden(true)
        
    }
}

