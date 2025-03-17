//
//  ChangePasswordView.swift
//  NextStep
//
//  Created by Тася Галкина on 17.01.2025.
//

import SwiftUI

struct ChangePasswordView: View {
    @State var isOldPasswordVisible: Bool = false
    @State var isNewPasswordVisible: Bool = false
    @State var isConfirmPasswordVisible: Bool = false
    @State var isChange: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel = PasswordViewModel()
    
    var body: some View {
        ZStack {
            
            VStack {
                
                HStack(spacing: 0) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .frame(width: 36, height: 36)
                            .foregroundColor(Color.blackColor)
                    }
                    
                    Spacer()
                }
                
                VStack(alignment: .center, spacing: 8) {
                    Text("создать пароль")
                        .font(customFont: .onestBold, size: 24)
                        .foregroundStyle(Color.blackColor)
                    
                    Text("Этот пароль еще больше защитит вашу учетную запись от хакеров")
                        .font(customFont: .onestMedium, size: 16)
                        .foregroundStyle(Color.grayColor)
                        .multilineTextAlignment(.center)
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Введите старый пароль")
                        .font(customFont: .onestMedium, size: 16)
                        .foregroundStyle(Color.grayColor)
                        .multilineTextAlignment(.center)
                    
                    PasswordFieldView(
                        isPasswordVisible: $isOldPasswordVisible,
                        hint: "старый пароль",
                        password: $viewModel.oldPassword,
                        isTextChanged: { (changed) in
                        }
                    )
                    
                    Text("Введите новый пароль")
                        .font(customFont: .onestMedium, size: 16)
                        .foregroundStyle(Color.grayColor)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                    
                    PasswordFieldView(
                        isPasswordVisible: $isNewPasswordVisible,
                        hint: "пароль",
                        password: $viewModel.newPassword,
                        isTextChanged: { (changed) in
                        }
                    )
                    
                    Text("Пароль должен содержать не менее восьми символов, включая цифры и специальные символы (! # $ % ' () *)")
                        .font(customFont: .onestMedium, size: 14)
                        .foregroundStyle(Color.grayColor)
                        .padding(.vertical, 8)
                    
                    PasswordFieldView(
                        isPasswordVisible: $isConfirmPasswordVisible,
                        hint: "введите пароль повторно",
                        password: $viewModel.confirmPassword,
                        isTextChanged: { (changed) in
                            
                        }
                    )
                    
                    Spacer()
                    
                    ButtonView(title: "Сохранить") {
                        viewModel.changePassword()
                    }
                    .padding(.bottom, 16)
                }
                NavigationLink(
                    destination: TabBarView(),
                    isActive: $viewModel.isChanged
                ) {
                    EmptyView()
                }
            }
        }
        .padding(.horizontal, 16)
        .navigationBarBackButtonHidden()
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Сообщение"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
        
    }
}
