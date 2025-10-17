//
//  UIScrollView+DSL.swift
//  BRUIKit
//
//  Created by BR on 2025/9/2.
//

import BRFoundation
import UIKit


public extension BRWrapper where Base: UIScrollView {
    
    
    // MARK: - 基本屬性
    
    
    /// 設定 scrollView 是否可滾動
    @MainActor
    @discardableResult
    func scrollEnabled(_ enabled: Bool) -> Base {
        base.isScrollEnabled = enabled
        return base
    }

    
    /// 設定點擊狀態列是否自動滾動到頂端
    @MainActor
    @discardableResult
    func scrollsToTop(_ enabled: Bool) -> Base {
        base.scrollsToTop = enabled
        return base
    }
    
    
    /// 設定捲軸指示器的邊距
    @MainActor
    @discardableResult
    func scrollIndicatorInsets(_ insets: UIEdgeInsets) -> Base {
        base.scrollIndicatorInsets = insets
        return base
    }
    
    
    /// 設定 scrollView 的內容大小
    @MainActor
    @discardableResult
    func contentSize(_ size: CGSize) -> Base {
        base.contentSize = size
        return base
    }
    
    
    /// 設定 scrollView 的內邊距
    @MainActor
    @discardableResult
    func contentInset(_ insets: UIEdgeInsets) -> Base {
        base.contentInset = insets
        return base
    }

    
    /// 設定 scrollView 的初始偏移量
    @MainActor
    @discardableResult
    func contentOffset(_ offset: CGPoint, animated: Bool = false) -> Base {
        base.setContentOffset(offset, animated: animated)
        return base
    }
    
    
    /// 是否啟用方向鎖定 (一次只能往一個方向捲動)
    @MainActor
    @discardableResult
    func directionalLockEnabled(_ enabled: Bool) -> Base {
        base.isDirectionalLockEnabled = enabled
        return base
    }
    
    
    // MARK: - 滑動行為
    
    
    /// 設定是否允許邊界反彈效果
    @MainActor
    @discardableResult
    func bounces(_ enabled: Bool) -> Base {
        base.bounces = enabled
        return base
    }
    
    
    /// 設定是否允許垂直方向的彈性滾動
    @MainActor
    @discardableResult
    func alwaysBounceVertical(_ enabled: Bool) -> Base {
        base.alwaysBounceVertical = enabled
        return base
    }
    
    
    /// 設定是否允許水平方向的彈性滾動
    @MainActor
    @discardableResult
    func alwaysBounceHorizontal(_ enabled: Bool) -> Base {
        base.alwaysBounceHorizontal = enabled
        return base
    }
    
    
    /// 設定 scrollView 是否以分頁模式滾動
    @MainActor
    @discardableResult
    func pagingEnabled(_ enabled: Bool) -> Base {
        base.isPagingEnabled = enabled
        return base
    }
    
    
    /// 是否允許滑動慣性 (拖曳放開後繼續滾動)
    @MainActor
    @discardableResult
    func decelerationRate(_ rate: UIScrollView.DecelerationRate) -> Base {
        base.decelerationRate = rate
        return base
    }
    
    
    /// 是否允許在捲動過程中延遲 touches 事件
    @MainActor
    @discardableResult
    func delaysContentTouches(_ enabled: Bool) -> Base {
        base.delaysContentTouches = enabled
        return base
    }
    
    
    /// 是否允許捲動取消 touches
    @MainActor
    @discardableResult
    func canCancelContentTouches(_ enabled: Bool) -> Base {
        base.canCancelContentTouches = enabled
        return base
    }
    
    
    /// 滾動到指定的 View
    @MainActor
    @discardableResult
    func scrollToView(_ view: UIView, animated: Bool = true, dx: CGFloat = 0, dy: CGFloat = 0) -> Base {
        base.scrollRectToVisible(view.frame.insetBy(dx: dx, dy: dy), animated: animated)
        return base
    }

    
    // MARK: - 指標 (Scroll Indicators)
    
    
    /// 設定指標樣式
    @MainActor
    @discardableResult
    func indicatorStyle(_ style: UIScrollView.IndicatorStyle) -> Base {
        base.indicatorStyle = style
        return base
    }
    
    
    /// 設定是否顯示垂直方向的捲軸
    @MainActor
    @discardableResult
    func showsVerticalIndicator(_ enabled: Bool) -> Base {
        base.showsVerticalScrollIndicator = enabled
        return base
    }
    
    
    /// 設定是否顯示水平方向的捲軸
    @MainActor
    @discardableResult
    func showsHorizontalIndicator(_ enabled: Bool) -> Base {
        base.showsHorizontalScrollIndicator = enabled
        return base
    }
    
        
    /// 設定垂直捲軸的額外內距 (iOS 11+)
    @MainActor
    @discardableResult
    func verticalScrollIndicatorInsets(_ insets: UIEdgeInsets) -> Base {
        base.verticalScrollIndicatorInsets = insets
        return base
    }
    
    
    /// 設定水平捲軸的額外內距 (iOS 11+)
    @MainActor
    @discardableResult
    func horizontalScrollIndicatorInsets(_ insets: UIEdgeInsets) -> Base {
        base.horizontalScrollIndicatorInsets = insets
        return base
    }
    
    
    // MARK: - 縮放 (Zoom)
    
    
    /// 設定允許縮放的最小倍率
    @MainActor
    @discardableResult
    func minimumZoomScale(_ scale: CGFloat) -> Base {
        base.minimumZoomScale = scale
        return base
    }
    
    
    /// 設定允許縮放的最大倍率
    @MainActor
    @discardableResult
    func maximumZoomScale(_ scale: CGFloat) -> Base {
        base.maximumZoomScale = scale
        return base
    }
    
    
    /// 設定初始縮放倍率
    @MainActor
    @discardableResult
    func zoomScale(_ scale: CGFloat, animated: Bool = false) -> Base {
        base.setZoomScale(scale, animated: animated)
        return base
    }
    
    
    /// 設定縮放時是否允許彈性效果
    @MainActor
    @discardableResult
    func bouncesZoom(_ enabled: Bool) -> Base {
        base.bouncesZoom = enabled
        return base
    }
    
    
    // MARK: - 內容自動調整
    
    
    /// iOS 11+：設定內容與安全區域 (Safe Area) 的行為
    @available(iOS 11.0, *)
    @MainActor
    @discardableResult
    func contentInsetAdjustmentBehavior(_ behavior: UIScrollView.ContentInsetAdjustmentBehavior) -> Base {
        base.contentInsetAdjustmentBehavior = behavior
        return base
    }
    
    
    /// iOS 13+：設定自動調整捲動指標的外觀
    @available(iOS 13.0, *)
    @MainActor
    @discardableResult
    func automaticallyAdjustsIndicatorStyle(_ enabled: Bool) -> Base {
        base.automaticallyAdjustsScrollIndicatorInsets = enabled
        return base
    }
    
    
    // MARK: - 鍵盤處理
    
    
    /// 設定鍵盤出現時的收起模式
    @MainActor
    @discardableResult
    func keyboardDismissMode(_ mode: UIScrollView.KeyboardDismissMode) -> Base {
        base.keyboardDismissMode = mode
        return base
    }
    
    
}
