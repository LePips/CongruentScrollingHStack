import OrderedCollections
import SwiftUI

struct BridgeView<Item: Hashable>: UIViewRepresentable {

    typealias UIViewType = UICongruentScrollView<Item>

    let didReachTrailingSide: () -> Void
    let didReachTrailingSideOffset: CGFloat
    let didScrollToItems: ([Item]) -> Void
    let horizontalInset: CGFloat
    let isCarousel: Bool
//    let items: Binding<OrderedSet<Item>>
    let itemSpacing: CGFloat
    let layout: CongruentScrollingHStackLayout
    let onReachedLeadingEdge: () -> Void
    let onReachedLeadingEdgeOffset: CGFloat
    let placeholderViewProvider: (Int) -> any View
    let scrollBehavior: CongruentScrollingHStackScrollBehavior
    let sizeObserver: SizeObserver
    let state: Binding<CongruentScrollingHStackState<Item>>
    let viewProvider: (Item) -> any View

    func makeUIView(context: Context) -> UIViewType {
        UICongruentScrollView(
            didReachTrailingSide: didReachTrailingSide,
            didReachTrailingSideOffset: didReachTrailingSideOffset,
            didScrollToItems: didScrollToItems,
            horizontalInset: horizontalInset,
            isCarousel: isCarousel,
            items: .constant([]),
            itemSpacing: itemSpacing,
            layout: layout,
            onReachedLeadingEdge: onReachedLeadingEdge,
            onReachedLeadingEdgeOffset: onReachedLeadingEdgeOffset,
            placeholderViewProvider: placeholderViewProvider,
            scrollBehavior: scrollBehavior,
            sizeObserver: sizeObserver,
            state: state.wrappedValue,
            viewProvider: viewProvider
        )
    }

    func updateUIView(_ view: UIViewType, context: Context) {
//        view.updateItems(with: items)
        
        print("update items called")
        view.updateItems(with: state)
    }
}
