//
//  BRButton+DSL.swift
//  BRUIKit
//
//  Created by BR on 2025/9/28.
//

import UIKit
import BRFoundation


public extension BRWrapper where Base: BRButton {
    
    
    // MARK: - State
    
    
    /// 設定按鈕狀態
    @MainActor
    @discardableResult
    func buttonState(_ state: BRButtonState) -> Base {
        base.buttonState = state
        return base
    }


    @MainActor
    @discardableResult
    func setTitle(_ title: String?, for state: BRButtonState) -> Base {
        base.setTitle(title, for: state)
        return base
    }
    
    
    @MainActor
    @discardableResult
    func setTitleColor(_ color: UIColor?, for state: BRButtonState) -> Base {
        base.setTitleColor(color, for: state)
        return base
    }
    
    
    @MainActor
    @discardableResult
    func setImage(_ image: UIImage?, for state: BRButtonState) -> Base {
        base.setImage(image, for: state)
        return base
    }

    
    @MainActor
    @discardableResult
    func setBackgroundImage(_ image: UIImage?, for state: BRButtonState) -> Base {
        base.setBackgroundImage(image, for: state)
        return base
    }
    
    
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
