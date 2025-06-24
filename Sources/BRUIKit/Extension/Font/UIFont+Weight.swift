//
//  UIFont+DSL.swift
//  BRUIKit
//
//  Created by BR on 2025/6/19.
//

import BRFoundation
import UIKit


public extension BRWrapper where Base == UIFont {

    
    /// 建立系統一般字體
    static func font(_ weight: UIFont.Weight, size: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: weight)
    }
    
    
    /// 建立系統一般字體
    static func font(_ weight: BRFontWeight, size: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: weight.uiFontWeight)
    }
    
    
    /// 建立系統等寬字體
    @available(iOS 13.0, *)
    static func monospaced(_ weight: UIFont.Weight, size: CGFloat) -> UIFont {
        UIFont.monospacedSystemFont(ofSize: size, weight: weight)
    }

    
    /// 建立系統等寬字體
    @available(iOS 13.0, *)
    static func monospaced(_ weight: BRFontWeight, size: CGFloat) -> UIFont {
        UIFont.monospacedSystemFont(ofSize: size, weight: weight.uiFontWeight)
    }
    
    
    /// 建立支援動態文字的字體
    static func scaled(_ weight: UIFont.Weight, size: CGFloat, textStyle: UIFont.TextStyle) -> UIFont {
        let baseFont = UIFont.systemFont(ofSize: size, weight: weight)
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: baseFont)
    }

    
    /// 建立支援動態文字的字體
    static func scaled(_ weight: BRFontWeight, size: CGFloat, textStyle: UIFont.TextStyle) -> UIFont {
        let baseFont = UIFont.systemFont(ofSize: size, weight: weight.uiFontWeight)
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: baseFont)
    }
    
    
}
