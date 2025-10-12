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
    
    
    /// 從響應鏈中取得 UIViewController，如果 UIView 未加入視圖會獲得 nil
    func viewController() -> UIViewController? {
        if let nextResponder = base.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = base.next as? UIView {
            return nextResponder.br.viewController()
        }
        return nil
    }
    
    
}

