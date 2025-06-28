//
//  UIImage+Color.swift
//  BRUIKit
//
//  Created by BR on 2025/3/30.
//

import UIKit
import BRFoundation

extension BRWrapper where Base: UIImage {
    
    
    /// 為單色圖片替換色彩
    public func tinted(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        
        guard let context = UIGraphicsGetCurrentContext() else { return base }
        
        let rect = CGRect(origin: .zero, size: base.size)
        
        // 繪製原始圖片，確保透明度不會被填滿
        base.draw(in: rect)
        
        // 設置混合模式，確保僅影響非透明區域
        context.setBlendMode(.sourceAtop)
        color.setFill()
        context.fill(rect)
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? base
    }
    
    
    /// 建立指定顏色與尺寸的純色圖片
    public static func image(with color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }

        color.setFill()
        UIBezierPath(rect: CGRect(origin: .zero, size: size)).fill()

        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
    
    
}
