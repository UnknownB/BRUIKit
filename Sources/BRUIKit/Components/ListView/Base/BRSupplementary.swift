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
    
    public struct Content: Sendable {
        
        enum Storage: Sendable {
            case title(String)
            case view(key: String, type: UIView.Type, configure: @MainActor (UIView) -> Void)
        }
        let storage: Storage
        
        private init(storage: Storage) {
            self.storage = storage
        }
        
        public static func title(_ text: String) -> Self {
            .init(storage: .title(text))
        }
        
        public static func view<View: UIView>(key: String, type: View.Type, configure: @MainActor @escaping (View) -> Void) -> Self {
            .init(storage: .view(key: key, type: type) { reusableView in
                guard let view = reusableView as? View else { return }
                configure(view)
            })
        }
    }
    
    private enum Identity: Hashable {
        case title(Kind, String)
        case view(Kind, String, ObjectIdentifier)
        case none(Kind, UUID)
    }
    
    public let id = UUID()
    public let kind: Kind
    public let content: Content?
    
    
    private var identity: Identity {
        switch content?.storage {
        case .title(let text):
            return .title(kind, text)
            
        case .view(let key, let type, _):
            return .view(kind, key, ObjectIdentifier(type))
            
        case nil:
            return .none(kind, id)
        }
    }
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identity)
    }
    
    
    public static func == (lhs: BRSupplementary, rhs: BRSupplementary) -> Bool {
        return lhs.identity == rhs.identity
    }
    

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
    public var tableReusableView: UIView? {
        guard let content else { return nil }
        
        switch content.storage {
        case .title(_):
            return nil
        case .view(_, let type, let configure):
            let view = type.init()
            configure(view)
            return view
        }
    }
    
    
    // MARK: - CollectionView
    
    
    public var collViewType: UIView.Type {
        if case .view(_, let type, _) = content?.storage {
            return type
        }
        return BRReusableView.self
    }
    
    
    public var collReuseIdentifier: String {
        String(describing: collViewType)
    }
    
    
}

