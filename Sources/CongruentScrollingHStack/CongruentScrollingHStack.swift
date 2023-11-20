import OrderedCollections
import SwiftUI

public struct CongruentScrollingHStack<Item: Hashable>: View {

    @StateObject
    private var sizeObserver = SizeObserver()

    var didReachTrailingSide: () -> Void
    var didReachTrailingSideOffset: CGFloat
    var didScrollToItems: ([Item]) -> Void
    let horizontalInset: CGFloat
    var isCarousel: Bool
//    let items: Binding<OrderedSet<Item>>
    let itemSpacing: CGFloat
    let layout: CongruentScrollingHStackLayout
    var onReachedLeadingSide: () -> Void
    var onReachedLeadingSideOffset: CGFloat
    var placeholderViewProvider: (Int) -> any View
    let scrollBehavior: CongruentScrollingHStackScrollBehavior
    let state: Binding<CongruentScrollingHStackState<Item>>
    let viewProvider: (Item) -> any View

    init(
        didReachTrailingSide: @escaping () -> Void = {},
        didReachTrailingSideOffset: CGFloat = 0,
        didScrollToItems: @escaping ([Item]) -> Void = { _ in },
        horizontalInset: CGFloat,
        isCarousel: Bool = false,
//        items: Binding<OrderedSet<Item>>,
        itemSpacing: CGFloat,
        layout: CongruentScrollingHStackLayout,
        onReachedLeadingSide: @escaping () -> Void = {},
        onReachedLeadingSideOffset: CGFloat = 0,
        placeholderViewProvider: @escaping (Int) -> any View = { _ in EmptyView() },
        scrollBehavior: CongruentScrollingHStackScrollBehavior,
        state: Binding<CongruentScrollingHStackState<Item>>,
        viewProvider: @escaping (Item) -> any View
    ) {
        self.didReachTrailingSide = didReachTrailingSide
        self.didReachTrailingSideOffset = didReachTrailingSideOffset
        self.didScrollToItems = didScrollToItems
        self.horizontalInset = horizontalInset
        self.isCarousel = isCarousel
//        self.items = items
        self.itemSpacing = itemSpacing
        self.layout = layout
        self.onReachedLeadingSide = onReachedLeadingSide
        self.onReachedLeadingSideOffset = onReachedLeadingSideOffset
        self.placeholderViewProvider = placeholderViewProvider
        self.scrollBehavior = scrollBehavior
        self.state = state
        self.viewProvider = viewProvider
    }

    public var body: some View {
        ZStack {
            SizeObserverView(sizeObserver: sizeObserver)

            BridgeView(
                didReachTrailingSide: didReachTrailingSide,
                didReachTrailingSideOffset: didReachTrailingSideOffset,
                didScrollToItems: didScrollToItems,
                horizontalInset: horizontalInset,
                isCarousel: isCarousel,
//                items: items,
                itemSpacing: itemSpacing,
                layout: layout,
                onReachedLeadingEdge: onReachedLeadingSide,
                onReachedLeadingEdgeOffset: onReachedLeadingSideOffset,
                placeholderViewProvider: placeholderViewProvider,
                scrollBehavior: scrollBehavior,
                sizeObserver: sizeObserver,
                state: state,
                viewProvider: viewProvider
            )
        }
    }
}
