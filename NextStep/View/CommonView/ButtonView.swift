//
//  ButtonView.swift
//  NextStep
//
//  Created by Тася Галкина on 17.01.2025.
//

import SwiftUI

struct ButtonView: View {
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    var buttonClicked: (() -> Void)?
    var title: String
    var height: CGFloat
    
    var body: some View {
        Button(action: {
            buttonClicked?()
        }, label: {
            Text(title)
                .font(customFont: .onestBold, size: 16)
                .foregroundStyle(Color.white)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: height)
                .background(isEnabled ? Color.blueMainColor : Color.blueMainColor)
                .cornerRadius(14)
        })
        .shadow(color: .blueMainColor.opacity(0.5), radius: 3, x: 0, y: 3)
    }
    
    init(title: String, height: CGFloat = 55, buttonClicked: (() -> Void)? = nil) {
        self.title = title
        self.buttonClicked = buttonClicked
        self.height = height
    }
}
