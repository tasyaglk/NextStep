//
//  UserService.swift
//  NextStep
//
//  Created by Тася Галкина on 14.03.2025.
//

import Foundation

enum UserDefaultsKeys: String {
    case userLoggedIn
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
}

extension UserService {
    
    fileprivate static func setValue<T>(value: T, for key: UserDefaultsKeys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    fileprivate static func getValue<T>(for key: UserDefaultsKeys) -> T? {
        return UserDefaults.standard.object(forKey: key.rawValue) as? T
    }
}



