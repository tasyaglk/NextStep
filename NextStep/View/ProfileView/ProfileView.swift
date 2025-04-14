//
//  ProfileView.swift
//  NextStep
//
//  Created by Тася Галкина on 13.01.2025.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            HStack {
                
                Spacer()
                
                Text("Profile")
                    .font(customFont: .onestBold, size: 20)
                    .foregroundStyle(Color.blackColor)
                
                Spacer()
                
            }
            .padding(.horizontal)
            .padding(.top, 16)
            
            HStack {
                Text(profileViewModel.userInfo.name + " " + profileViewModel.userInfo.surname)
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
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Spacer()
                            Text("Вы уверены, что хотите выйти?")
                                .font(customFont: .onestBold, size: 14)
                                .foregroundStyle(Color.grayColor)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                            Spacer()
                        }
                        ButtonView(title: "Выйти из аккаунта") {
                            profileViewModel.logOutAlert = false
                            DispatchQueue.main.async {
                                profileViewModel.deleteUserProfile()
                                
                            }
                        }
                        
                        ButtonView(title: "Отмена") {
                            profileViewModel.logOutTaped()
                        }
                        
                    }
                    .padding(.horizontal, 16)
                    .presentationDetents([.height(200)])
                }
                NavigationLink(
                    destination: LoginView(),
                    isActive: $profileViewModel.logOut
                ) {
                    EmptyView()
                }
            }
            .padding(.horizontal, 16)
            
            NavigationLink(
                destination: ChangePasswordView(),
                isActive: $profileViewModel.changePassword
            ) {
                EmptyView()
            }
        }
        .navigationBarBackButtonHidden()
    }
}


