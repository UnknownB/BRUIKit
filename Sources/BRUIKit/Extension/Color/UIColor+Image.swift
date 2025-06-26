//
//  UIColor+Image.swift
//  BRUIKit
//
//  Created by BR on 2025/6/26.
//

import BRFoundation
import UIKit


public extension BRWrapper where Base == UIColor {
    
    
    /// 從 UIColor 生成純色 UIImage
    func toImage(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIImage.br.image(with: base, size: size)
    }
    
    
}
