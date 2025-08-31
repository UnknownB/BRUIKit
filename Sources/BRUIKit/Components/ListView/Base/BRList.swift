//
//  BRList.swift
//  BRUIKit
//
//  Created by BR on 2025/8/18.
//

import UIKit


/// BRList 是 UITableView、UICollectionView 等清單元件的資料入口
///
/// ## DSL
///
/// - 提供 DSL Builder 建立資料結構
///
/// ``` swift
/// let list = BRList {
///     BRSection(header: "Section 1") {
///         BRRow.tableCell("Row 1")
///         BRRow.tableCell("Row 2")
///     }
///     BRSection(header: "Section 2") {
///         BRRow.tableCell("Row 1")
///         BRRow.tableCell("Row 2")
///     }
/// }
/// ```
///
public struct BRList {
    public var sections: [BRSection]

    public init(@BRListSectionBuilder _ builder: () -> [BRSection]) {
        self.sections = builder()
    }
}


//MARK: - Builder


@resultBuilder
public enum BRListSectionBuilder {
    public static func buildBlock(_ components: [BRSection]...) -> [BRSection] {
        components.flatMap { $0 }
    }
    
    public static func buildExpression(_ expr: BRSection) -> [BRSection] {
        [expr]
    }
    
    public static func buildExpression(_ expr: [BRSection]) -> [BRSection] {
        expr
    }
    
    public static func buildArray(_ components: [[BRSection]]) -> [BRSection] {
        components.flatMap { $0 }
    }
    
    public static func buildOptional(_ component: [BRSection]?) -> [BRSection] {
        component ?? []
    }
    
    public static func buildEither(first component: [BRSection]) -> [BRSection] {
        component
    }
    
    public static func buildEither(second component: [BRSection]) -> [BRSection] {
        component
    }
}

