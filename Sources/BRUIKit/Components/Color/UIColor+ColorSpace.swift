//
//  UIColor+ColorSpace.swift
//  BRUIKit
//
//  Created by BR on 2025/8/12.
//

import BRFoundation
import UIKit


public extension BRWrapper where Base == UIColor {
    
    
    // MARK: - RGBA
    
    
    /// RGBA (紅/綠/藍/透明度)
    static func fromRGBA(color: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)) -> UIColor {
        UIColor(red: color.red, green: color.green, blue: color.blue, alpha: color.alpha)
    }
    
    
    /// RGB Hex Code
    static func fromRGBHex(_ hex: Int, alpha: CGFloat = 1.0) -> UIColor {
        UIColor(
            red: CGFloat(((hex >> 16) & 0xff)) / 255.0,
            green: CGFloat(((hex >> 8) & 0xff)) / 255.0,
            blue: CGFloat((hex & 0xff)) / 255.0,
            alpha: alpha
        )
    }
    
    
    /// RGBA (紅/綠/藍/透明度)
    func toRGBA() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        guard base.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        return (red, green, blue, alpha)
    }
    
    
    // MARK: - HSL
    
    
    /// HSL (色相/飽和度/亮度)
    static func fromHSL(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat = 1) -> UIColor {
        let chroma = (1 - abs(2 * lightness - 1)) * saturation
        let x = chroma * (1 - abs((hue * 6).truncatingRemainder(dividingBy: 2) - 1))
        let match = lightness - chroma / 2
        
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
        
        switch hue * 6 {
        case 0..<1:
            red = chroma
            green = x
            blue = 0
        case 1..<2:
            red = x
            green = chroma
            blue = 0
        case 2..<3:
            red = 0
            green = chroma
            blue = x
        case 3..<4:
            red = 0
            green = x
            blue = chroma
        case 4..<5:
            red = x
            green = 0
            blue = chroma
        case 5..<6:
            red = chroma
            green = 0
            blue = x
        default:
            red = 0
            green = 0
            blue = 0
        }
        
        return UIColor(red: red + match, green: green + match, blue: blue + match, alpha: alpha)
    }

    
    /// HSL (色相/飽和度/亮度)
    static func fromHSL(color: (hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat)) -> UIColor {
        UIColor.br.fromHSL(hue: color.hue, saturation: color.saturation, lightness: color.lightness, alpha: color.alpha)
    }
    
    
    /// HSL (色相/飽和度/亮度)
    func toHSL() -> (hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat)? {
        guard let color = base.br.toRGBA() else {
            return nil
        }
        let red = color.red
        let green = color.green
        let blue = color.blue
        let alpha = color.alpha
        
        let maxComponent = max(red, green, blue)
        let minComponent = min(red, green, blue)
        let delta = maxComponent - minComponent
        let lightness = (maxComponent + minComponent) / 2
        
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        
        if delta != 0 {
            saturation = delta / (1 - abs(2 * lightness - 1))
            if maxComponent == red {
                hue = ((green - blue) / delta).truncatingRemainder(dividingBy: 6)
            } else if maxComponent == green {
                hue = ((blue - red) / delta) + 2
            } else {
                hue = ((red - green) / delta) + 4
            }
            hue /= 6
            if hue < 0 { hue += 1 }
        }
        
        return (hue, saturation, lightness, alpha)
    }
    
    
}
