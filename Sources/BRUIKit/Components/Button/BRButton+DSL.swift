//
//  BRButton+DSL.swift
//  BRUIKit
//
//  Created by BR on 2025/9/28.
//

import UIKit
import BRFoundation


public extension BRWrapper where Base: BRButton {
    
    
    // MARK: - Layout
    
    
    /// 設定圖片與文字的排版方式
    @MainActor
    @discardableResult
    func layoutMode(_ layout: BRButtonLayout) -> Base {
        base.layoutMode = layout
        return base
    }
    
    
    /// 設定圖片在按鈕中的位置
    @MainActor
    @discardableResult
    func imagePosition(_ position: BRPosition) -> Base {
        base.imagePosition = position
        return base
    }
    
    
    /// 設定圖片尺寸
    @MainActor
    @discardableResult
    func imageSize(_ size: CGSize?) -> Base {
        base.imageSize = size
        return base
    }
    
    
    /// 設定圖片與文字的間距
    @MainActor
    @discardableResult
    func imagePadding(_ padding: CGFloat) -> Base {
        base.imagePadding = padding
        return base
    }

    
    /// 設定圖片額外的內縮值
    @MainActor
    @discardableResult
    func imageInsets(_ insets: UIEdgeInsets) -> Base {
        base.imageInsets = insets
        return base
    }
    
    
}
