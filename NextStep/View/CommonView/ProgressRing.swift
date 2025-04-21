//
//  ProgressRing.swift
//  NextStep
//
//  Created by Тася Галкина on 19.04.2025.
//

import SwiftUI

struct ProgressRing: View {
    var progress: Double
    var count: Int
    var total: Int
    var ringColorHex: String

    @State private var animatedProgress: Double = 0.0

    var body: some View {
        let ringColor = Color(hex: ringColorHex) ?? .green

        ZStack {
            Circle()
                .stroke(lineWidth: 15)
                .opacity(0.3)
                .foregroundColor(Color(UIColor.systemGray3))
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.animatedProgress, 0.5)))
                .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                .foregroundColor(ringColor)
                .rotationEffect(Angle(degrees: 270.0))

            Circle()
                .trim(from: CGFloat(abs((min(animatedProgress, 1.0))-0.001)), to: CGFloat(abs((min(animatedProgress, 1.0))-0.0005)))
                .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color(UIColor.blue))
                .shadow(color: .black, radius: 10, x: 0, y: 0)
                .rotationEffect(Angle(degrees: 270.0))
                .clipShape(
                    Circle().stroke(lineWidth: 15)
                )

            Circle()
                .trim(from: animatedProgress > 0.5 ? 0.25 : 0, to: CGFloat(min(self.animatedProgress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                .foregroundColor(ringColor)
                .rotationEffect(Angle(degrees: 270.0))

            Text("\(Int((Double(count) / Double(total)) * 100))%")
                .font(.title)
                .bold()
        }
        .onAppear {
            animatedProgress = progress
        }
        .onChange(of: progress) { newValue in
            withAnimation(.easeOut(duration: 0.4)) {
                animatedProgress = newValue
            }
        }
    }
}
