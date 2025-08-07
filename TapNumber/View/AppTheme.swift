import SwiftUI

// Themecolorを管理するシングルトンクラス
// currentの値を更新するときに、UserDefaultsに保存する
class AppTheme: ObservableObject {
    static let shared = AppTheme()  // シングルトンクラス
    // UserDefaultsの糖衣構文
    @AppStorage("ThemeColor") private var stored: Int = ThemeColor.default
        .rawValue  // デフォルトのテーマカラー

    // Publishedを付けて環境変数に登録
    @Published var current: ThemeColor {
        didSet {
            // 値が変更されたときにUserDefaultsに保存する
            stored = current.rawValue
        }
    }

    private init() {
        // 初期値を設定
        // 値が設定されていた場合には登録
        let raw = UserDefaults.standard.integer(forKey: "ThemeColor")
        // currentプロパティに値を設定
        self.current = ThemeColor(rawValue: raw) ?? .default
    }
}
