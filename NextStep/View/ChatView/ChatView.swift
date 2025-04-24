//
//  ChatView.swift
//  NextStep
//
//  Created by Тася Галкина on 03.03.2025.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                }
                .onChange(of: viewModel.messages) { _ in
                    withAnimation {
                        if let lastMessage = viewModel.messages.last {
                            scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            if viewModel.showInputField {
                InputFieldView()
            } else {
                ActionButtonsView()
            }
        }
        .padding(.top)
    }
    
    @ViewBuilder
    private func InputFieldView() -> some View {
        HStack {
            TextField("Сообщение..", text: $viewModel.newMessage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                viewModel.sendMessage()
            }) {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Image(systemName: "arrow.up.circle.fill")
                }
            }
            .disabled(viewModel.newMessage.isEmpty || viewModel.isLoading)
        }
        .padding()
    }
    
    @ViewBuilder
    private func ActionButtonsView() -> some View {
        HStack(spacing: 20) {
            switch viewModel.state {
            case .showingPlan:
                Button("Перегенерировать план") {
                    viewModel.startRegeneration()
                }
                .buttonStyle(BorderedButtonStyle())
                
                Button("Составить расписание") {
                    viewModel.startSchedulePreferences()
                }
                .buttonStyle(BorderedButtonStyle())
                
                Button("Сбросить") {
                    viewModel.resetChat()
                }
                .buttonStyle(BorderedButtonStyle())
                
            case .showingSchedule:
                Button("Перегенерировать расписание") {
                    viewModel.startScheduleRegeneration()
                }
                .buttonStyle(BorderedButtonStyle())
                
                Button("Сохранить расписание") {
                    viewModel.saveAndResetChat()
                }
                .buttonStyle(BorderedButtonStyle())
                
                Button("Сбросить") {
                    viewModel.resetChat()
                }
                .buttonStyle(BorderedButtonStyle())
                
            default:
                EmptyView()
            }
        }
        .padding()
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                Text(message.content)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            } else {
                if message.isTypingIndicator {
                    Text(message.content)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .cornerRadius(15)
                        .italic()
                } else {
                    Text(message.content)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .cornerRadius(15)
                }
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}
