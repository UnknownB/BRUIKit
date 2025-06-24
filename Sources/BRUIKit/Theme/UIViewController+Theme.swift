//
//  UIViewController+Theme.swift
//  BRUIKit
//
//  Created by BR on 2025/6/23.
//

import BRFoundation
import UIKit


public extension BRWrapper where Base: UIViewController {
    
    
    /// 添加 theme closure 進 `BRThemeEngine`
    ///
    /// ``` swift
    /// self.br.theme {
    ///     $0.view.backgroundColor = Theme.backgroundColor
    /// }
    /// ```
    @MainActor
    @discardableResult
    func theme(_ closure: @escaping (Base) -> Void) -> Base {
        BRThemeEngine.shared.register(target: base, closure: closure)
        return base
    }
        
    
}
