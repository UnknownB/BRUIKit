//
//  UIView+DSL.swift
//  BRUIKit
//
//  Created by BR on 2025/6/26.
//

import UIKit
import BRFoundation


public extension BRWrapper where Base: UIView {
    
    
    // MARK: - 顯示樣式
    
    
    @MainActor
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Base {
        base.backgroundColor = color
        return base
    }
    
    
    @MainActor
    @discardableResult
    func tintColor(_ color: UIColor) -> Base {
        base.tintColor = color
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
    func clipsToBounds(_ flag: Bool) -> Base {
        base.clipsToBounds = flag
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
    func contentMode(_ mode: UIView.ContentMode) -> Base {
        base.contentMode = mode
        return base
    }
    
    
    // MARK: - 狀態
    
    
    @MainActor
    @discardableResult
    func alpha(_ value: CGFloat) -> Base {
        base.alpha = value
        return base
    }
    
    
    @MainActor
    @discardableResult
    func hidden(_ hidden: Bool) -> Base {
        base.isHidden = hidden
        return base
    }
    
    
    @MainActor
    @discardableResult
    func userInteractionEnabled(_ enabled: Bool) -> Base {
        base.isUserInteractionEnabled = enabled
        return base
    }
    
    
    @MainActor
    @discardableResult
    func tag(_ tag: Int) -> Base {
        base.tag = tag
        return base
    }
    
    
    // MARK: - Layout
    
    
    @MainActor
    @discardableResult
    func translatesAutoresizingMaskIntoConstraints(_ flag: Bool) -> Base {
        base.translatesAutoresizingMaskIntoConstraints = flag
        return base
    }
    
    
    @MainActor
    @discardableResult
    func frame(_ frame: CGRect) -> Base {
        base.frame = frame
        return base
    }
    
    
    @MainActor
    @discardableResult
    func addSubView(_ view: UIView) -> Base {
        base.addSubview(view)
        return base
    }
    
    
    /// 添加霧玻璃底圖
    /// - Parameter style: 霧玻璃樣式
    @MainActor
    @discardableResult
    func insertBlurEffect(_ style: UIBlurEffect.Style, at index: Int = 0) -> Base {
        let effect = UIBlurEffect(style: style)
        let effectView = UIVisualEffectView(effect: effect)
        base.insertSubview(effectView, at: index)
        BRLayout().activate {
            effectView.br.top == base.br.top
            effectView.br.left == base.br.left
            effectView.br.bottom == base.br.bottom
            effectView.br.right == base.br.right
        }
        return base
    }
    
    
}
