//
//  BRLayout.swift
//  BRUIKit
//
//  Created by BR on 2025/3/29.
//

import UIKit
import BRFoundation


/// BRLayout - 提供 AutoLayout 功能封裝
///
/// - DSL 語法
///
/// ``` swift
/// // 系統原生
/// NSLayoutConstraint.activate([
///     button.widthAnchor.constraint(equalToConstant: 260),
///     button.heightAnchor.constraint(equalToConstant: 34),
/// ])
///
/// // BRLayout
/// layout.activate {
///     button.widthAnchor.constraint(equalToConstant: 260)
///     button.heightAnchor.constraint(equalToConstant: 34)
/// }
/// ```
///
/// - 約束儲存 / 更新
///     - 僅支援透過 BRLayout 啟動約束時使用
///     - 啟動約束時添加 `.br.saved("id")` 即可透過 id 儲存約束
///     - 可透過 id 編輯儲存的約束
///
/// ``` swift
///
/// private extension String {
///     static let identifier = "identifier"
/// }
///
/// let layout = BRLayout
///
/// layout.activate {
///     button.widthAnchor.constraint(equalToConstant: 260).br.saved(.identifier)
///     button.heightAnchor.constraint(equalToConstant: 34)
/// }
///
/// // Content 調整成 250
/// layout.setContent(250, for: .identifier)
///
/// // Multiplier 調整成 0.8
/// layout.setMultiplier(0.8, for: .identifier)
/// ```
///
/// - priority
///     - 允許在啟動約束時設定 priority
/// ``` swift
/// layout.activate {
///     button.widthAnchor.constraint(equalToConstant: 260).br.priority(.defaultHigh)
///     button.heightAnchor.constraint(equalToConstant: 34)
/// }
/// ```
public class BRLayout {
    
    public private(set) var constraints: [String: NSLayoutConstraint] = [:]
    
    
    public init() {
    }
    
    
    // MARK: 啟動 / 關閉
    
    
    /// 啟動約束條件
    ///
    /// - 特性
    ///     - 自動處理 autoresizingMask
    ///     - 啟動約束時添加 `.br.saved("id")` 即可透過 id 儲存約束
    /// - 語法
    /// ``` swift
    /// layout.activate {
    ///     button.widthAnchor.constraint(equalToConstant: 260)
    ///     button.heightAnchor.constraint(equalToConstant: 34)
    /// }
    /// ```
    ///
    @MainActor public func activate(@BRConstraintBuilder _ builder: @MainActor () -> [NSLayoutConstraint]) {
        let constraintsList = builder()
        saveConstraintListIfNeeded(constraintsList)
        disableAutoresizingMask(constraintsList)
        NSLayoutConstraint.activate(constraintsList)
    }
    
    
    /// 關閉約束條件
    ///
    /// - 特性
    ///     - 會將約束從儲存管理中移除
    @MainActor public func deactivate(@BRConstraintBuilder _ builder: @MainActor () -> [NSLayoutConstraint]) {
        let constraintsList = builder()
        removeConstraints(constraintsList)
        NSLayoutConstraint.deactivate(constraintsList)
    }
    
    
    @MainActor private func disableAutoresizingMask(_ constraintsList: [NSLayoutConstraint]) {
        let views = constraintsList.compactMap { $0.firstItem as? UIView }
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    
    @MainActor private func saveConstraintListIfNeeded(_ constraintsList: [NSLayoutConstraint]) {
        let savedConstraintList = constraintsList.filter { $0.identifier != nil }
        savedConstraintList.forEach {
            replace($0, for: $0.identifier!)
        }
    }
    
    
    @MainActor private func removeConstraints(_ constraintsList: [NSLayoutConstraint]) {
        let identifiers = constraintsList.compactMap(\.identifier)
        identifiers.forEach { constraints[$0] = nil }
    }
    
    
    // MARK: 儲存管理
    
    
    /// 建立約束並儲存
    ///
    /// - 特性
    ///     - 需由使用者手動啟用
    @MainActor public func storeConstraint(_ constraint: NSLayoutConstraint, for id: String) {
        constraints[id] = constraint
        disableAutoresizingMask([constraint])
    }
    
    
    /// 設定新的 content
    @MainActor public func setContent(_ value: CGFloat, for id: String) {
        constraints[id]?.constant = value
    }
    
    
    /// 設定新的 multiplier
    @MainActor public func setMultiplier(_ value: CGFloat, for id: String) {
        constraints[id] = constraints[id]?.br.multiplier(value)
    }
    
    
    /// 替換儲存的約束
    ///
    /// - 特性
    ///     - 新約束將自動啟動
    ///     - 被替換的約束將關閉、移除管理
    @MainActor public func replace(_ constraint: NSLayoutConstraint, for id: String) {
        if let existingConstraint = constraints[id] {
            NSLayoutConstraint.deactivate([existingConstraint])
            constraints[id] = nil
        }
        constraints[id] = constraint
        NSLayoutConstraint.activate([constraint])
    }
    
    
}


@resultBuilder
public struct BRConstraintBuilder {
    @MainActor public static func buildBlock(_ builder: NSLayoutConstraint...) -> [NSLayoutConstraint] {
        builder
    }
}


extension BRWrapper where Base: NSLayoutConstraint {

    
    @MainActor public func multiplier(_ value: CGFloat) -> NSLayoutConstraint {
        NSLayoutConstraint.deactivate([base])
        
        let newLayout = NSLayoutConstraint.init(item: base.firstItem!,
                                                attribute: base.firstAttribute,
                                                relatedBy: base.relation,
                                                toItem: base.secondItem,
                                                attribute: base.secondAttribute,
                                                multiplier: value,
                                                constant: base.constant)
        newLayout.priority = base.priority
        newLayout.shouldBeArchived = base.shouldBeArchived
        newLayout.identifier = base.identifier
        NSLayoutConstraint.activate([newLayout])
        
        return newLayout
    }
    
    
    @MainActor public func priority(_ value: UILayoutPriority) -> NSLayoutConstraint {
        base.priority = value
        return base
    }
    
    
    @MainActor public func saved(_ id: String) -> NSLayoutConstraint {
        base.identifier = id
        return base
    }
    
    
}
