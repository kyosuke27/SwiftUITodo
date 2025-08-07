import Foundation
import SwiftUICore

enum PriorityType: Int {
    case priorityOne
    case priorityTwo
    case priorityThree
    case priorityFour
    case `default`

    // 計算プロパティ
    var priorityColor: Color {
        // それぞれの色を選択した値から取得する
        switch self {
        case .default: return Color("PriorityOne")
        case .priorityOne: return Color("PriorityOne")
        case .priorityTwo: return Color("PriorityTwo")
        case .priorityThree: return Color("PriorityThree")
        case .priorityFour: return Color("PriorityFour")
        }
    }
}
