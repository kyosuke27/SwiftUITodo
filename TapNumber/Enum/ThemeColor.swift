import Foundation
import SwiftUI

enum ThemeColor: Int {
    case `default`
    case red
    case blue
    case green

    // 計算プロパティ
    var color: Color {
        // それぞれの色を選択した値から取得する
        switch self {
        case .default: return Color("DefaultColor")
        case .red: return Color.red
        case .blue: return Color.blue
        case .green: return Color.green
        }
    }

    var colorText: String {
        switch self {
        case .default: return "デフォルト"
        case .red: return "レッド"
        case .blue: return "ブルー"
        case .green: return "グリーン"
        }
    }
}
