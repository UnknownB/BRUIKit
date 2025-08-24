//
//  UIImage+Make.swift
//  BRUIKit
//
//  Created by BR on 2025/8/12.
//

import UIKit
import BRFoundation

extension BRWrapper where Base: UIImage {
    
    
    /// 文字頭像
    public static func textAvatar(
        with text: String,
        font: UIFont? = nil,
        avatarSize: CGFloat = 40,
        textColor: UIColor? = nil,
        backgroundColor: UIColor = .cyan,
        cornerRadius: CGFloat? = nil
    ) -> UIImage {
        let text = String(text.prefix(2))
        let imageSize = CGSize(width: avatarSize, height: avatarSize)
        let renderer = UIGraphicsImageRenderer(size: imageSize)
        
        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: imageSize)
            
            // 背景形狀
            let radius = cornerRadius ?? avatarSize / 2
            let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
            backgroundColor.setFill()
            path.fill()
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: font ?? UIFont.systemFont(ofSize: avatarSize * 0.4, weight: .medium),
                .foregroundColor: textColor ?? backgroundColor.br.readable()
            ]
            
            let textSize = text.size(withAttributes: attrs)
            let textRect = CGRect(
                x: (avatarSize - textSize.width) / 2,
                y: (avatarSize - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            text.draw(in: textRect, withAttributes: attrs)
        }
    }
    
    
}
