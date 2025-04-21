//
//  ColorSelectorView.swift
//  NextStep
//
//  Created by Тася Галкина on 21.04.2025.
//

import SwiftUI

struct ColorSelectorView: View {
    @Binding var selectedColor: Color
    let availableColors: [Color] = [.red, .green, .blue, .pink, .purple] //  добавить норм цвета алло

    var body: some View {
        VStack(alignment: .leading) {
            Text("Цвет задачи")
                .font(.headline)

            HStack {
                ForEach(availableColors, id: \.self) { color in
                    Circle()
                        .fill(color)
                        .frame(width: selectedColor == color ? 36 : 28,
                               height: selectedColor == color ? 36 : 28)
                        .overlay(
                            Circle()
                                .stroke(Color.black.opacity(0.2), lineWidth: 1)
                        )
                        .onTapGesture {
                            selectedColor = color
                        }
                        .padding(4)
                }
            }
        }
    }
}

