//
//  UIImageView+DSL.swift
//  BRUIKit
//
//  Created by BR on 2025/6/19.
//

import UIKit
import BRFoundation


public extension BRWrapper where Base: UIImageView {

    
    // MARK: - 圖片設定
    

    @MainActor
    @discardableResult
    func image(_ image: UIImage?) -> Base {
        base.image = image
        return base
    }

    
    @MainActor
    @discardableResult
    func image(named name: String) -> Base {
        base.image = UIImage(named: name)
        return base
    }

    
    @MainActor
    @discardableResult
    func highlightedImage(_ image: UIImage?) -> Base {
        base.highlightedImage = image
        return base
    }

    
    // MARK: - 顯示樣式

    
    @MainActor
    @discardableResult
    func contentMode(_ mode: UIView.ContentMode) -> Base {
        base.contentMode = mode
        return base
    }

    
    @MainActor
    @discardableResult
    func clipsToBounds(_ flag: Bool) -> Base {
        base.clipsToBounds = flag
        return base
    }

    
    @MainActor
    @discardableResult
    func cornerRadius(_ radius: CGFloat) -> Base {
        base.layer.cornerRadius = radius
        base.clipsToBounds = true
        return base
    }

    
    @MainActor
    @discardableResult
    func border(color: UIColor, width: CGFloat = 1) -> Base {
        base.layer.borderColor = color.cgColor
        base.layer.borderWidth = width
        return base
    }

    
    @MainActor
    @discardableResult
    func tintColor(_ color: UIColor) -> Base {
        base.tintColor = color
        return base
    }
    

    // MARK: - 狀態

    @MainActor
    @discardableResult
    func hidden(_ flag: Bool) -> Base {
        base.isHidden = flag
        return base
    }
    

    @MainActor
    @discardableResult
    func alpha(_ value: CGFloat) -> Base {
        base.alpha = value
        return base
    }
    

    @MainActor
    @discardableResult
    func isUserInteractionEnabled(_ enabled: Bool) -> Base {
        base.isUserInteractionEnabled = enabled
        return base
    }
    
    
}
