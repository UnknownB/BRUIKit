//
//  BRRow.swift
//  BRUIKit
//
//  Created by BR on 2025/8/15.
//

import UIKit


/// BRRow 是 UITableView、UICollectionView 等清單元件的 (Row/Item) 資料層
///
/// ## 使用方式
///
/// - viewType
///     - 遵循 BRCellProtocol 協議的 UIView 類型
/// - model
///     - 遵循 BRCellProtocol 協議的 UIView 類型，其使用的 Model 物件
/// - onSelect
///     - 被選取的回調，接收對應的 model
///
public struct BRRow: Hashable, @unchecked Sendable {
    public let model: AnyHashable
    public let viewType: UIView.Type
    public let reuseIdentifier: String
    public var bindCell: @MainActor @Sendable (UIView) -> Void
    
    public let isEditable: Bool
    public let isMovable: Bool
    public let onSelect: (() -> Void)?
    
    
    // MARK: - Hashable
    
    
    public static func == (lhs: BRRow, rhs: BRRow) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(model)
    }
    
    
    // MARK: - Init

    
    /// - viewType
    ///     - 遵循 BRCellProtocol 協議的 UIView 類型
    /// - model
    ///     - 遵循 BRCellProtocol 協議的 UIView 類型，其使用的 Model 物件
    /// - onSelect
    ///     - 被選取的回調，接收對應的 model
    ///
    @MainActor
    public init <View: UIView & BRCellProtocol> (
        _ viewType: View.Type,
        model: View.Model,
        isEditable: Bool = true,
        isMovable: Bool = true,
        onSelect: ((View.Model) -> Void)? = nil
    ) {
        self.model = model
        self.viewType = viewType
        self.reuseIdentifier = String(describing: viewType)
        
        bindCell = { view in
            if let cell = view as? View {
                cell.bind(with: model)
            }
        }
        
        self.isEditable = isEditable
        self.isMovable = isMovable
        
        self.onSelect = onSelect.map { callback in
            { callback(model) }
        }
    }
    
    
    /// 批量建立 BRRow 物件
    @MainActor
    public static func forEach <View: UIView & BRCellProtocol, Models: Swift.Collection> (
        _ viewType: View.Type,
        models: Models,
        isEditable: Bool = true,
        isMovable: Bool = true,
        onSelect: ((View.Model) -> Void)? = nil
    ) -> [BRRow] where Models.Element == View.Model {
        models.map { BRRow(viewType, model: $0, onSelect: onSelect) }
    }
    
    
    // MARK: - 快速建立

    
    /// 建立系統原始 tableView Cell UI 樣式
    @MainActor
    public static func tableCell(_ text: String, onSelect: ((BRTableCellModel) -> Void)? = nil) -> BRRow {
        .init(BRTableCell.self, model: BRTableCellModel(text), onSelect: onSelect)
    }
    
    
    /// 建立系統原始 collection ListContent UI 樣式
    @MainActor
    public static func collCell(_ text: String, onSelect: ((BRCollectionCellModel) -> Void)? = nil) -> BRRow {
        .init(BRCollectionCell.self, model: BRCollectionCellModel(text), onSelect: onSelect)
    }
    
    
}
