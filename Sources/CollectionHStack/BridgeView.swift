import SwiftUI

struct BridgeView<Element, Data: Collection, ID: Hashable>: UIViewRepresentable where Data.Element == Element, Data.Index == Int {

    typealias UIViewType = UICollectionHStack<Element, Data, ID>

    let id: KeyPath<Element, ID>
    let allowBouncing: Bool
    let allowScrolling: Bool
    let clipsToBounds: Bool
    let data: Data
    let dataPrefix: Int
    let didScrollToItems: ([Element]) -> Void
    let insets: EdgeInsets
    let isCarousel: Bool
    let itemSpacing: CGFloat
    let layout: CollectionHStackLayout
    let onReachedLeadingEdge: () -> Void
    let onReachedLeadingEdgeOffset: CollectionHStackEdgeOffset
    let onReachedTrailingEdge: () -> Void
    let onReachedTrailingEdgeOffset: CollectionHStackEdgeOffset
    let proxy: CollectionHStackProxy
    let scrollBehavior: CollectionHStackScrollBehavior
    let sizeObserver: SizeObserver
    let viewProvider: (Element) -> any View
    let sizeBinding: Binding<CGSize>

    func makeUIView(context: Context) -> UIViewType {
        UICollectionHStack(
            id: id,
            clipsToBounds: clipsToBounds,
            data: data,
            dataPrefix: dataPrefix,
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
            newData: data,
            allowBouncing: allowBouncing,
            allowScrolling: allowScrolling,
            dataPrefix: dataPrefix
        )
    }
}
