//
//  UIButton+DSL.swift
//  BRUIKit
//
//  Created by BR on 2025/6/19.
//

import UIKit
import BRFoundation


public extension BRWrapper where Base: UIButton {

    
    // MARK: - 按鈕設定

    
    @MainActor
    @discardableResult
    func title(_ string: String?, for state: UIControl.State = .normal) -> Base {
        base.setTitle(string, for: state)
        return base
    }

    
    @MainActor
    @discardableResult
    func titleColor(_ color: UIColor?, for state: UIControl.State = .normal) -> Base {
        base.setTitleColor(color, for: state)
        return base
    }

    
    @MainActor
    @discardableResult
    func image(_ image: UIImage?, for state: UIControl.State = .normal) -> Base {
        base.setImage(image, for: state)
        return base
    }

    
    @MainActor
    @discardableResult
    func backgroundImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Base {
        base.setBackgroundImage(image, for: state)
        return base
    }
    
    
    @MainActor
    @discardableResult
    func font(_ weight: UIFont.Weight, _ size: CGFloat) -> Base {
        base.titleLabel?.font = .br.font(weight, size: size)
        return base
    }

    
    @MainActor
    @discardableResult
    func font(_ weight: BRFontWeight, _ size: CGFloat) -> Base {
        base.titleLabel?.font = .br.font(weight, size: size)
        return base
    }

    
    @MainActor
    @discardableResult
    func font(_ font: UIFont) -> Base {
        base.titleLabel?.font = font
        return base
    }
        

    @MainActor
    @discardableResult
    func alignment(_ alignment: NSTextAlignment) -> Base {
        base.titleLabel?.textAlignment = alignment
        return base
    }
    

    @MainActor
    @discardableResult
    func lines(_ number: Int) -> Base {
        base.titleLabel?.numberOfLines = number
        return base
    }
    
    
    // MARK: - 圖片位置
    

    @MainActor
    @discardableResult
    func imagePadding(_ spacing: CGFloat) -> Base {
        base.setImage(base.image(for: .normal), for: .normal) // 重新觸發 layout
        base.imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing / 2, bottom: 0, right: spacing / 2)
        base.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing / 2, bottom: 0, right: -spacing / 2)
        return base
    }
    

    @MainActor
    @discardableResult
    func contentInsets(_ insets: UIEdgeInsets) -> Base {
        base.contentEdgeInsets = insets
        return base
    }
    
    
    /// 水平對齊設定
    @MainActor
    @discardableResult
    func contentHorizontalAlignment(_ alignment: UIControl.ContentHorizontalAlignment) -> Base {
        base.contentHorizontalAlignment = alignment
        return base
    }
    
    
    /// 垂直對齊設定
    @MainActor
    @discardableResult
    func contentVerticalAlignment(_ alignment: UIControl.ContentVerticalAlignment) -> Base {
        base.contentVerticalAlignment = alignment
        return base
    }

    
    // MARK: 狀態
    

    @MainActor
    @discardableResult
    func enabled(_ isEnabled: Bool) -> Base {
        base.isEnabled = isEnabled
        return base
    }

    
    @MainActor
    @discardableResult
    func selected(_ isSelected: Bool) -> Base {
        base.isSelected = isSelected
        return base
    }
    

    @MainActor
    @discardableResult
    func highlighted(_ isHighlighted: Bool) -> Base {
        base.isHighlighted = isHighlighted
        return base
    }
    
    
    // MARK: 事件
    
    
    @MainActor
    @discardableResult
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event = .touchUpInside) -> Base {
        base.addTarget(target, action: action, for: controlEvents)
        return base
    }
    
    
    @available(iOS 14.0, *)
    @MainActor
    @discardableResult
    func onTap(_ handler: @escaping () -> Void) -> Base {
        let action = UIAction { _ in handler() }
        base.addAction(action, for: .touchUpInside)
        return base
    }
    
    
}
