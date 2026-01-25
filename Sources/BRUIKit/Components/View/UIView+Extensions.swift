//
//  UIView+Extensions.swift
//  BRUIKit
//
//  Created by BR on 2025/10/9.
//

import UIKit
import BRFoundation


@MainActor
public extension BRWrapper where Base: UIView {
    
    
    /// 是否允許減少高度
    @MainActor
    func canDecreaseHeight() -> Bool {
        if base.constraints.contains(where: {
            $0.firstItem === base &&
            $0.firstAttribute == .height &&
            $0.relation != .lessThanOrEqual &&
            $0.priority == .required
        }) {
            return false
        }
        guard let superview = base.superview else {
            return false
        }
        var other: UIView? = nil
        
        for constraint in superview.constraints where constraint.isActive && (constraint.firstItem as? UIView) === base {
            guard let secondItem = constraint.secondItem as? UIView else {
                continue
            }
            if constraint.firstAttribute == .height && constraint.relation == .equal {
                return secondItem.br.canDecreaseHeight()
            }
            if constraint.firstAttribute == .top && constraint.secondAttribute == .top && constraint.relation == .equal {
                if other == nil {
                    other = secondItem
                } else if other === secondItem {
                    return secondItem.br.canDecreaseHeight()
                }
            }
            if constraint.firstAttribute == .bottom && constraint.secondAttribute == .bottom && constraint.relation == .equal {
                if other == nil {
                    other = secondItem
                } else if other === secondItem {
                    return secondItem.br.canDecreaseHeight()
                }
            }
        }
        
        other = nil
        
        for constraint in superview.constraints where constraint.isActive && (constraint.secondItem as? UIView) === base {
            guard let firstItem = constraint.firstItem as? UIView else {
                continue
            }
            if constraint.firstAttribute == .height && constraint.relation == .equal {
                return firstItem.br.canDecreaseHeight()
            }
            
            if constraint.firstAttribute == .top && constraint.secondAttribute == .top && constraint.relation == .equal {
                if other == nil {
                    other = firstItem
                } else if other === firstItem {
                    return firstItem.br.canDecreaseHeight()
                }
            }
            if constraint.firstAttribute == .bottom && constraint.secondAttribute == .bottom && constraint.relation == .equal {
                if other == nil {
                    other = firstItem
                } else if other === firstItem {
                    return firstItem.br.canDecreaseHeight()
                }
            }
        }
        return true
    }
    
    
    /// 從響應鏈中取得 UIViewController，如果 UIView 未加入視圖會獲得 nil
    func viewController() -> UIViewController? {
        if let nextResponder = base.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = base.next as? UIView {
            return nextResponder.br.viewController()
        }
        return nil
    }
    
    
    /// 向上查找指定型別的 UIView
    ///
    /// ```swift
    /// let scrollView = view.br.findSuperview(of: UIScrollView.self)
    /// ```
    func findSuperview<T: UIView>(of type: T.Type) -> T? {
        guard let superview = base.superview else {
            return nil
        }
        
        if let view = superview as? T {
            return view
        }
        
        return superview.br.findSuperview(of: type)
    }
    
    
    /// 向下查找第一個指定型別的 UIView（深度優先）
    ///
    /// ```swift
    /// let textField = view.br.findSubview(of: UITextField.self)
    /// ```
    func findSubview<T: UIView>(of type: T.Type) -> T? {
        for subview in base.subviews {
            if let view = subview as? T {
                return view
            }
            
            if let found = subview.br.findSubview(of: type) {
                return found
            }
        }
        
        return nil
    }
    
    
    /// 向下查找所有指定型別的 UIView（深度優先）
    ///
    /// ```swift
    /// let textFields = view.br.findSubviews(of: UITextField.self)
    /// ```
    func findSubviews<T: UIView>(of type: T.Type) -> [T] {
        var result: [T] = []
        
        for subview in base.subviews {
            if let view = subview as? T {
                result.append(view)
            }
            result.append(contentsOf: subview.br.findSubviews(of: type))
        }
        
        return result
    }
    
    
}

