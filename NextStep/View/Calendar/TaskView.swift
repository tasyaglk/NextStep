////
////  TaskView.swift
////  NextStep
////
////  Created by Тася Галкина on 16.03.2025.
////
//
//import SwiftUI
//
//struct TaskView: View {
//    let task: CalendarTask
//    
//    var body: some View {
//        HStack(alignment: .top) {
//            VStack(alignment: .leading, spacing: 8) {
//                Text(task.title)
//                    .font(.subheadline)
//                    .fontWeight(.semibold)
//                    .foregroundColor(.blackColor)
//                
//                Text(task.description)
//                    .font(.caption)
//                    .foregroundColor(.grayColor)
//            }
//            Spacer()
//            
//            Button(action: {
//                
//            }) {
//                Image(systemName: "plus.circle.fill")
//                    .foregroundColor(.appContainer)
//                    .font(.system(size: 32))
//            }
//        }
//        .padding()
//        .background(task.color)
//        .cornerRadius(10)
//    }
//}
