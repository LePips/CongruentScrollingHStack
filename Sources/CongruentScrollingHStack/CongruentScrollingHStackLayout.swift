import Foundation
import OrderedCollections
import SwiftUI

enum CongruentScrollingHStackLayout {

    case columns(CGFloat, trailingInset: CGFloat)
    case minimumWidth(CGFloat)
    case selfSizingSameSize
    case selfSizingVariadicWidth
}

public enum CongruentScrollingHStackState<Item: Hashable> {
    
    case items(Binding<OrderedSet<Item>>)
    case placeholder(Int)
}
