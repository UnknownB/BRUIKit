//
//  UITextView+DSL.swift
//  BRUIKit
//
//  Created by BR on 2025/6/26.
//

import UIKit
import BRFoundation


@MainActor
public extension BRWrapper where Base: UITextView {

    
    // MARK: - 文字與樣式

    
    /// 設定文字內容
    @discardableResult
    func text(_ text: String?) -> Base {
        base.text = text
        return base
    }

    
    /// 設定 Attributed 文字內容
    @discardableResult
    func attributedText(_ attributed: NSAttributedString?) -> Base {
        base.attributedText = attributed
        return base
    }
    
    
    /// 使用 `UIFont.Weight` 設定系統字體
    @discardableResult
    func font(_ weight: UIFont.Weight, _ size: CGFloat) -> Base {
        base.font = .br.font(weight, size: size)
        return base
    }

    
    /// 使用 `BRFontWeight` 設定系統字體
    @discardableResult
    func font(_ weight: BRFontWeight, _ size: CGFloat) -> Base {
        base.font = .br.font(weight, size: size)
        return base
    }

    
    /// 設定字體
    @discardableResult
    func font(_ font: UIFont) -> Base {
        base.font = font
        return base
    }
    

    /// 設定文字顏色
    @discardableResult
    func textColor(_ color: UIColor) -> Base {
        base.textColor = color
        return base
    }

    
    /// 設定文字對齊方式
    @discardableResult
    func alignment(_ alignment: NSTextAlignment) -> Base {
        base.textAlignment = alignment
        return base
    }
    
    
    /// 設定連結字型
    @discardableResult
    func linkFont(font: UIFont) -> Base {
        base.linkTextAttributes[.font] = font
        return base
    }
    
    
    /// 設定連結字型
    @discardableResult
    func linkColor(color: UIColor?) -> Base {
        base.linkTextAttributes[.foregroundColor] = color
        return base
    }
    
    
    /// 設定連結樣式
    @discardableResult
    func linkStyle(style: NSUnderlineStyle) -> Base {
        base.linkTextAttributes[.underlineStyle] = style.rawValue
        return base
    }

    
    // MARK: - 行高與間距
    
    
    /// 設定行距（line spacing）
    @discardableResult
    func lineSpacing(_ spacing: CGFloat) -> Base {
        guard let mutable = base.attributedText?.mutableCopy() as? NSMutableAttributedString else {
            return base
        }
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        let attrs: [NSAttributedString.Key: Any] = [.paragraphStyle: style]
        mutable.addAttributes(attrs, range: NSRange(location: 0, length: mutable.length))
        base.attributedText = mutable
        return base
    }

    
    // MARK: - 行為控制

    
    /// 是否可編輯
    @discardableResult
    func isEditable(_ flag: Bool) -> Base {
        base.isEditable = flag
        return base
    }

    
    /// 是否可選取文字
    @discardableResult
    func isSelectable(_ flag: Bool) -> Base {
        base.isSelectable = flag
        return base
    }

    
    /// 是否可捲動
    @discardableResult
    func isScrollEnabled(_ flag: Bool) -> Base {
        base.isScrollEnabled = flag
        return base
    }

    
    /// 是否啟用使用者互動
    @discardableResult
    func isUserInteractionEnabled(_ enabled: Bool) -> Base {
        base.isUserInteractionEnabled = enabled
        return base
    }

    
    /// 鍵盤類型
    @discardableResult
    func keyboardType(_ type: UIKeyboardType) -> Base {
        base.keyboardType = type
        return base
    }

    
    /// 鍵盤 return 鍵樣式
    @discardableResult
    func returnKeyType(_ type: UIReturnKeyType) -> Base {
        base.returnKeyType = type
        return base
    }
    

    /// 自動大小寫設定
    @discardableResult
    func autocapitalization(_ type: UITextAutocapitalizationType) -> Base {
        base.autocapitalizationType = type
        return base
    }

    
    /// 自動校正設定
    @discardableResult
    func autocorrection(_ type: UITextAutocorrectionType) -> Base {
        base.autocorrectionType = type
        return base
    }

    
    /// 拼字檢查設定
    @discardableResult
    func spellChecking(_ type: UITextSpellCheckingType) -> Base {
        base.spellCheckingType = type
        return base
    }

    
    // MARK: - 內距與格式
    

    /// 設定內距（上下左右）
    @discardableResult
    func textContainerInset(_ inset: UIEdgeInsets) -> Base {
        base.textContainerInset = inset
        return base
    }

    
    /// 設定行片段的內距（對齊段落左右用）
    @discardableResult
    func lineFragmentPadding(_ padding: CGFloat) -> Base {
        base.textContainer.lineFragmentPadding = padding
        return base
    }

    
    // MARK: - 委任代理

    
    /// 設定 delegate
    @discardableResult
    func delegate(_ delegate: UITextViewDelegate?) -> Base {
        base.delegate = delegate
        return base
    }
    
    
}
