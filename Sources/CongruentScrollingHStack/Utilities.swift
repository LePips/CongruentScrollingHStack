import DifferenceKit
import OrderedCollections
import SwiftUI

extension Int: ContentEquatable, ContentIdentifiable {}

public extension OrderedSet {

    @inlinable
    @discardableResult
    mutating func append(checkingContentsOf elements: some Sequence<Element>) -> Bool {
        var didContainDuplicate = false

        for item in elements {
            didContainDuplicate = append(item).inserted || didContainDuplicate
        }

        return didContainDuplicate
    }
}

extension UICollectionView {

    var flowLayout: UICollectionViewFlowLayout {
        collectionViewLayout as! UICollectionViewFlowLayout
    }

    var isAtMinContentOffset: Bool {
        contentOffset == .zero
    }

    var isAtMaxContentOffset: Bool {
        contentOffset == maxContentOffset
    }

    var maxContentOffset: CGPoint {
        CGPoint(
            x: contentSize.width - bounds.width,
            y: contentSize.height - bounds.height
        )
    }
}

extension UIEdgeInsets {

    var horizontal: CGFloat {
        left + right
    }

    var vertical: CGFloat {
        top + bottom
    }
}

extension View {

    func copy<Value>(modifying keyPath: WritableKeyPath<Self, Value>, to newValue: Value) -> Self {
        var copy = self
        copy[keyPath: keyPath] = newValue
        return copy
    }
}
