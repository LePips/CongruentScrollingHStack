import OrderedCollections
import OSLog
import SwiftUI

// TODO: comments/documentation
// TODO: vertical insets? (for shadows)
// TODO: proxy for index selection/paging
// TODO: did scroll to item with index row?
// TODO: need to determine way for single item sizing item init (first item init?)
// - placeholder views?
// - empty view?
// TODO: fix scroll position on layout change
// TODO: allow passing height info and widths are calculated instead?
// TODO: prefetch items rules
// - cancel?
// - must be fresh
// - turn off
// TODO: cols + rows
// TODO: continuousLeadingBoundary/item paging behavior every X items?
// TODO: different default insets/spacing for tvOS
// TODO: tvOS spacing issue with Button focus
// - can be solved with padding but should do that here (see vertical insets)?
// TODO: alwaysBounceHorizontal setting
// TODO: should prefetch use row instead of hashvalue?

class UICongruentScrollView<Item: Hashable>: UIView, 
                                                UICollectionViewDataSource,
                                                UICollectionViewDelegate,
                                                UICollectionViewDelegateFlowLayout,
                                             UICollectionViewDataSourcePrefetching {

    private let logger = Logger()
    
    private var wrapAround = true
    private var effectiveItemCount = 100

    private var dataSource: UICollectionViewDiffableDataSource<Int, Int>!
    private let didReachTrailingSide: () -> Void
    private let didReachTrailingSideOffset: CGFloat
    private let didScrollToItems: ([Item]) -> Void
    private var effectiveWidth: CGFloat
    private let horizontalInset: CGFloat
    private var items: Binding<OrderedSet<Item>>
    private let itemSpacing: CGFloat
    private var itemSize: CGSize!
    private let layout: CongruentScrollingHStackLayout
    private var prefetchedViewCache: [Int: UIHostingController<AnyView>]
    private let scrollBehavior: CongruentScrollingHStackScrollBehavior
    private var size: CGSize {
        didSet {
            itemSize = itemSize(for: layout)
            invalidateIntrinsicContentSize()
            collectionView.collectionViewLayout.prepare()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    private let viewProvider: (Item) -> any View

    // MARK: init

    init(
        didReachTrailingSide: @escaping () -> Void,
        didReachTrailingSideOffset: CGFloat,
        didScrollToItems: @escaping ([Item]) -> Void,
        horizontalInset: CGFloat,
        items: Binding<OrderedSet<Item>>,
        itemSpacing: CGFloat,
        layout: CongruentScrollingHStackLayout,
        scrollBehavior: CongruentScrollingHStackScrollBehavior,
        sizeObserver: SizeObserver,
        viewProvider: @escaping (Item) -> any View
    ) {
        self.didReachTrailingSide = didReachTrailingSide
        self.didReachTrailingSideOffset = didReachTrailingSideOffset
        self.didScrollToItems = didScrollToItems
        self.effectiveWidth = 0
        self.horizontalInset = horizontalInset
        self.items = items
        self.itemSpacing = itemSpacing
        self.layout = layout
        self.prefetchedViewCache = [:]
        self.scrollBehavior = scrollBehavior
        self.size = .zero
        self.viewProvider = viewProvider

        super.init(frame: .zero)

        sizeObserver.onSizeChanged = { newSize in
            self.effectiveWidth = newSize.width
            self.layoutSubviews()
        }

        updateItems(with: items)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        size
    }

    private lazy var collectionView: UICollectionView = {

        let layout = scrollBehavior.flowLayout
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(
            top: 0,
            left: horizontalInset,
            bottom: 0,
            right: horizontalInset
        )
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HostingCollectionViewCell.self, forCellWithReuseIdentifier: HostingCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = nil
        collectionView.alwaysBounceHorizontal = true


        if scrollBehavior == .itemPaging {
            collectionView.decelerationRate = .fast
        }

        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        return collectionView
    }()

    // MARK: layoutSubviews

    override func layoutSubviews() {
        super.layoutSubviews()

        size = computeSize()
        updateItems(with: items)
    }

    private func computeSize() -> CGSize {

        let height: CGFloat

        switch layout {
        case .columns, .fractionalColumns, .minimumWidth:
            let itemWidth = itemSize(for: layout).width
            height = singleItemSize(width: itemWidth).height
        case .selfSizingSameSize, .selfSizingVariadicWidth:
            height = singleItemSize().height
        }

        return CGSize(width: effectiveWidth, height: height)
    }

    private func singleItemSize(width: CGFloat? = nil) -> CGSize {

        guard !items.wrappedValue.isEmpty else { return .init(width: width ?? 0, height: 0) }

        let view: AnyView

        if let width, width > 0 {
            view = AnyView(viewProvider(items.wrappedValue[0]).frame(width: width))
        } else {
            view = AnyView(viewProvider(items.wrappedValue[0]))
        }

        let singleItem = UIHostingController(rootView: view)
        singleItem.view.sizeToFit()
        return singleItem.view.bounds.size
    }

    func updateItems(with newItems: Binding<OrderedSet<Item>>) {

        items = newItems
        collectionView.reloadData()

//        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
//        snapshot.appendSections([0])
//        snapshot.appendItems(newItems.wrappedValue.map(\.hashValue))
//        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }

    // MARK: UIScrollViewDelegate

    // TODO: state handling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if wrapAround {
            let reachPosition = scrollView.contentSize.width - scrollView.bounds.width * 2
            let reachedTrailing = scrollView.contentOffset.x >= reachPosition
            
            if reachedTrailing {
                effectiveItemCount += 100
                collectionView.reloadData()
            }
        } else {
            let reachPosition = scrollView.contentSize.width - scrollView.bounds.width - didReachTrailingSideOffset
            let reachedTrailing = scrollView.contentOffset.x >= reachPosition

            if reachedTrailing {
                didReachTrailingSide()
            }
        }
    }

    // TODO: should probably be instead when items just became visible / make separate method?
    // TODO: remove items on edges in certain scrollBehaviors + layouts?
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let visibleItems = collectionView
            .indexPathsForVisibleItems
            .map { items.wrappedValue[$0.row % items.wrappedValue.count] }

        didScrollToItems(visibleItems)
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("number of items: \(effectiveItemCount)")
        
        if wrapAround {
            return effectiveItemCount
        } else {
            return items.wrappedValue.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HostingCollectionViewCell.reuseIdentifier, for: indexPath) as! HostingCollectionViewCell
        let item = self.items.wrappedValue[indexPath.row % items.wrappedValue.count]
        
        if let premade = self.prefetchedViewCache[item.hashValue] {
            cell.setupHostingView(premade: premade)
            self.prefetchedViewCache.removeValue(forKey: item.hashValue)
        } else {
            cell.setupHostingView(with: self.viewProvider(item))
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        if case CongruentScrollingHStackLayout.selfSizingVariadicWidth = layout {

            let item = items.wrappedValue[indexPath.row]

            if let prefetch = prefetchedViewCache[item.hashValue] {
                prefetch.view.sizeToFit()
                return prefetch.view.bounds.size
            } else {
                let view: AnyView = AnyView(viewProvider(item))
                let singleItem = UIHostingController(rootView: view)
                singleItem.view.sizeToFit()
                return singleItem.view.bounds.size
            }
        } else {
            if let itemSize {
                return itemSize
            } else {
                let s = itemSize(for: layout)
                itemSize = s
                return s
            }
        }
    }

    private func itemSize(for layout: CongruentScrollingHStackLayout) -> CGSize {

        switch layout {
        case let .columns(columns, trailingInset: trailingInset):
            let width = itemWidth(columns: CGFloat(columns), trailingInset: trailingInset)
            guard width >= 0 else { return CGSize(width: 0, height: size.height) }
            return CGSize(width: width, height: size.height)
        case let .fractionalColumns(columns):
            let width = itemWidth(columns: columns)
            guard width >= 0 else { return CGSize(width: 0, height: size.height) }
            return CGSize(width: width, height: size.height)
        case let .minimumWidth(width):
            let width = itemWidth(minWidth: width)
            return CGSize(width: width, height: size.height)
        case .selfSizingSameSize, .selfSizingVariadicWidth:
            return singleItemSize()
        }
    }

    private func itemWidth(columns: CGFloat, trailingInset: CGFloat = 0) -> CGFloat {

        guard columns > 0 else {
            logger.warning("Given `columns` is less than or equal to 0, setting to single column display instead.")
            return itemWidth(columns: 1)
        }

        let itemSpaces: CGFloat
        let sectionInsets: CGFloat

        if floor(columns) == columns {
            itemSpaces = columns - 1
            sectionInsets = collectionView.flowLayout.sectionInset.horizontal
        } else {
            itemSpaces = floor(columns)
            sectionInsets = collectionView.flowLayout.sectionInset.left
        }

        let itemSpacing = itemSpaces * collectionView.flowLayout.minimumInteritemSpacing
        let totalNegative = sectionInsets + itemSpacing + trailingInset

        return (effectiveWidth - totalNegative) / columns
    }

    private func itemWidth(minWidth: CGFloat) -> CGFloat {

        guard minWidth > 0 else {
            logger.warning("Given `minWidth` is less than or equal to 0, setting to single column display instead.")
            return itemWidth(columns: 1)
        }

        // Ensure that each item has a given minimum width
        let layout = collectionView.flowLayout
        var columns = CGFloat(Int((effectiveWidth - layout.sectionInset.horizontal) / minWidth))

        guard columns != 1 else { return itemWidth(columns: 1) }

        let preItemSpacing = (columns - 1) * layout.minimumInteritemSpacing

        let totalNegative = layout.sectionInset.horizontal + preItemSpacing

        // if adding negative space with current column count would result in column sizes < minWidth
        if columns * minWidth + totalNegative > bounds.width {
            columns -= 1
        }

        return itemWidth(columns: columns)
    }

    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        false
    }

    // MARK: UICollectionViewDataSourcePrefetching

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {

//        let fetchedItems: [Item] = indexPaths.map { items.wrappedValue[$0.row] }
//
//        for item in fetchedItems where !prefetchedViewCache.keys.contains(item.hashValue) {
//            let premade = UIHostingController(rootView: AnyView(viewProvider(item)))
//            prefetchedViewCache[item.hashValue] = premade
//        }
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {

//        let fetchedItems: [Item] = indexPaths.map { items.wrappedValue[$0.row] }
//
//        for item in fetchedItems where !prefetchedViewCache.keys.contains(item.hashValue) {
//            prefetchedViewCache.removeValue(forKey: item.hashValue)
//        }
    }
}
