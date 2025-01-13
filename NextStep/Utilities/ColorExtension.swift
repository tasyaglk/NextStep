//
//  ColorExtension.swift
//  NextStep
//
//  Created by Тася Галкина on 13.01.2025.
//

import SwiftUI
import UIKit

extension Color {
    static let purpleColor = Color.adaptive(light: "AE7DD1", dark: "AE7DD1")
    static let grayColor = Color.adaptive(light: "787878", dark: "787878")
    static let darkBlueColor = Color.adaptive(light: "050A1D", dark: "050A1D")
    static let lightBlueColor = Color.adaptive(light: "181C2E", dark: "181C2E")
    static let lightPurple = Color.adaptive(light: "7F3AEF", dark: "7F3AEF")
    static let darkPurple = Color.adaptive(light: "3E2481", dark: "3E2481")
    static let darkGray = Color.adaptive(light: "82848D", dark: "82848D")
}

extension Color {
    init(uiColor: UIColor) {
        self.init(UIColor { traitCollection -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return uiColor
            default:
                return uiColor
            }
        })
    }
    
    static func adaptive(light: String, dark: String) -> Color {
        Color(uiColor: .adaptiveColor(lightHex: light, darkHex: dark))
    }
    
    init(hex: String, alpha: Double = 1) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) { cString.remove(at: cString.startIndex) }
        
        let scanner = Scanner(string: cString)
        scanner.currentIndex = scanner.string.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        self.init(.sRGB, red: Double(r) / 0xff, green: Double(g) / 0xff, blue:  Double(b) / 0xff, opacity: alpha)
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (15, (int >> 8), (int >> 4 & 0xF), (int & 0xF))
            self.init(red: CGFloat(r) / 15.0, green: CGFloat(g) / 15.0, blue: CGFloat(b) / 15.0, alpha: alpha)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
        default:
            self.init(red: 0, green: 0, blue: 0, alpha: alpha)
        }
    }

    static func adaptiveColor(lightHex: String, darkHex: String) -> UIColor {
        return UIColor { traitCollection -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(hex: darkHex)
            default:
                return UIColor(hex: lightHex)
            }
        }
    }
}

