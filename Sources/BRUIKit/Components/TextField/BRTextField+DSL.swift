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
    @MainActor
    @discardableResult
    func debounce(_ seconds: TimeInterval) -> Base {
        base.debounce = seconds
        return base
    }
    
    
    /// 設定 textField 的內邊距
    @MainActor
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
    
    
    /// 設定加密按鈕
    @MainActor
    @discardableResult
    func setSecureTextEntryButton(_ button: UIButton) -> Base {
        base.setSecureTextEntryButton(button)
        return base
    }
    
    
    
    /// 設定字數上限
    @MainActor
    @discardableResult
    func maxLength(_ maxLength: Int) -> Base {
        base.maxLength = maxLength
        return base
    }


    /// 設定是否啟用基礎注入攻擊樣式過濾
    @MainActor
    @discardableResult
    func isBasicInjectionFilterEnabled(_ isEnabled: Bool) -> Base {
        base.isBasicInjectionFilterEnabled = isEnabled
        return base
    }

    
    // MARK: - Keyboard Toolbar
    

    /// 鍵盤工具列 Done Event
    @MainActor
    @discardableResult
    func onToolbarDone(_ closure: (() -> Void)?) -> Base {
        base.keyboardToolbarConfig.onDone = closure
        return base
    }
    
    
    /// 鍵盤工具列 Prev Event
    @MainActor
    @discardableResult
    func onToolbarPrev(_ closure: ((_ prevView: UIResponder?) -> Void)?) -> Base {
        base.keyboardToolbarConfig.onPrev = closure
        return base
    }
    
    
    /// 鍵盤工具列 Next Event
    @MainActor
    @discardableResult
    func onToolbarNext(_ closure: ((_ nextView: UIResponder?) -> Void)?) -> Base {
        base.keyboardToolbarConfig.onNext = closure
        return base
    }
    
    
    /// 鍵盤工具列隱藏 Prev、Next 按鈕
    @MainActor
    @discardableResult
    func isHiddenToolbarPrevNext(_ flag: Bool?) -> Base {
        base.keyboardToolbarConfig.hiddenPrevNext = flag
        return base
    }
    
    
    /// 鍵盤工具列添加仿系統元件
    @MainActor
    @discardableResult
    func addToolbarItem(title: String? = nil, icon: UIImage? = nil, tintColor: UIColor? = nil, titleColor: UIColor? = nil, tip: String? = nil, action: (() -> Void)? = nil) -> Base {
        let button = BRButton.toolbarItemStyle(tintColor: tintColor, titleColor: titleColor, tip: tip, action: action)
            .br.title(title)
            .br.image(icon?.withRenderingMode(.alwaysTemplate))
            .br.imagePadding(2)
        base.keyboardToolbarConfig.additionalItems.append(button)
        return base
    }
    
    
    /// 鍵盤工具列添加元件
    @MainActor
    @discardableResult
    func addToolbarItem(_ view: UIView) -> Base {
        base.keyboardToolbarConfig.additionalItems.append(view)
        return base
    }


    /// 鍵盤工具列添加多個元件
    @MainActor
    @discardableResult
    func addToolbarItems(_ views: [UIView]) -> Base {
        base.keyboardToolbarConfig.additionalItems.append(contentsOf: views)
        return base
    }


    /// 鍵盤工具列刪除所有額外元件
    @MainActor
    @discardableResult
    func removeAllAdditionalToolbarItems() -> Base {
        base.keyboardToolbarConfig.additionalItems.removeAll()
        return base
    }
    

}
