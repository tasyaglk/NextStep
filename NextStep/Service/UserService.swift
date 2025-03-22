//
//  UserService.swift
//  NextStep
//
//  Created by Тася Галкина on 14.03.2025.
//

import Foundation

enum UserDefaultsKeys: String {
    case userLoggedIn
    case userID
}

class UserService {
    static var isLoggedIn: Bool {
        get {
            getValue(for: .userLoggedIn) ?? false
        }
        set {
            setValue(value: newValue, for: .userLoggedIn)
        }
    }
    
    static var userID: Int {
        get {
            getValue(for: .userID) ?? 1
        }
        set {
            setValue(value: newValue, for: .userID)
        }
    }
}

extension UserService {
    
    fileprivate static func setValue<T>(value: T, for key: UserDefaultsKeys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    fileprivate static func getValue<T>(for key: UserDefaultsKeys) -> T? {
        return UserDefaults.standard.object(forKey: key.rawValue) as? T
    }
}



