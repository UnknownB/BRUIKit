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
    
    private enum Identity: Hashable {
        case supplementary(BRSupplementary?, BRSupplementary?)
        case none(UUID)
    }
    
    
    public let id = UUID()
    public var header: BRSupplementary
    public var footer: BRSupplementary
    public var rows: [BRRow]
    
    
    private var identity: Identity {
        let header = header.content == nil ? nil : header
        let footer = footer.content == nil ? nil : footer
        
        if header == nil && footer == nil {
            return .none(id)
        }
        return .supplementary(header, footer)
    }
    
    
    // MARK: - Hashable
    
    
    public static func == (lhs: BRSection, rhs: BRSection) -> Bool {
        lhs.identity == rhs.identity
    }
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identity)
    }
    
    
    // MARK: - Init
    
    
    /// - header
    ///     - 指定 header title or view，預設為 nil
    /// - footer
    ///     - 指定 footer title or view，預設為 nil
    public init(header: BRSupplementary.Content? = nil, footer: BRSupplementary.Content? = nil, @BRListBuilder builder: () -> [BRRow]
    ) {
        self.header = .init(kind: .header, content: header)
        self.footer = .init(kind: .footer, content: footer)
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
