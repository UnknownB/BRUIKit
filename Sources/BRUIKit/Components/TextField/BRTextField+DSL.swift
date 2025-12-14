//
//  BRTextField+DSL.swift
//  BRUIKit
//
//  Created by BR on 2025/12/5.
//

import UIKit
import BRFoundation


public extension BRWrapper where Base: BRTextField {
    
    
    /// 輸入緩衝，預設為1秒
    @discardableResult
    public func debounce(_ seconds: TimeInterval) -> Base {
        base.debounce = seconds
        return base
    }
    
    
    /// 設定 textField 的內邊距
    @discardableResult
    func contentInsets(_ insets: UIEdgeInsets) -> Base {
        base.contentInsets = insets
        return base
    }
    
    
    /// 設定背景顏色至指定的輸入框狀態
    @MainActor
    @discardableResult
    func setBackgroundColor(_ color: UIColor?, for state: BRTextFieldState) -> Base {
        base.setBackgroundColor(color, for: state)
        return base
    }
    
    
    /// 設定邊框顏色至指定的輸入框狀態
    @MainActor
    @discardableResult
    func setBorder(color: UIColor?, width: CGFloat, for state: BRTextFieldState) -> Base {
        base.setBorder(color: color, width: width, for: state)
        return base
    }
    
    
}
