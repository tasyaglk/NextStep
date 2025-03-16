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
            TextField("Search...", text: $text)
                .padding(8)
                .padding(.horizontal, 20)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 15)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                        
                        if !text.isEmpty {
                            Button {
                                text = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 20)
                            }
                        }
                    }
                )
        }
    }
}
