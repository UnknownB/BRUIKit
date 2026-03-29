//
//  BRView+DSL.swift
//  BRUIKit
//
//  Created by BR on 2026/3/12.
//

import UIKit
import BRFoundation


public extension BRWrapper where Base: BRView {
    
    
    /// 設定 contentView 的內縮值
    @MainActor
    @discardableResult
    func contentInsets(_ inset: UIEdgeInsets) -> Base {
        base.contentInsets = inset
        return base
    }
    
    
}
