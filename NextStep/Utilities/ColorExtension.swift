//
//  ColorExtension.swift
//  NextStep
//
//  Created by Тася Галкина on 13.01.2025.
//

import SwiftUI
import UIKit

extension Color {
    static let blackColor = Color.adaptive(light: "020203", dark: "020203")
    static let grayColor = Color.adaptive(light: "787878", dark: "787878")
    static let lightYellow = Color.adaptive(light: "FFFEEF", dark: "FFFEEF")
    static let backgroundColor  = Color.adaptive(light: "EEEEEE", dark: "EEEEEE")
    static let lightBlue = Color.adaptive(light: "B1CEFF", dark: "B1CEFF")
    static let lightBack = Color.adaptive(light: "262626", dark: "262626")
    static let lightSkyBlue = Color.adaptive(light: "C9DAFA", dark: "C9DAFA")
    static let blueColor = Color.adaptive(light: "5D9CFF", dark: "5D9CFF")
    static let gradientLightColor = Color.adaptive(light: "DCEAFA", dark: "DCEAFA")
    static let gradientDarkColor = Color.adaptive(light: "A4C0F7", dark: "A4C0F7")
    static let textBackgroundField = Color.adaptive(light: "F7F7F7", dark: "F7F7F7")
    static let textBorderField = Color.adaptive(light: "EDEDED", dark: "EDEDED")
    static let appContainer = Color.adaptive(light: "F2F3FA", dark: "F2F3FA")
    static let appPurple = Color.adaptive(light: "ADA1DE", dark: "ADA1DE")
    static let appGreen = Color.adaptive(light: "AEDCB0", dark: "AEDCB0")
    static let appPink = Color.adaptive(light: "F08CD6", dark: "F08CD6")
    static let appOrange = Color.adaptive(light: "EABE92", dark: "EABE92")
    static let appBlue = Color.adaptive(light: "90A1E2", dark: "90A1E2")
    static let appTeal = Color.adaptive(light: "B5DEFF", dark: "B5DEFF")

    static let blueMainColor = Color.adaptive(light: "6A84F7", dark: "6A84F7")
    static let yellowMainColor = Color.adaptive(light: "F6CB4E", dark: "F6CB4E")
    static let redMainColor = Color.adaptive(light: "DF6861", dark: "DF6861")
    static let greenMainColor = Color.adaptive(light: "5FC3C1", dark: "5FC3C1")
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
    
    var toHex: String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "#%02lX%02lX%02lX",
                      lroundf(r * 255),
                      lroundf(g * 255),
                      lroundf(b * 255))
    }
    
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
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



