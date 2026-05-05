//
//  BRViewController+DSL.swift
//  BRUIKit
//
//  Created by BR on 2026/5/5.
//

import BRFoundation
import UIKit


@MainActor
public extension BRWrapper where Base: BRViewController {
    
    
    /// 設定 NavigationController Title
    @MainActor
    @discardableResult
    func onViewBoundsChanged(_ closure: ((CGRect) -> Void)?) -> Base {
        base.onViewBoundsChanged = closure
        return base
    }
    
    
}
