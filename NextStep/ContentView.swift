//
//  ContentView.swift
//  NextStep
//
//  Created by Тася Галкина on 13.01.2025.
//

import SwiftUI

import SwiftUI

//struct ContentView: View {
//    @State private var offset1 = CGSize(width: 100, height: 100)
//    @State private var offset2 = CGSize(width: -100, height: -100)
//    @State private var offset3 = CGSize(width: -150, height: 150)
//    @State private var offset4 = CGSize(width: 150, height: -150)
//
//    var body: some View {
//        ZStack {
//            LinearGradient(
//                gradient: Gradient(colors: [Color(red: 0.85, green: 0.95, blue: 1.00), Color(red: 0.90, green: 0.80, blue: 1.00)]),
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//            .ignoresSafeArea()
//
//            Circle()
//                .fill(Color(red: 0.85, green: 0.95, blue: 1.00))
//                .frame(width: 300, height: 300)
//                .offset(offset1)
//                .blur(radius: 30)
//                .animation(
//                    Animation.easeInOut(duration: 8).repeatForever(),
//                    value: offset1
//                )
//
//            Circle()
//                .fill(Color(red: 0.90, green: 0.80, blue: 1.00))
//                .frame(width: 350, height: 350)
//                .offset(offset2)
//                .blur(radius: 40)
//                .animation(
//                    Animation.easeInOut(duration: 10).repeatForever(),
//                    value: offset2
//                )
//
//            Circle()
//                .fill(Color(red: 1.00, green: 0.85, blue: 0.95))
//                .frame(width: 400, height: 400)
//                .offset(offset3)
//                .blur(radius: 50)
//                .animation(
//                    Animation.easeInOut(duration: 12).repeatForever(),
//                    value: offset3
//                )
//
//            Circle()
//                .fill(Color(red: 0.80, green: 1.00, blue: 0.90))
//                .frame(width: 450, height: 450)
//                .offset(offset4)
//                .blur(radius: 60)
//                .animation(
//                    Animation.easeInOut(duration: 14).repeatForever(),
//                    value: offset4
//                )
//        }
//        .onAppear {
//            withAnimation {
//                offset1 = CGSize(width: -200, height: -200) 
//                offset2 = CGSize(width: 200, height: 200)
//                offset3 = CGSize(width: 250, height: -250)
//                offset4 = CGSize(width: -250, height: 250)
//            }
//        }
//    }
//}
