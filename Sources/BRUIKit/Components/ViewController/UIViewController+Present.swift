//
//  UIViewController+Present.swift
//  BRUIKit
//
//  Created by BR on 2025/10/9.
//

import BRFoundation
import UIKit


@MainActor
public extension BRWrapper where Base: UIViewController {
    
    
    
    /// 從指定的 `UIViewController` present
    func show(in viewController: UIViewController?, animated: Bool = true, completion: (() -> Void)? = nil) {
        viewController?.present(base, animated: animated, completion: completion)
    }

    
}
