//
//  ColorViewSetting.swift
//  TapNumber
//
//  Created by kyosuke on 2025/05/22.
//

import SwiftUI

struct ColorViewSetting: View {
    @EnvironmentObject private var appTheme: AppTheme
    let colors: [ThemeColor] = [
        ThemeColor.default,
        ThemeColor.green,
        ThemeColor.red,
        ThemeColor.blue,
    ]
    var body: some View {
        List(colors, id: \.self) { color in
            Button {
                print("before: \(appTheme.current)")
                print("before: \(appTheme.current.color)")
                appTheme.current = color
                print("after: \(appTheme.current)")
                print("after: \(appTheme.current.color)")
            } label: {
                HStack {
                    Rectangle()
                        .fill(color.color)
                        .frame(width: 28, height: 28)
                        .cornerRadius(4)
                        .padding(.horizontal, 8)
                    Text(color.colorText)
                        .foregroundStyle(Color("ThemeFontColor"))
                }
            }
        }
    }
}

#Preview {
    ColorViewSetting()
}
