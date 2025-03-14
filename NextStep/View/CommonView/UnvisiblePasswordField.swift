//
//  UnvisiblePasswordField.swift.swift
//  NextStep
//
//  Created by Тася Галкина on 17.01.2025.
//

import SwiftUI

struct UnvisiblePasswordField: View {
    var hint: String
    @Binding var password: String
    
    var body: some View {
        SecureField(hint, text: $password)
            .padding()
            .background(Color.textBackgroundField)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.textBorderField, lineWidth: 1)
            )
            .font(.custom("Onest-Regular", size: 14))
    }
}

//#Preview {
//    @Binding var password: String = projectedValue
//    UnvisiblePasswordField(hint: "Password", password: $password)
//}
