//
//  CustomTextFieldStyle.swift
//  NextStep
//
//  Created by Тася Галкина on 17.03.2025.
//

import SwiftUI

struct CustomTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Onest-Regular", size: 16))
    }
}

extension View {
    func customTextFieldStyle() -> some View {
        self.modifier(CustomTextFieldStyle())
    }
}
