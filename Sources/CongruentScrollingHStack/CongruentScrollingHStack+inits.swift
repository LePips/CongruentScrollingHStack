import Foundation
import OrderedCollections
import SwiftUI

// TODO: look at macros?
// TODO: inits without binding
// - pass in any Sequence, log warning when items contain duplicates
// - make sure to check if sequence is a Set/OrderedSet, like OrderedSet does

// MARK: Binding<OrderedSet>

public extension CongruentScrollingHStack {

    init(
        items: Binding<OrderedSet<Item>>,
        columns: Int,
        columnTrailingInset: CGFloat = 0,
        horizontalInset: CGFloat = 15,
        spacing: CGFloat = 10,
        scrollBehavior: CongruentScrollingHStackScrollBehavior = .continuous,
        @ViewBuilder content: @escaping (Item) -> any View
    ) {
        self.init(
            horizontalInset: horizontalInset,
//            items: items,
            itemSpacing: spacing,
            layout: .columns(CGFloat(columns), trailingInset: columnTrailingInset),
            scrollBehavior: scrollBehavior,
            state: .constant(.items(items)),
            viewProvider: content
        )
    }

    init(
        items: Binding<OrderedSet<Item>>,
        columns: CGFloat,
        horizontalInset: CGFloat = 15,
        spacing: CGFloat = 10,
        scrollBehavior: CongruentScrollingHStackScrollBehavior = .continuous,
        @ViewBuilder content: @escaping (Item) -> any View
    ) {
        self.init(
            horizontalInset: horizontalInset,
//            items: items,
            itemSpacing: spacing,
            layout: .columns(columns, trailingInset: 0),
            scrollBehavior: scrollBehavior,
            state: .constant(.items(items)),
            viewProvider: content
        )
    }

    init(
        items: Binding<OrderedSet<Item>>,
        minWidth: CGFloat,
        inset: CGFloat = 15,
        spacing: CGFloat = 10,
        scrollBehavior: CongruentScrollingHStackScrollBehavior = .continuous,
        @ViewBuilder content: @escaping (Item) -> any View
    ) {
        self.init(
            horizontalInset: inset,
//            items: items,
            itemSpacing: spacing,
            layout: .minimumWidth(minWidth),
            scrollBehavior: scrollBehavior,
            state: .constant(.items(items)),
            viewProvider: content
        )
    }

    init(
        items: Binding<OrderedSet<Item>>,
        inset: CGFloat = 15,
        spacing: CGFloat = 10,
        scrollBehavior: CongruentScrollingHStackScrollBehavior = .continuous,
        variadicWidths: Bool = false,
        @ViewBuilder content: @escaping (Item) -> any View
    ) {
        self.init(
            horizontalInset: inset,
//            items: items,
            itemSpacing: spacing,
            layout: variadicWidths ? .selfSizingVariadicWidth : .selfSizingSameSize,
            scrollBehavior: scrollBehavior,
            state: .constant(.items(items)),
            viewProvider: content
        )
    }
}

// MARK: Range

// TODO: columns and mindWidth inits
public extension CongruentScrollingHStack where Item == Int {

    init(
        _ data: Range<Int>,
        inset: CGFloat = 15,
        spacing: CGFloat = 10,
        scrollBehavior: CongruentScrollingHStackScrollBehavior = .continuous,
        variadicWidths: Bool = false,
        @ViewBuilder content: @escaping (Item) -> any View
    ) {
        self.init(
            horizontalInset: inset,
//            items: .constant(OrderedSet(data)),
            itemSpacing: spacing,
            layout: variadicWidths ? .selfSizingVariadicWidth : .selfSizingSameSize,
            scrollBehavior: scrollBehavior,
            state: .constant(.items(.constant(OrderedSet(data)))),
            viewProvider: content
        )
    }

    init(
        _ data: Range<Int>,
        columns: Int,
        columnTrailingInset: CGFloat = 0,
        inset: CGFloat = 15,
        spacing: CGFloat = 10,
        scrollBehavior: CongruentScrollingHStackScrollBehavior = .continuous,
        @ViewBuilder content: @escaping (Item) -> any View
    ) {
        self.init(
            horizontalInset: inset,
//            items: .constant(OrderedSet(data)),
            itemSpacing: spacing,
            layout: .columns(CGFloat(columns), trailingInset: columnTrailingInset),
            scrollBehavior: scrollBehavior,
            state: .constant(.items(.constant(OrderedSet(data)))),
            viewProvider: content
        )
    }

    init(
        _ data: Range<Int>,
        columns: CGFloat,
        inset: CGFloat = 15,
        spacing: CGFloat = 10,
        scrollBehavior: CongruentScrollingHStackScrollBehavior = .continuous,
        @ViewBuilder content: @escaping (Item) -> any View
    ) {
        self.init(
            horizontalInset: inset,
//            items: .constant(OrderedSet(data)),
            itemSpacing: spacing,
            layout: .columns(columns, trailingInset: 0),
            scrollBehavior: scrollBehavior,
            state: .constant(.items(.constant(OrderedSet(data)))),
            viewProvider: content
        )
    }
    
    // MARK: stateful
    
    init(
        state: Binding<CongruentScrollingHStackState<Int>>,
        columns: Int,
        columnTrailingInset: CGFloat = 0,
        inset: CGFloat = 15,
        spacing: CGFloat = 10,
        scrollBehavior: CongruentScrollingHStackScrollBehavior = .continuous,
        @ViewBuilder content: @escaping (Item) -> any View
    ) {
        self.init(
            horizontalInset: inset,
//            items: .constant(OrderedSet(data)),
            itemSpacing: spacing,
            layout: .columns(CGFloat(columns), trailingInset: columnTrailingInset),
            scrollBehavior: scrollBehavior,
            state: state,
            viewProvider: content
        )
    }
}

// MARK: ClosedRange

public extension CongruentScrollingHStack where Item == Int {

    init(
        _ data: ClosedRange<Int>,
        inset: CGFloat = 15,
        spacing: CGFloat = 10,
        scrollBehavior: CongruentScrollingHStackScrollBehavior = .continuous,
        @ViewBuilder content: @escaping (Item) -> any View
    ) {
        self.init(
            horizontalInset: inset,
//            items: .constant(OrderedSet(data)),
            itemSpacing: spacing,
            layout: .selfSizingSameSize,
            scrollBehavior: scrollBehavior,
            state: .constant(.items(.constant(OrderedSet(data)))),
            viewProvider: content
        )
    }
}
