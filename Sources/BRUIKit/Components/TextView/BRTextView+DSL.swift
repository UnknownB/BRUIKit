//
//  BRTextView+DSL.swift
//  BRUIKit
//
//  Created by BR on 2025/10/22.
//

import UIKit
import BRFoundation


@MainActor
public extension BRWrapper where Base: BRTextView {
    
    
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
    
    
    /// 設定文字背景
    @discardableResult
    func textBackgroundColor(_ color: UIColor) -> Base {
        base.textBackgroundColor = color
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


    /// 設定連結顏色
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
    
    
    /// 設定行距（line spacing）
    @MainActor
    @discardableResult
    func lineSpacing(_ spacing: CGFloat) -> Base {
        base.placeholderLabel.br.lineSpacing(spacing)
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


    // MARK: - PlaceHolder
    
    
    /// 設定佔位符文字內容
    @MainActor
    @discardableResult
    func placeholder(_ text: String?) -> Base {
        base.placeholderLabel.text = text
        return base
    }
    
    
    /// 設定佔位符顏色
    @MainActor
    @discardableResult
    func placeholderColor(_ color: UIColor) -> Base {
        base.placeholderLabel.br.color(color)
        return base
    }
    
    
    /// 設定佔位符字型
    @MainActor
    @discardableResult
    func placeholderFont(_ weight: UIFont.Weight, _ size: CGFloat) -> Base {
        base.placeholderLabel.br.font(weight, size)
        return base
    }

    
    /// 設定佔位符字型
    @MainActor
    @discardableResult
    func placeholderFont(_ weight: BRFontWeight, _ size: CGFloat) -> Base {
        base.placeholderLabel.br.font(weight, size)
        return base
    }
    
    
    /// 設定佔位符字型
    @MainActor
    @discardableResult
    func placeholderFont(_ font: UIFont) -> Base {
        base.placeholderLabel.br.font(font)
        return base
    }
    
    
    /// 設定佔位符內縮值
    @MainActor
    @discardableResult
    func placeholderInsets(_ insets: UIEdgeInsets) -> Base {
        base.placeholderLabel.br.contentInsets(insets)
        return base
    }
    
    
    /// 設定佔位符行距
    @MainActor
    @discardableResult
    func placeholderLineSpacing(_ spacing: CGFloat) -> Base {
        base.placeholderLabel.br.lineSpacing(spacing)
        return base
    }

    
    
    // MARK: - 富文本
    
    
    /// 使用 `UIFont.Weight` 設定字串字體
    @discardableResult
    func font(for word: String, _ weight: UIFont.Weight, _ size: CGFloat) -> Base {
        base.attributedText = base.RTF.font(for: word, font: UIFont.br.font(weight, size: size))
        return base
    }
    
    
    /// 使用 `BRFontWeight` 設定字串字體
    @discardableResult
    func font(for word: String, _ weight: BRFontWeight, _ size: CGFloat) -> Base {
        base.attributedText = base.RTF.font(for: word, font: UIFont.br.font(weight, size: size))
        return base
    }

    
    /// 設定某個字串的字體
    @discardableResult
    func font(for word: String, font: UIFont) -> Base {
        base.attributedText = base.RTF.font(for: word, font: font)
        return base
    }
    
    
    /// 設定某個字串的顏色
    @discardableResult
    func color(for word: String, color: UIColor) -> Base {
        base.attributedText = base.RTF.color(for: word, color: color)
        return base
    }
    
    
    /// 設定下劃線
    @discardableResult
    func underline(for word: String, style: NSUnderlineStyle = .single, color: UIColor? = nil) -> Base {
        base.attributedText = base.RTF.underline(for: word, style: style, color: color)
        return base
    }
    
    
    /// 設定刪除線
    @discardableResult
    func strikethrough(for word: String, style: NSUnderlineStyle = .single, color: UIColor? = nil) -> Base {
        base.attributedText = base.RTF.strikethrough(for: word, style: style, color: color)
        return base
    }
    
    
    /// 設定點擊事件
    @discardableResult
    func tappable(for word: String, action: @escaping BRTextView.TappableAction) -> Base {
        base.attributedText = base.RTF.addTappable(for: word, action: action)
        return base
    }
    

}
