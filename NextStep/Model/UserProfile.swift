//
//  UserProfile.swift
//  NextStep
//
//  Created by Тася Галкина on 13.01.2025.
//

import Foundation

struct UserProfile: Codable, Identifiable {
    let id = UUID()
    var name: String
    var surname: String
    var email: String
}
