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
    
    public enum Content: Hashable, Sendable {
        case title(String)
        case view(key: String, type: BRReusableViewProtocol.Type, configure: @Sendable (any BRReusableViewProtocol) -> Void)
        

        public func hash(into hasher: inout Hasher) {
            switch self {
            case .title(let text):
                hasher.combine("title")
                hasher.combine(text)
            case .view(let key, let type, _):
                hasher.combine("view")
                hasher.combine(key)
                hasher.combine(String(describing: type))
            }
        }
        
        public static func == (lhs: Content, rhs: Content) -> Bool {
            switch (lhs, rhs) {
            case (.title(let lt), .title(let rt)):
                return lt == rt
            case (.view, .view):
                return true
            default:
                return false
            }
        }
    }
    
    public let kind: Kind
    public let content: Content?
    

    // MARK: - Init
    
    
    /// - kind
    ///     - Section 的 header or footer
    /// - content
    ///     - 作為此結構的 Hashable 識別資訊，以及 header or footer 顯示元件
    public init(kind: Kind, content: Content? = nil) {
        self.kind = kind
        self.content = content
    }
    
    
    // MARK: - TableView
    
    
    @MainActor
    public var tableReusableView: (any BRReusableViewProtocol)? {
        guard let content else { return nil }
        
        switch content {
        case .title(_):
            return nil
        case .view(_, let type, let configure):
            let view = type.init()
            configure(view)
            return view
        }
    }
    
    
    // MARK: - CollectionView
    
    
    public var collViewType: BRReusableViewProtocol.Type {
        guard case .view(_, let type, _) = content else {
            return BRReusableView.self
        }
        return type
    }
    
    
    public var collReuseIdentifier: String {
        String(describing: collViewType)
    }
    
    
}

