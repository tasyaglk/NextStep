//
//  ChangePasswordView.swift
//  NextStep
//
//  Created by Тася Галкина on 17.01.2025.
//

import SwiftUI

struct ChangePasswordView: View {
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var isPasswordVisible: Bool = false
    @State var isConfirmPasswordVisible: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Новый пароль")
                .font(customFont: .onestBold, size: 16)
                .foregroundStyle(Color.blackColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            
            PasswordFieldView(
                isPasswordVisible: $isPasswordVisible,
                hint: "Password having 8 charecture",
                password: $password,
                isTextChanged: { (changed) in
                }
            )
            
            Text("Подтвердите пароль")
                .font(customFont: .onestBold, size: 16)
                .foregroundStyle(Color.blackColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            
            PasswordFieldView(
                isPasswordVisible: $isConfirmPasswordVisible,
                hint: "Password having 8 charecture",
                password: $confirmPassword,
                isTextChanged: { (changed) in
                    
                }
            )
            
            Spacer()
            Spacer()
            Text(password)
            Text(confirmPassword)
        }
    }
}

#Preview {
    ChangePasswordView()
}
