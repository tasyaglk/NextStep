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
        HStack(alignment: .bottom) {
            ZStack(alignment: .leading) {
                // Плейсхолдер
                if viewModel.newMessage.isEmpty {
                    Text("Сообщение...")
                        .foregroundColor(.gray)
                        .padding(.leading, 8)
                        .padding(.vertical, 12)
                }
                
                // Многострочный TextEditor
                TextEditor(text: $viewModel.newMessage)
                    .foregroundColor(.primary)
                    .font(.system(size: 16))
                    .frame(maxHeight: 80) // Ограничение на ~3 строки
                    .padding(.horizontal, 4)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .scrollContentBackground(.hidden) // Убираем стандартный фон
            }
            
            Button(action: {
                viewModel.sendMessage()
            }) {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .disabled(viewModel.newMessage.isEmpty || viewModel.isLoading)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
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
    @State private var typingDots: String = "."
    @State private var timer: Timer?
    
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
                    Text("Печатает\(typingDots)")
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .cornerRadius(15)
                        .italic()
                        .onAppear {
                            startTypingAnimation()
                        }
                        .onDisappear {
                            stopTypingAnimation()
                        }
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
    
    private func startTypingAnimation() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
            withAnimation {
                switch typingDots {
                case ".":
                    typingDots = ".."
                case "..":
                    typingDots = "..."
                case "...":
                    typingDots = "."
                default:
                    typingDots = "."
                }
            }
        }
    }
    
    private func stopTypingAnimation() {
        timer?.invalidate()
        timer = nil
        typingDots = "."
    }
}

