//
//  LayoutSection.swift
//  CompositionalLayoutDSL
//
//  Created by Alexandre Podlewski on 07/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import UIKit

/// A type that represents a section in a compositional layout and provides
/// modifiers to configure sections.
///
/// You create custom sections by declaring types that conform to the ``LayoutSection``
/// protocol. Implement the required ``layoutSection`` computed property to
/// provide the content and configuration for your custom section.
///
///     struct MySection: LayoutSection {
///         var layoutSection: LayoutSection {
///             Section {
///                 HGroup(count: 2) { Item() }
///             }
///             .boundarySupplementaryItems {
///                 BoundarySupplementaryItem(elementKind: "kind")
///             }
///             .contentInsets(horizontal: 20, vertical: 8)
///         }
///     }
///
public protocol LayoutSection {
    var layoutSection: LayoutSection { get }
}

extension LayoutSection {

    /// Configure the amount of space between the groups in the section.
    public func interGroupSpacing(_ spacing: CGFloat) -> LayoutSection {
        valueModifier(spacing, keyPath: \.interGroupSpacing)
    }

    /// Configure the boundary to reference when defining content insets.
    ///
    /// This represents the reference point to use when defining contentInsets.
    ///
    /// The default value of this property is `UIContentInsetsReference.automatic`,
    /// which means the section follows the layout configuration’s `contentInsetsReference`.
    @available(iOS 14.0, tvOS 14.0, *)
    public func contentInsetsReference(_ reference: UIContentInsetsReference) -> LayoutSection {
        valueModifier(reference, keyPath: \.contentInsetsReference)
    }

    /// Configure the section's scrolling behavior in relation to the main layout axis.
    ///
    /// The default value of this property is `UICollectionLayoutSectionOrthogonalScrollingBehavior.none`,
    /// which means the section lays out its content along the main axis of its layout, defined by
    /// the layout configuration's `scrollDirection` property. Set a different value for this
    /// property to get the section to lay out its content orthogonally to the main layout axis.
    public func orthogonalScrollingBehavior(
        _ orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior
    ) -> LayoutSection {
        valueModifier(orthogonalScrollingBehavior, keyPath: \.orthogonalScrollingBehavior)
    }

    /// Add an array of the supplementary items that are associated with the boundary edges of
    /// the section, such as headers and footers.
    public func boundarySupplementaryItems(
        @LayoutBoundarySupplementaryItemBuilder
        _ boundarySupplementaryItems: () -> [LayoutBoundarySupplementaryItem]
    ) -> LayoutSection {
        let boundarySupplementaryItems = boundarySupplementaryItems()
            .map(BoundarySupplementaryItemBuilder.make(from:))
        return valueModifier {
            $0.boundarySupplementaryItems.append(contentsOf: boundarySupplementaryItems)
        }
    }

    /// Configure if the section's supplementary items follow the specified content insets for the section.
    ///
    /// The default value of this property is true.
    public func supplementariesFollowContentInsets(
        _ supplementariesFollowContentInsets: Bool
    ) -> LayoutSection {
        valueModifier(supplementariesFollowContentInsets, keyPath: \.supplementariesFollowContentInsets)
    }

    /// Install a closure called before each layout cycle to allow modification of the items in
    /// the section immediately before they are displayed.
    public func visibleItemsInvalidationHandler(
        _ visibleItemsInvalidationHandler: NSCollectionLayoutSectionVisibleItemsInvalidationHandler?
    ) -> LayoutSection {
        valueModifier(visibleItemsInvalidationHandler, keyPath: \.visibleItemsInvalidationHandler)
    }

    /// Add an array of the decoration items that are anchored to the section, such as
    /// background decoration views.
    public func decorationItems(
        @LayoutDecorationItemBuilder _ decorationItems: () -> [LayoutDecorationItem]
    ) -> LayoutSection {
        let decorationItems = decorationItems().map(DecorationItemBuilder.make(from:))
        return valueModifier { $0.decorationItems.append(contentsOf: decorationItems) }
    }
}

extension LayoutSection {

    // MARK: - Content Insets

    /// Configure the amount of space between the content of the section and its boundaries.
    public func contentInsets(value: CGFloat) -> LayoutSection {
        return contentInsets(top: value, leading: value, bottom: value, trailing: value)
    }

    /// Configure the amount of space between the content of the section and its boundaries.
    public func contentInsets(horizontal: CGFloat = 0, vertical: CGFloat = 0) -> LayoutSection {
        return contentInsets(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }

    /// Configure the amount of space between the content of the section and its boundaries.
    public func contentInsets(
        top: CGFloat = 0,
        leading: CGFloat = 0,
        bottom: CGFloat = 0,
        trailing: CGFloat = 0
    ) -> LayoutSection {
        contentInsets(NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing))
    }

    /// Configure the amount of space between the content of the section and its boundaries.
    public func contentInsets(_ insets: NSDirectionalEdgeInsets) -> LayoutSection {
        valueModifier(insets, keyPath: \.contentInsets)
    }
}
