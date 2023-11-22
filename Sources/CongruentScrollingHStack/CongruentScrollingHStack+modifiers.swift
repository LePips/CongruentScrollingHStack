import SwiftUI

public extension CongruentScrollingHStack {

    func allowScrolling(_ value: Bool) -> Self {
        copy(modifying: \.allowScrolling, to: .constant(value))
    }

    func allowScrolling(_ binding: Binding<Bool>) -> Self {
        copy(modifying: \.allowScrolling, to: binding)
    }

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
        copy(modifying: \.onReachedTrailingEdge, to: action)
            .copy(modifying: \.onReachedTrailingEdgeOffset, to: offset)
    }

    func scrollBehavior(_ scrollBehavior: CongruentScrollingHStackScrollBehavior) -> Self {
        copy(modifying: \.scrollBehavior, to: scrollBehavior)
    }
}
