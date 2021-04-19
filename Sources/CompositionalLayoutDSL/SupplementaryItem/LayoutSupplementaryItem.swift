//
//  LayoutSupplementaryItem.swift
//  CompositionalLayoutDSL
//
//  Created by Alexandre Podlewski on 07/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import UIKit

public protocol LayoutSupplementaryItem: LayoutItem {
    var layoutSupplementaryItem: LayoutSupplementaryItem { get }
}

public extension LayoutSupplementaryItem {
    // MARK: - LayoutItem

    var layoutItem: LayoutItem { self }
}

extension HasSupplementaryItemProperties {
    public func zIndex(zIndex: Int) -> Self {
        with(self) { $0.zIndex = zIndex }
    }
}
