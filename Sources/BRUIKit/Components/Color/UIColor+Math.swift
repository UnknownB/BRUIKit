//
//  UIColor+Math.swift
//  BRUIKit
//
//  Created by BR on 2025/8/12.
//

import BRFoundation
import UIKit


public extension BRWrapper where Base == UIColor {

    
    /// 計算與另一個 Color 的對比比率（Contrast Ratio）
    func contrastRatio(with otherColor: UIColor) -> CGFloat {
        let luminance1 = base.br.relativeLuminance()
        let luminance2 = otherColor.br.relativeLuminance()
        let (lighter, darker) = luminance1 > luminance2 ? (luminance1, luminance2) : (luminance2, luminance1)
        return (lighter + 0.05) / (darker + 0.05)
    }
    
    
    /// 線性化 sRGB (WCAG 標準)
    func adjustComponent(_ component: CGFloat) -> CGFloat {
        return (component <= 0.03928) ? (component / 12.92) : pow((component + 0.055) / 1.055, 2.4)
    }
    
    
    /// 計算 Color 的相對亮度 (WCAG 公式)
    func relativeLuminance() -> CGFloat {
        guard let color = base.br.toRGBA() else {
            return 0
        }
        return 0.2126 * adjustComponent(color.red) + 0.7152 * adjustComponent(color.green) + 0.0722 * adjustComponent(color.blue)
    }
    
    
}
