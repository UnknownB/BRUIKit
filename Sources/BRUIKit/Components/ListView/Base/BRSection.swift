//
//  BRListSection.swift
//  BRUIKit
//
//  Created by BR on 2025/8/18.
//

import UIKit


/// BRSection 是 UITableView、UICollectionView 等清單元件的 Section 資料層
///
/// ## 使用方式
///
/// - header
///     - 指定 header title，預設為 nil
/// - headerType
///     - 可指定遵循 BRCellReusableViewProtocol 協議的 UIView 類型，預設為系統原始 UI 樣式
/// - footer
///     - 指定 footer title，預設為 nil
/// - footerType
///     - 可指定遵循 BRCellReusableViewProtocol 協議的 UIView 類型，預設為系統原始 UI 樣式
public struct BRSection: Hashable, Sendable {
    public var header: BRSupplementary
    public var footer: BRSupplementary
    public var rows: [BRRow]
    
    
    // MARK: - Hashable
    
    
    public static func == (lhs: BRSection, rhs: BRSection) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(header)
        hasher.combine(footer)
    }
    
    
    // MARK: - Init
    
    
    /// - header
    ///     - 指定 header title，預設為 nil
    /// - headerType
    ///     - 可指定遵循 BRCellReusableViewProtocol 協議的 UIView 類型，預設為系統原始 UI 樣式
    /// - footer
    ///     - 指定 footer title，預設為 nil
    /// - footerType
    ///     - 可指定遵循 BRCellReusableViewProtocol 協議的 UIView 類型，預設為系統原始 UI 樣式
    public init(header: String? = nil, headerType: BRReusableViewProtocol.Type? = nil, footer: String? = nil, footerType: BRReusableViewProtocol.Type? = nil, @BRListBuilder builder: () -> [BRRow]
    ) {
        self.header = .init(kind: .header, title: header, viewType: headerType)
        self.footer = .init(kind: .footer, title: footer, viewType: footerType)
        self.rows = builder()
    }
}


//MARK: - Builder


@resultBuilder
public enum BRListBuilder {
    public static func buildBlock(_ components: [BRRow]...) -> [BRRow] {
        components.flatMap { $0 }
    }
    
    public static func buildExpression(_ expr: BRRow) -> [BRRow] {
        [expr]
    }
    
    public static func buildExpression(_ expr: [BRRow]) -> [BRRow] {
        expr
    }
    
    public static func buildArray(_ components: [[BRRow]]) -> [BRRow] {
        components.flatMap { $0 }
    }
    
    public static func buildOptional(_ component: [BRRow]?) -> [BRRow] {
        component ?? []
    }
    
    public static func buildEither(first component: [BRRow]) -> [BRRow] {
        component
    }
    
    public static func buildEither(second component: [BRRow]) -> [BRRow] {
        component
    }
}
