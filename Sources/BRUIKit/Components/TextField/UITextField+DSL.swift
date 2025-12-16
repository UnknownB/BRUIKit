//
//  UITextField+DSL.swift
//  BRUIKit
//
//  Created by BR on 2025/6/26.
//

import UIKit
import BRFoundation


public extension BRWrapper where Base: UITextField {

    
    // MARK: - 文字與樣式

    
    /// 設定文字內容
    @MainActor
    @discardableResult
    func text(_ text: String?) -> Base {
        base.text = text
        return base
    }

    
    /// 設定 placeholder 文字
    @MainActor
    @discardableResult
    func placeholder(_ placeholder: String?) -> Base {
        base.placeholder = placeholder
        return base
    }

    
    /// 設定富文字 placeholder
    @MainActor
    @discardableResult
    func attributedPlaceholder(_ attributed: NSAttributedString?) -> Base {
        base.attributedPlaceholder = attributed
        return base
    }

    
    /// 設定文字顏色
    @MainActor
    @discardableResult
    func textColor(_ color: UIColor) -> Base {
        base.textColor = color
        return base
    }

    
    /// 使用 `UIFont.Weight` 設定系統字體
    @MainActor
    @discardableResult
    func font(_ weight: UIFont.Weight, _ size: CGFloat) -> Base {
        base.font = .br.font(weight, size: size)
        return base
    }
    

    /// 使用 `BRFontWeight` 設定系統字體
    @MainActor
    @discardableResult
    func font(_ weight: BRFontWeight, _ size: CGFloat) -> Base {
        base.font = .br.font(weight, size: size)
        return base
    }
    

    /// 直接設定 `UIFont` 字體
    @MainActor
    @discardableResult
    func font(_ font: UIFont) -> Base {
        base.font = font
        return base
    }

    
    /// 設定文字對齊方式
    @MainActor
    @discardableResult
    func alignment(_ alignment: NSTextAlignment) -> Base {
        base.textAlignment = alignment
        return base
    }

    
    /// 設定邊框樣式（如 .roundedRect 等）
    @MainActor
    @discardableResult
    func borderStyle(_ style: UITextField.BorderStyle) -> Base {
        base.borderStyle = style
        return base
    }

    
    // MARK: - 行為設定

    
    /// 是否為密碼輸入（預設 true）
    @MainActor
    @discardableResult
    func isSecure(_ flag: Bool = true) -> Base {
        base.isSecureTextEntry = flag
        return base
    }
    
    
    /// 設定文字內容類型（如 .emailAddress, .password 等）
    @MainActor
    @discardableResult
    func textContentType(_ type: UITextContentType) -> Base {
        base.textContentType = type
        return base
    }

    
    /// 設定鍵盤類型（如 .emailAddress, .numberPad 等）
    @MainActor
    @discardableResult
    func keyboardType(_ type: UIKeyboardType) -> Base {
        base.keyboardType = type
        return base
    }

    
    /// 設定 return 鍵樣式（如 .done, .next）
    @MainActor
    @discardableResult
    func returnKeyType(_ type: UIReturnKeyType) -> Base {
        base.returnKeyType = type
        return base
    }
    

    /// 自動大寫設定
    @MainActor
    @discardableResult
    func autocapitalization(_ type: UITextAutocapitalizationType) -> Base {
        base.autocapitalizationType = type
        return base
    }
    

    /// 自動校正設定
    @MainActor
    @discardableResult
    func autocorrection(_ type: UITextAutocorrectionType) -> Base {
        base.autocorrectionType = type
        return base
    }

    
    /// 拼字檢查設定
    @MainActor
    @discardableResult
    func spellChecking(_ type: UITextSpellCheckingType) -> Base {
        base.spellCheckingType = type
        return base
    }

    
    // MARK: - 附加 View

    
    /// 設定左側輔助 View（如 icon）
    @MainActor
    @discardableResult
    func leftView(_ view: UIView?, mode: UITextField.ViewMode = .always) -> Base {
        base.leftView = view
        base.leftViewMode = mode
        return base
    }

    
    /// 設定右側輔助 View（如清除鍵、自訂按鈕）
    @MainActor
    @discardableResult
    func rightView(_ view: UIView?, mode: UITextField.ViewMode = .always) -> Base {
        base.rightView = view
        base.rightViewMode = mode
        return base
    }

    
    /// 設定清除按鈕出現時機（例如輸入時自動出現）
    @MainActor
    @discardableResult
    func clearButtonMode(_ mode: UITextField.ViewMode) -> Base {
        base.clearButtonMode = mode
        return base
    }

    
    // MARK: - 行為控制
    

    /// 設定 delegate 代理對象
    @MainActor
    @discardableResult
    func delegate(_ delegate: UITextFieldDelegate?) -> Base {
        base.delegate = delegate
        return base
    }

    
    /// 添加事件監聽（預設為 .editingChanged）
    @MainActor
    @discardableResult
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event = .editingChanged) -> Base {
        base.addTarget(target, action: action, for: controlEvents)
        return base
    }
    
    
}
