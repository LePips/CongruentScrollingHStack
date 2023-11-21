import UIKit

// TODO: accustom for item sizes > collection view width?
// TODO: accustom for item spacing which will make no other items appear on targetContentOffset?
// TODO: centered scroll behavior

// get contentoffset from scrollview begin dragging
// manually compute offset from item widths

public enum CongruentScrollingHStackScrollBehavior {

    case columnPaging
    case continuous
    case continuousLeadingEdge

    var flowLayout: UICollectionViewFlowLayout {
        switch self {
        case .columnPaging:
            ColumnPagingFlowLayout()
        case .continuous:
            UICollectionViewFlowLayout()
        case .continuousLeadingEdge:
            ContinuousLeadingEdgeFlowLayout()
        }
    }
}

/// A `UICollectionViewFlowLayout` that aligns with a column of items
protocol ColumnAlignedLayout: UICollectionViewFlowLayout {

    // Used for determining the correct column to align against
    var rows: Int { get set }
}

/// A `UICollectionViewFlowLayout` that will stride along columns
protocol ColumnStridableLayout: UICollectionViewFlowLayout {

    var step: Int { get set }
}

protocol ScrollViewStatefulLayout: UICollectionViewFlowLayout {

    var scrollViewWillBeginDraggingContentOffset: CGFloat { get set }
}

/// Similar to `UICollectionLayoutSectionOrthogonalScrollingBehavior.continuousGroupLeadingBoundary`, where scrolling will align
/// along the leading boundary of a column minus the section's leading inset. If the proposed target content offset is the last column,
/// the last column will be aligned along its trailing edge with the section's trailing inset.
///
/// Column Center Scroll Behavior:
///   If the proposed target content offset is less than half of the leading columns's center, scrolling will
///   with that columns's leading edge. Otherwise, scrolling will align with the next columns's leading edge.
class ContinuousLeadingEdgeFlowLayout: UICollectionViewFlowLayout, ColumnAlignedLayout {

    var rows: Int = 1

    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {

        let targetRect = CGRect(
            x: proposedContentOffset.x,
            y: 0,
            width: collectionView!.bounds.size.width,
            height: collectionView!.bounds.size.height
        )

        let layoutAttributes = layoutAttributesForElements(in: targetRect)!

        // TODO: remove when allowing item sizes > collection view width
        guard layoutAttributes.count > 1 else { return proposedContentOffset }

        // allow scrolling to last element
        if proposedContentOffset.x == collectionView!.contentSize.width - collectionView!.bounds.width {
            return proposedContentOffset
        }

        let startOfColumnAttributes = layoutAttributes
            .striding(by: rows)

        // TODO: remove when allowing item sizes > collection view width
        guard startOfColumnAttributes.count > 1 else { return proposedContentOffset }

        let m: CGFloat

        if proposedContentOffset.x > startOfColumnAttributes[0].center.x {
            m = startOfColumnAttributes[1].frame.minX
        } else {
            m = startOfColumnAttributes[0].frame.minX
        }

        let leadingInset = collectionView!.flowLayout.sectionInset.left

        return CGPoint(
            x: m - leadingInset,
            y: proposedContentOffset.y
        )
    }
}

class ColumnPagingFlowLayout: UICollectionViewFlowLayout, ColumnAlignedLayout {

    var rows: Int = 1

    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {

        let targetRect = CGRect(
            x: collectionView!.contentOffset.x,
            y: 0,
            width: collectionView!.bounds.size.width,
            height: collectionView!.bounds.size.height
        )

        let layoutAttributes = layoutAttributesForElements(in: targetRect)!

        // TODO: remove when allowing item sizes > collection view width
        guard layoutAttributes.count > 1 else { return proposedContentOffset }

        // TODO: fix column choosing with items in rect
        let startOfColumnAttributes = layoutAttributes
            .striding(by: rows)

        // TODO: remove when allowing item sizes > collection view width
        guard startOfColumnAttributes.count > 1 else { return proposedContentOffset }

        let m: CGFloat

        if velocity.x > 0 {
            m = startOfColumnAttributes[1].frame.minX
        } else if velocity.x < 0 {
            m = startOfColumnAttributes[0].frame.minX
        } else if velocity.x == 0 {
            if proposedContentOffset.x > layoutAttributes[0].center.x {
                m = startOfColumnAttributes[1].frame.minX
            } else {
                m = startOfColumnAttributes[0].frame.minX
            }
        } else {
            m = startOfColumnAttributes[0].frame.minX
        }

        let leadingInset = collectionView!.flowLayout.sectionInset.left

        return CGPoint(
            x: m - leadingInset,
            y: proposedContentOffset.y
        )
    }
}
