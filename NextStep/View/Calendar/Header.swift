////
////  Header.swift
////  NextStep
////
////  Created by Тася Галкина on 16.03.2025.
////
//
//import SwiftUI
//
//struct Header: View {
//    @Binding var isShowingEventModal: Bool
//    
//    var body: some View {
//        HStack {
//            Button(action: {}) {
//                Image(systemName: "chevron.left")
//                    .foregroundColor(.grayColor)
//                    .frame(width: 40, height: 40)
//                    .font(.system(size: 18))
//            }
//            
//            Spacer()
//            
//            Button(action: {}) {
//                HStack(spacing: 16) {
//                    Text("Calendar")
//                        .font(.title3)
//                        .fontWeight(.bold)
//                        .foregroundColor(.grayColor)
//                }
//            }
//            
//            Spacer()
//            
//            Button(action: {
//                isShowingEventModal = true
//            }) {
//                Image(systemName: "plus")
//                    .foregroundColor(.grayColor)
//                    .frame(width: 40, height: 40)
//                    .font(.system(size: 24))
//            }
//        }
//        .padding(.horizontal)
//    }
//}
