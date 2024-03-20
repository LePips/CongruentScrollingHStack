import OrderedCollections
import SwiftUI

struct BridgeView<Element: Hashable>: UIViewRepresentable {

    typealias UIViewType = UICollectionHStack<Element>

    let allowBouncing: Binding<Bool>
    let allowScrolling: Binding<Bool>
    let clipsToBounds: Bool
    let data: Binding<OrderedSet<Element>>
    let dataPrefix: Binding<Int?>
    let didScrollToItems: ([Element]) -> Void
    let insets: EdgeInsets
    let isCarousel: Bool
    let itemSpacing: CGFloat
    let layout: CollectionHStackLayout
    let onReachedLeadingEdge: () -> Void
    let onReachedLeadingEdgeOffset: CGFloat
    let onReachedTrailingEdge: () -> Void
    let onReachedTrailingEdgeOffset: CGFloat
    let proxy: CollectionHStackProxy<Element>
    let scrollBehavior: CollectionHStackScrollBehavior
    let sizeObserver: SizeObserver
    let viewProvider: (Element) -> any View
    let sizeBinding: Binding<CGSize>

    func makeUIView(context: Context) -> UIViewType {
        UICollectionHStack(
            clipsToBounds: clipsToBounds,
            data: data,
            didScrollToItems: didScrollToItems,
            insets: insets,
            isCarousel: isCarousel,
            itemSpacing: itemSpacing,
            layout: layout,
            onReachedLeadingEdge: onReachedLeadingEdge,
            onReachedLeadingEdgeOffset: onReachedLeadingEdgeOffset,
            onReachedTrailingEdge: onReachedTrailingEdge,
            onReachedTrailingEdgeOffset: onReachedTrailingEdgeOffset,
            proxy: proxy,
            scrollBehavior: scrollBehavior,
            sizeObserver: sizeObserver,
            viewProvider: viewProvider,
            sizeBinding: sizeBinding
        )
    }

    func updateUIView(_ view: UIViewType, context: Context) {
        view.update(
            with: data,
            allowBouncing: allowBouncing.wrappedValue,
            allowScrolling: allowScrolling.wrappedValue,
            dataPrefix: dataPrefix.wrappedValue,
            newSize: sizeBinding.wrappedValue
        )
    }
}
