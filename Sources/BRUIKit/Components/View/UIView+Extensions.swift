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
    
    
    /// AutoLayout 約束允許的最小高度
    func compressedFittingHeight() -> CGFloat {
        base.layoutIfNeeded()
        
        let autoresizingMask = base.translatesAutoresizingMaskIntoConstraints
        
        base.translatesAutoresizingMaskIntoConstraints = false
        let targetSize = CGSize(width: base.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let fittingSize = base.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        base.translatesAutoresizingMaskIntoConstraints = autoresizingMask
        
        return fittingSize.height
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

