//
//  VisiblePasswordField.swift
//  NextStep
//
//  Created by Тася Галкина on 17.01.2025.
//

import SwiftUI

struct VisiblePasswordField: View {
    var hint: String
    @Binding var password: String
    var isTextChanged: (Bool) -> Void
    
    var body: some View {
        
        TextField(hint, text: $password, onEditingChanged: isTextChanged)
            .padding()
            .background(Color.textBackgroundField)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.textBorderField, lineWidth: 1)
            )
            .autocapitalization(.none)
            .font(.custom("Onest-Regular", size: 14))
    }
}
