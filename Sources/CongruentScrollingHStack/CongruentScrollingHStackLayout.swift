import Foundation

enum CongruentScrollingHStackLayout {

    case grid(columns: CGFloat, rows: Int, columnTrailingInset: CGFloat)
    case minimumWidth(columnWidth: CGFloat, rows: Int)
    case selfSizingSameSize
    case selfSizingVariadicWidth
}
