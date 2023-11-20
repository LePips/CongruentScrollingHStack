import Foundation
import OrderedCollections
import SwiftUI

enum CongruentScrollingHStackLayout {

    case columns(CGFloat, trailingInset: CGFloat)
    case minimumWidth(CGFloat)
    case selfSizingSameSize
    case selfSizingVariadicWidth
}

public enum CongruentScrollingHStackState<Item: Hashable>: Equatable {
    
    case items(Binding<OrderedSet<Item>>)
    case placeholder(Int)
    
    public static func ==(lhs: CongruentScrollingHStackState, rhs: CongruentScrollingHStackState) -> Bool {
        switch (lhs, rhs) {
        case (.items, .items):
            true
        case (.placeholder, .placeholder):
            true
        default:
            false
        }
    }
}
