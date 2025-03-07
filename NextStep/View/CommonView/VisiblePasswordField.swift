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
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
        .overlay(
            RoundedRectangle(cornerRadius: 20).strokeBorder(
                .gray.opacity(0.2),
                style: StrokeStyle(lineWidth: 2.0)
            )
        )
    }
}
