//
//  UserDefaultsUtil.swift
//  TapNumber
//
//  Created by kyosuke on 2025/05/22.
//

import Foundation

class UserDefaultsUtil {
    static let themeColor = "ThemeColor"

    static func saveThemeColor(type: ThemeColor) {
        // UserDefaultsに保存
        UserDefaults.standard.setValue(type.rawValue, forKey: themeColor)
    }

    static func getThemeColor() -> ThemeColor {
        // UserDefaultsから取得
        let themeNumbe = UserDefaults.standard.integer(forKey: themeColor)
        return ThemeColor(rawValue: themeNumbe)
            ?? ThemeColor.default
    }
}
