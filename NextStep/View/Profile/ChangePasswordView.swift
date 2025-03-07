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
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color.blackColor)
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Новый пароль")
                    .font(customFont: .onestBold, size: 16)
                    .foregroundStyle(Color.blackColor)
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
        .padding(.horizontal, 16)

        .navigationBarBackButtonHidden()
        
        
    }
}

//#Preview {
//    ChangePasswordView()
//}
