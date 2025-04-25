//
//  ColorSelectorView.swift
//  NextStep
//
//  Created by Тася Галкина on 21.04.2025.
//

import SwiftUI

struct ColorSelectorView: View {
    @Binding var selectedColor: Color
    let availableColors: [Color] = [.blueMainColor, .yellowMainColor, .redMainColor, .greenMainColor, .pink, .purple] //  добавить норм цвета алло
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Цвет задачи")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                ForEach(availableColors, id: \.self) { color in
                    Circle()
                        .fill(color)
                        .frame(width: 32, height: 32) // Фиксированный размер
                        .overlay(
                            Group {
                                if selectedColor == color {
                                    Circle()
                                        .stroke(Color.white, lineWidth: 3)
                                        .scaleEffect(0.75) 
                                }
                            }
                        )
                        .onTapGesture {
                            selectedColor = color
                            print("✅ Выбран цвет: \(color)")
                        }
                        .padding(4)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

