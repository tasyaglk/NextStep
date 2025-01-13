//
//  CustomFonts.swift
//  NextStep
//
//  Created by Тася Галкина on 13.01.2025.
//

import SwiftUI

enum CustomFonts: String {
    case onestMedium = "Onest-Medium"
    case onestBold = "Onest-Bold"
    case onestRegular = "Onest-Regular"
    case onestExtraBold = "Onest-ExtraBold"
}

extension Font {
    fileprivate static func custom(_ customFont: CustomFonts, size: CGFloat) -> Font {
        Font.custom(customFont.rawValue, size: size)
    }
}

extension Text {
    func font(customFont: CustomFonts, size: CGFloat) -> Text {
        self.font(Font.custom(customFont, size: size))
    }
}

