//
//  UITextView+DSL.swift
//  BRUIKit
//
//  Created by BR on 2025/6/26.
//

import UIKit
import BRFoundation


public extension BRWrapper where Base: UITextView {

    
    // MARK: - 文字與樣式

    
    /// 設定文字內容
    @MainActor
    @discardableResult
    func text(_ text: String?) -> Base {
        base.text = text
        return base
    }

    
    /// 設定 Attributed 文字內容
    @MainActor
    @discardableResult
    func attributedText(_ attributed: NSAttributedString?) -> Base {
        base.attributedText = attributed
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

    
    /// 設定字體
    @MainActor
    @discardableResult
    func font(_ font: UIFont) -> Base {
        base.font = font
        return base
    }
    

    /// 設定文字顏色
    @MainActor
    @discardableResult
    func textColor(_ color: UIColor) -> Base {
        base.textColor = color
        return base
    }

    
    /// 設定文字對齊方式
    @MainActor
    @discardableResult
    func alignment(_ alignment: NSTextAlignment) -> Base {
        base.textAlignment = alignment
        return base
    }

    
    // MARK: - 行高與間距

    
    /// 設定行高
    @MainActor
    @discardableResult
    func lineHeight(_ min: CGFloat, _ max: CGFloat) -> Base {
        var attributes = base.typingAttributes ?? [:]
        let style = attributes[.paragraphStyle] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()

        style.minimumLineHeight = min
        style.maximumLineHeight = max
        attributes[.paragraphStyle] = style
        
        base.typingAttributes = attributes
        return base
    }

    
    /// 設定行距（line spacing）
    @MainActor
    @discardableResult
    func lineSpacing(_ spacing: CGFloat) -> Base {
        var attributes = base.typingAttributes ?? [:]
        let style = attributes[.paragraphStyle] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        
        style.lineSpacing = spacing
        attributes[.paragraphStyle] = style
        base.typingAttributes = attributes
        return base
    }

    
    // MARK: - 行為控制

    
    /// 是否可編輯
    @MainActor
    @discardableResult
    func isEditable(_ flag: Bool) -> Base {
        base.isEditable = flag
        return base
    }

    
    /// 是否可選取文字
    @MainActor
    @discardableResult
    func isSelectable(_ flag: Bool) -> Base {
        base.isSelectable = flag
        return base
    }

    
    /// 是否可捲動
    @MainActor
    @discardableResult
    func isScrollEnabled(_ flag: Bool) -> Base {
        base.isScrollEnabled = flag
        return base
    }

    
    /// 是否啟用使用者互動
    @MainActor
    @discardableResult
    func isUserInteractionEnabled(_ enabled: Bool) -> Base {
        base.isUserInteractionEnabled = enabled
        return base
    }

    
    /// 鍵盤類型
    @MainActor
    @discardableResult
    func keyboardType(_ type: UIKeyboardType) -> Base {
        base.keyboardType = type
        return base
    }

    
    /// 鍵盤 return 鍵樣式
    @MainActor
    @discardableResult
    func returnKeyType(_ type: UIReturnKeyType) -> Base {
        base.returnKeyType = type
        return base
    }
    

    /// 自動大小寫設定
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

    
    // MARK: - 內距與格式
    

    /// 設定內距（上下左右）
    @MainActor
    @discardableResult
    func textContainerInset(_ inset: UIEdgeInsets) -> Base {
        base.textContainerInset = inset
        return base
    }

    
    /// 設定行片段的內距（對齊段落左右用）
    @MainActor
    @discardableResult
    func lineFragmentPadding(_ padding: CGFloat) -> Base {
        base.textContainer.lineFragmentPadding = padding
        return base
    }

    
    // MARK: - 委任代理

    
    /// 設定 delegate
    @MainActor
    @discardableResult
    func delegate(_ delegate: UITextViewDelegate?) -> Base {
        base.delegate = delegate
        return base
    }
    
    
}
