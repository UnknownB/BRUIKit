//
//  UIColor+Harmony.swift
//  BRUIKit
//
//  Created by BR on 2025/8/12.
//

import BRFoundation
import UIKit


public extension BRWrapper where Base == UIColor {
    
    
    /// 返回色輪上相對的顏色 (補色)
    func complementary(adjusted: Bool = true) -> UIColor {
        guard let (h, s, l, a) = base.br.toHSL() else {
            return .black
        }

        // 計算補色色相，超過360度就環繞回去
        let complementaryHue = (h + 0.5).truncatingRemainder(dividingBy: 1.0)

        // 調整飽和度與亮度，避免過度鮮豔或過暗
        let adjustedSaturation = min(s * 1.2, 1.0)
        let adjustedLightness = l > 0.5 ? l * 0.7 : min(l * 1.3, 1.0)

        return UIColor(hue: complementaryHue, saturation: adjustedSaturation, brightness: adjustedLightness, alpha: a)
    }
    
    
    /// 返回適合背景的文字顏色
    func readable() -> UIColor {
        let blackColor = UIColor.black
        let whiteColor = UIColor.white
        
        let candidates = [blackColor, whiteColor]
        let contrastPairs: [(color: UIColor, contrast: CGFloat)] = candidates.map { (color: $0, contrast: $0.br.contrastRatio(with: base)) }
        
        guard let bestContrast = contrastPairs.max(by: { $0.contrast < $1.contrast }) else {
            return .black
        }
                
        return bestContrast.color
    }
    
    
    /// 返回低亮度顏色
    func dark(darkenFactor: CGFloat = 0.3) -> UIColor {
        guard var color = base.br.toHSL() else {
            return base
        }
        
        // 將亮度調低，darkenFactor越小，顏色越暗
        color.lightness = max(min(color.lightness * darkenFactor, 1.0), 0.0)
        
        // 可依需要微調飽和度，避免暗色太灰或失真
        color.saturation = min(color.saturation * 1.1, 1.0)
        
        return UIColor.br.fromHSL(color: color)
    }
    
    
}
