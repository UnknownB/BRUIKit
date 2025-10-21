//
//  BRLabel+DSL.swift
//  BRUIKit
//
//  Created by BR on 2025/10/22.
//

import BRFoundation
import UIKit


public extension BRWrapper where Base: BRLabel {
    
    
    /// 設定 label 的內邊距
    @discardableResult
    func contentInsets(_ insets: UIEdgeInsets) -> Base {
        base.contentInsets = insets
        return base
    }
    
    
    /// 使用 `UIFont.Weight` 設定字串字體
    @discardableResult
    func font(for word: String, _ weight: UIFont.Weight, _ size: CGFloat) -> Base {
        base.attributedText = base.RTF.font(for: word, font: UIFont.br.font(weight, size: size), in: base.attributedText)
        return base
    }
    
    
    /// 使用 `BRFontWeight` 設定字串字體
    @discardableResult
    func font(for word: String, _ weight: BRFontWeight, _ size: CGFloat) -> Base {
        base.attributedText = base.RTF.font(for: word, font: UIFont.br.font(weight, size: size), in: base.attributedText)
        return base
    }

    
    /// 設定某個字串的字體
    @discardableResult
    func font(for word: String, font: UIFont) -> Base {
        base.attributedText = base.RTF.font(for: word, font: font, in: base.attributedText)
        return base
    }
    
    
    /// 設定某個字串的顏色
    @discardableResult
    func color(for word: String, color: UIColor) -> Base {
        base.attributedText = base.RTF.color(for: word, color: color, in: base.attributedText)
        return base
    }

    
    /// 設定下劃線
    @discardableResult
    func underline(for word: String, style: NSUnderlineStyle = .single, color: UIColor? = nil) -> Base {
        base.attributedText = base.RTF.underline(for: word, style: style, color: color, in: base.attributedText)
        return base
    }

    
    /// 設定刪除線
    @discardableResult
    func strikethrough(for word: String, style: NSUnderlineStyle = .single, color: UIColor? = nil) -> Base {
        base.attributedText = base.RTF.strikethrough(for: word, style: style, color: color, in: base.attributedText)
        return base
    }
    
    
    /// 設定點擊事件
    @discardableResult
    func tappable(for word: String, action: @escaping BRLabel.TappableAction) -> Base {
        base.RTF.addTappable(for: word, action: action, in: base.attributedText)
        return base
    }
    
    
}
