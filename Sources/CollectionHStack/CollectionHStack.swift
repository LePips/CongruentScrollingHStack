import SwiftUI

#if os(tvOS)
private let defaultClipsToBounds = false
private let defaultHorizontalInset: CGFloat = 50
private let defaultItemSpacing: CGFloat = 40
#else
private let defaultClipsToBounds = true
private let defaultHorizontalInset: CGFloat = 15
private let defaultItemSpacing: CGFloat = 10
#endif

public struct CollectionHStack<Element, Data: Collection, ID: Hashable>: View where Data.Element == Element, Data.Index == Int {

    @State
    private var contentSize: CGSize = .zero

    @StateObject
    private var sizeObserver = SizeObserver()

    var id: KeyPath<Element, ID>
    var allowBouncing: Bool
    var allowScrolling: Bool
    var clipsToBounds: Bool
    let data: Data
    var dataPrefix: Int?
    var didScrollToItems: ([Element]) -> Void
    var insets: EdgeInsets
    var isCarousel: Bool
    var itemSpacing: CGFloat
    let layout: CollectionHStackLayout
    var onReachedLeadingSide: () -> Void
    var onReachedLeadingSideOffset: CollectionHStackEdgeOffset
    var onReachedTrailingEdge: () -> Void
    var onReachedTrailingEdgeOffset: CollectionHStackEdgeOffset
    var proxy: CollectionHStackProxy
    var scrollBehavior: CollectionHStackScrollBehavior
    let viewProvider: (Element) -> any View

    init(
        id: KeyPath<Element, ID>,
        allowBouncing: Bool = true,
        allowScrolling: Bool = true,
        clipsToBounds: Bool = defaultClipsToBounds,
        data: Data,
        dataPrefix: Int? = nil,
        didScrollToItems: @escaping ([Element]) -> Void = { _ in },
        insets: EdgeInsets = .init(top: 0, leading: defaultHorizontalInset, bottom: 0, trailing: defaultHorizontalInset),
        isCarousel: Bool = false,
        itemSpacing: CGFloat = defaultItemSpacing,
        layout: CollectionHStackLayout,
        onReachedLeadingSide: @escaping () -> Void = {},
        onReachedLeadingSideOffset: CollectionHStackEdgeOffset = .columns(0),
        onReachedTrailingEdge: @escaping () -> Void = {},
        onReachedTrailingEdgeOffset: CollectionHStackEdgeOffset = .columns(0),
        proxy: CollectionHStackProxy = .init(),
        scrollBehavior: CollectionHStackScrollBehavior = .continuous,
        viewProvider: @escaping (Element) -> any View
    ) {
        self.id = id
        self.allowBouncing = allowBouncing
        self.allowScrolling = allowScrolling
        self.clipsToBounds = clipsToBounds
        self.data = data
        self.dataPrefix = dataPrefix
        self.didScrollToItems = didScrollToItems
        self.insets = insets
        self.isCarousel = isCarousel
        self.itemSpacing = itemSpacing
        self.layout = layout
        self.onReachedLeadingSide = onReachedLeadingSide
        self.onReachedLeadingSideOffset = onReachedLeadingSideOffset
        self.onReachedTrailingEdge = onReachedTrailingEdge
        self.onReachedTrailingEdgeOffset = onReachedTrailingEdgeOffset
        self.proxy = proxy
        self.scrollBehavior = scrollBehavior
        self.viewProvider = viewProvider
    }

    public var body: some View {
        ZStack {
            SizeObserverView(sizeObserver: sizeObserver)
                .frame(height: 1)

            BridgeView(
                id: id,
                allowBouncing: allowBouncing,
                allowScrolling: allowScrolling,
                clipsToBounds: clipsToBounds,
                data: data,
                dataPrefix: dataPrefix ?? 0,
                didScrollToItems: didScrollToItems,
                insets: insets,
                isCarousel: isCarousel,
                itemSpacing: itemSpacing,
                layout: layout,
                onReachedLeadingEdge: onReachedLeadingSide,
                onReachedLeadingEdgeOffset: onReachedLeadingSideOffset,
                onReachedTrailingEdge: onReachedTrailingEdge,
                onReachedTrailingEdgeOffset: onReachedTrailingEdgeOffset,
                proxy: proxy,
                scrollBehavior: scrollBehavior,
                sizeObserver: sizeObserver,
                viewProvider: viewProvider,
                sizeBinding: $contentSize
            )
            .frame(height: contentSize.height)
        }
    }
}
