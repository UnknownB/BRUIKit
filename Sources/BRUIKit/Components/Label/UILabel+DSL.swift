//
//  UILabel+DSL.swift
//  BRUIKit
//
//  Created by BR on 2025/6/19.
//

import BRFoundation
import UIKit


public extension BRWrapper where Base: UILabel {

    
    @MainActor
    @discardableResult
    func text(_ string: String?) -> Base {
        base.text = string
        return base
    }
    
    
    @MainActor
    @discardableResult
    func font(_ weight: UIFont.Weight, _ size: CGFloat) -> Base {
        base.font = UIFont.br.font(weight, size: size)
        return base
    }

    
    @MainActor
    @discardableResult
    func font(_ weight: BRFontWeight, _ size: CGFloat) -> Base {
        base.font = UIFont.br.font(weight, size: size)
        return base
    }
    
    
    @MainActor
    @discardableResult
    func font(_ font: UIFont) -> Base {
        base.font = font
        return base
    }

    
    @MainActor
    @discardableResult
    func color(_ color: UIColor) -> Base {
        base.textColor = color
        return base
    }

    
    @MainActor
    @discardableResult
    func alignment(_ alignment: NSTextAlignment) -> Base {
        base.textAlignment = alignment
        return base
    }
    
    
    @MainActor
    @discardableResult
    func sizeToFit() -> Base {
        base.sizeToFit()
        return base
    }
    
    
    @MainActor
    @discardableResult
    func lines(_ number: Int) -> Base {
        base.numberOfLines = number
        return base
    }
    
    
    /// 設定行距（line spacing）
    @MainActor
    @discardableResult
    func lineSpacing(_ spacing: CGFloat) -> Base {
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

    
    @MainActor
    @discardableResult
    func minimumScaleFactor(_ scale: CGFloat) -> Base {
        base.adjustsFontSizeToFitWidth = true
        base.minimumScaleFactor = scale
        return base
    }
    
    
}
