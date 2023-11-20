import Foundation

enum CongruentScrollingHStackLayout {

    case columns(CGFloat, trailingInset: CGFloat)
    case minimumWidth(CGFloat)
    case selfSizingSameSize
    case selfSizingVariadicWidth
}
