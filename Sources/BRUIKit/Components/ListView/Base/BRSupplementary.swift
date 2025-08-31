//
//  BRSupplementary.swift
//  BRUIKit
//
//  Created by BR on 2025/8/20.
//

import UIKit


/// BRSupplementary 是 Section 資料層的輔助層級，用來封裝 header、footer 顯示資料
///
/// ## 使用方式
///
/// - kind
///     - Section 的 header or footer
/// - title
///     - 作為此結構的 Hashable 識別資訊，以及 header or footer 顯示文字
/// - viewType
///     - 遵循 BRCellReusableViewProtocol 的 UIView 類型，預設 nil 時，會走各自的預設元件
public struct BRSupplementary: Hashable, Sendable {
    
    public enum Kind: Sendable {
        case header
        case footer
    }
    
    public let kind: Kind
    public let title: String?
    private let viewType: BRReusableViewProtocol.Type?
    
    
    // MARK: - Hashable
    
    
    public static func == (lhs: BRSupplementary, rhs: BRSupplementary) -> Bool {
        lhs.title == rhs.title
    }
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    
    // MARK: - Init
    
    
    /// - kind
    ///     - Section 的 header or footer
    /// - title
    ///     - 作為此結構的 Hashable 識別資訊，以及 header or footer 顯示文字
    /// - viewType
    ///     - 遵循 BRCellReusableViewProtocol 的 UIView 類型，預設 nil 時，會走各自的預設元件
    public init(kind: Kind, title: String?, viewType: BRReusableViewProtocol.Type?) {
        self.kind = kind
        self.title = title
        self.viewType = viewType
    }
    
    
    // MARK: - TableView
    
    
    public var tableViewType: BRReusableViewProtocol.Type? {
        viewType
    }
    
    
    @MainActor
    public var tableReusableView: BRReusableViewProtocol? {
        guard let viewType else {
            return nil
        }
        let view = viewType.init()
        view.title = title
        return view
    }
    
    
    // MARK: - CollectionView
    
    
    public var collViewType: BRReusableViewProtocol.Type {
        viewType ?? BRReusableView.self
    }
    
    
    public var collReuseIdentifier: String {
        String(describing: collViewType)
    }
    
    
}

