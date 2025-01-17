//
//  ProfileView.swift
//  NextStep
//
//  Created by Тася Галкина on 13.01.2025.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
//    @State private var logOutAlert = false
    
    var body: some View {
        
        VStack {
            
            HStack {
                Text(profileViewModel.userInfo.firstName + " " + profileViewModel.userInfo.secondName)
                    .font(customFont: .onestBold, size: 24)
                    .foregroundStyle(Color.blackColor)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 24)
            }
            
            Text(profileViewModel.userInfo.email)
                .font(customFont: .onestBold, size: 16)
                .foregroundStyle(Color.grayColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            
            Spacer()
            
            VStack {
                ButtonView(title: "Сменить пароль") {
                    profileViewModel.changePasswordTaped()
                }
                ButtonView(title: "Выйти из аккаунта") {
                    profileViewModel.logOutTaped()
                }
                .sheet(isPresented: $profileViewModel.logOutAlert) {
                    VStack(alignment: .leading) {
                        ButtonView(title: "Выйти из аккаунта") // сделать чтобы кнопка была красной
                        
                        ButtonView(title: "Отмена")
                            .padding(.vertical, 8)
                        
                    }
                    .padding(.horizontal, 16)
                    .presentationDetents([.height(200)])
                }
            }
            .padding(.horizontal, 16)
        }
        
        NavigationLink(
            destination: ChangePasswordView(),
            isActive: $profileViewModel.changePassword
        ) {
            EmptyView()
        }

    }
    
}


