import Foundation
import SwiftUI

public extension CongruentScrollingHStack {

    func asCarousel() -> Self {
        copy(modifying: \.isCarousel, to: true)
    }

    func didScrollToItems(_ action: @escaping ([Item]) -> Void) -> Self {
        copy(modifying: \.didScrollToItems, to: action)
    }

    func onReachedLeadingEdge(offset: CGFloat = 0, _ action: @escaping () -> Void) -> Self {
        copy(modifying: \.onReachedLeadingSide, to: action)
            .copy(modifying: \.onReachedLeadingSideOffset, to: offset)
    }

    func onReachedTrailingEdge(offset: CGFloat = 0, _ action: @escaping () -> Void) -> Self {
        copy(modifying: \.didReachTrailingSide, to: action)
            .copy(modifying: \.didReachTrailingSideOffset, to: offset)
    }
    
    func placeholder(_ content: @escaping (Int) -> any View) -> Self {
        copy(modifying: \.placeholderViewProvider, to: content)
    }
}
