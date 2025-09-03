//
//  UIStackView+DSL.swift
//  BRUIKit
//
//  Created by BR on 2025/9/2.
//

import BRFoundation
import UIKit


public extension BRWrapper where Base: UIStackView {
    
    
    /// 設定 stackView 的排列方向 (horizontal: →, vertical: ↓)
    @MainActor
    @discardableResult
    func axis(_ axis: NSLayoutConstraint.Axis) -> Base {
        base.axis = axis
        return base
    }
    
    
    /// 設定 stackView 中子視圖之間的間距
    @MainActor
    @discardableResult
    func spacing(_ value: CGFloat) -> Base {
        base.spacing = value
        return base
    }
    
    
    /// 設定 arrangedSubview 與下個 arrangedSubview 的間距
    @MainActor
    @discardableResult
    @available(iOS 11.0, *)
    func customSpacing(_ spacing: CGFloat, after arrangedSubview: UIView) -> Base {
        base.setCustomSpacing(spacing, after: arrangedSubview)
        return base
    }
    
    
    /// 設定 stackView 中子視圖的對齊方式
    ///
    /// - fill
    ///     - 填滿空間，由 Auto Layout 決定
    /// - leading
    ///     - 子元件會靠 leading（左/右取決於語系） 對齊
    ///     - → horizontal 會貼齊頂部
    /// - trailing
    ///     - 子元件靠 trailing 對齊
    ///     - → horizontal 會貼齊底部
    /// - center
    ///     - ↓ vertical 水平置中
    ///     - → horizontal 垂直置中
    /// - top
    ///     - → horizontal 時貼齊頂部
    /// - bottom
    ///     - → horizontal 時貼齊底部
    /// - firstBaseline
    ///     - → horizontal 時對齊第一行文字的 baseline
    /// - lastBaseline
    ///     - → horizontal 時對齊最後一行文字的 baseline
    @MainActor
    @discardableResult
    func alignment(_ alignment: UIStackView.Alignment) -> Base {
        base.alignment = alignment
        return base
    }
    
    
    /// 設定 stackView 如何分配子視圖的大小
    ///
    /// - fill
    ///     - 填滿空間，子視圖大小依照 intrinsic (元件推薦尺寸) 或 Auto Layout 決定
    /// - fillEqually
    ///     - 平均分配，所有子視圖一樣大
    /// - fillProportionally
    ///     - 依比例分配，照 intrinsic 大小等比縮放
    /// - equalSpacing
    ///     - 保持間距一致，子視圖大小不變
    /// - equalCentering
    ///     - 子視圖中心點間距一致
    @MainActor
    @discardableResult
    func distribution(_ distribution: UIStackView.Distribution) -> Base {
        base.distribution = distribution
        return base
    }
    
    
    /// 設定 stackView 的內邊距（`layoutMargins`），並自動啟用 `isLayoutMarginsRelativeArrangement`。
    @MainActor
    @discardableResult
    func margins(_ insets: UIEdgeInsets) -> Base {
        base.layoutMargins = insets
        base.isLayoutMarginsRelativeArrangement = true
        return base
    }
    
    
    /// 設定 stackView 是否在排列 arrangedSubviews 時考慮 layoutMargins
    @MainActor
    @discardableResult
    func layoutMarginsRelative(_ enabled: Bool) -> Base {
        base.isLayoutMarginsRelativeArrangement = enabled
        return base
    }
    
    
    // MARK: - ArrangedSubviews
    
    
    /// 將一個子視圖加入 stackView 的 `arrangedSubviews`
    @MainActor
    @discardableResult
    func addArranged(_ view: UIView, spacing: CGFloat? = nil) -> Base {
        base.addArrangedSubview(view)
        if let spacing = spacing {
            base.setCustomSpacing(spacing, after: view)
        }
        return base
    }
    
    
    /// 將一個子視圖加入 stackView 的 `arrangedSubviews` 的指定位置
    @MainActor
    @discardableResult
    func insertArranged(_ view: UIView, at stackIndex: Int, spacing: CGFloat? = nil) -> Base {
        base.insertArrangedSubview(view, at: stackIndex)
        if let spacing = spacing {
            base.setCustomSpacing(spacing, after: view)
        }
        return base
    }
    
    
    /// 將一個子視圖加入 stackView 的 `arrangedSubviews` 的指定位置
    @MainActor
    @discardableResult
    func insertArranged(_ view: UIView, at arrangedView: UIView, spacing: CGFloat? = nil) -> Base {
        guard let index = base.arrangedSubviews.firstIndex(of: arrangedView) else {
            return base
        }
        base.insertArrangedSubview(view, at: index)
        if let spacing = spacing {
            base.setCustomSpacing(spacing, after: view)
        }
        return base
    }
    
    
    /// 將一個子視圖從 stackView 的 `arrangedSubviews` 刪除
    @MainActor
    @discardableResult
    func removeArranged(_ view: UIView) -> Base {
        base.removeArrangedSubview(view)
        view.removeFromSuperview()
        return base
    }
    
    
}

