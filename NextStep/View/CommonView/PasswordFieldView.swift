//
//  PasswordFieldView.swift
//  NextStep
//
//  Created by Тася Галкина on 17.01.2025.
//

import SwiftUI

struct PasswordFieldView: View {
    @Binding var isPasswordVisible: Bool
    var hint: String
    @Binding var password: String
    var isTextChanged: (Bool) -> Void
    
    var body: some View {
        
        HStack(spacing: 0) {
            if isPasswordVisible {
                VisiblePasswordField(hint: hint, password: $password, isTextChanged: isTextChanged)
            } else {
                UnvisiblePasswordField(hint: hint, password: $password)
            }
        }
        .overlay(alignment: .trailing) {
            Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                .foregroundStyle(Color.grayColor)
                .padding()
                .onTapGesture {
                    isPasswordVisible.toggle()
                }
        }
        
    }
}
