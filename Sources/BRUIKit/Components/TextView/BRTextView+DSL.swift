//
//  BRTextView+DSL.swift
//  BRUIKit
//
//  Created by BR on 2025/10/22.
//

import UIKit
import BRFoundation


public extension BRWrapper where Base: BRTextView {

    
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
