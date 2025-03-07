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
        VStack(alignment: .leading) {
            SecureField(hint, text: $password)
//                .font(customFont: .onestRegular, size: 16)
//                .foregroundStyle(Color.grayColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 20).strokeBorder(
                .gray.opacity(0.2),
                style: StrokeStyle(lineWidth: 2.0)
            )
        )
    }
}

//#Preview {
//    @Binding var password: String = projectedValue
//    UnvisiblePasswordField(hint: "Password", password: $password)
//}
