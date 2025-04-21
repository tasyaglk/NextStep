//
//  CardStyle.swift
//  NextStep
//
//  Created by Тася Галкина on 19.04.2025.
//

import SwiftUI

extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
