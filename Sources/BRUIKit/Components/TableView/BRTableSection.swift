//
//  BRTableSection.swift
//  BRUIKit
//
//  Created by BR on 2025/8/6.
//

import UIKit

public class BRTableSection {
        
    public var headerTitle: String?
    public var footerTitle: String?
    public var headerView: (() -> UIView)?
    public var footerView: (() -> UIView)?
    public var rows: [BRTableRow] = []
    
    
    public init(
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        headerView: (() -> UIView)? = nil,
        footerView: (() -> UIView)? = nil
    ) {
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.headerView = headerView
        self.footerView = footerView
    }
    
    
    public init(
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        headerView: (() -> UIView)? = nil,
        footerView: (() -> UIView)? = nil,
        @BRTableRowBuilder _ content: () -> [BRTableRow]
    ) {
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.headerView = headerView
        self.footerView = footerView
        self.rows = content()
    }

}


@resultBuilder
struct BRTableRowBuilder {
    static func buildBlock(_ components: BRTableRow...) -> [BRTableRow] {
        components
    }

    static func buildOptional(_ component: [BRTableRow]?) -> [BRTableRow] {
        component ?? []
    }

    static func buildEither(first component: [BRTableRow]) -> [BRTableRow] {
        component
    }

    static func buildEither(second component: [BRTableRow]) -> [BRTableRow] {
        component
    }

    static func buildArray(_ components: [[BRTableRow]]) -> [BRTableRow] {
        components.flatMap { $0 }
    }
}

