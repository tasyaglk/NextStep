//
//  SearchBar.swift
//  NextStep
//
//  Created by Тася Галкина on 16.03.2025.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Поиск...", text: $text)
                .font(.custom("Onest-Regular", size: 16))
                .foregroundStyle(Color.black)
                .padding(8)
                .padding(.horizontal, 35)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 10)
                        
                        if !text.isEmpty {
                            Button {
                                text = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 10)
                            }
                        }
                    }
                )
        }
    }
}
