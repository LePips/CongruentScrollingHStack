import OrderedCollections
import SwiftUI

struct BridgeView<Item: Hashable>: UIViewRepresentable {

    typealias UIViewType = UICongruentScrollView<Item>

    let didScrollToItems: ([Item]) -> Void
    let horizontalInset: CGFloat
    let isCarousel: Bool
    let items: Binding<OrderedSet<Item>>
    let itemSpacing: CGFloat
    let layout: CongruentScrollingHStackLayout
    let onReachedLeadingEdge: () -> Void
    let onReachedLeadingEdgeOffset: CGFloat
    let onReachedTrailingEdge: () -> Void
    let onReachedTrailingEdgeOffset: CGFloat
    let scrollBehavior: CongruentScrollingHStackScrollBehavior
    let sizeObserver: SizeObserver
    let viewProvider: (Item) -> any View

    func makeUIView(context: Context) -> UIViewType {
        UICongruentScrollView(
            didScrollToItems: didScrollToItems,
            horizontalInset: horizontalInset,
            isCarousel: isCarousel,
            items: items,
            itemSpacing: itemSpacing,
            layout: layout,
            onReachedLeadingEdge: onReachedLeadingEdge,
            onReachedLeadingEdgeOffset: onReachedLeadingEdgeOffset,
            onReachedTrailingEdge: onReachedTrailingEdge,
            onReachedTrailingEdgeOffset: onReachedTrailingEdgeOffset,
            scrollBehavior: scrollBehavior,
            sizeObserver: sizeObserver,
            viewProvider: viewProvider
        )
    }

    func updateUIView(_ view: UIViewType, context: Context) {
        view.updateItems(with: items)
    }
}
