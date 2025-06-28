//
//  UIButton+State.swift
//  BRUIKit
//
//  Created by BR on 2025/3/31.
//

import UIKit
import BRFoundation

extension BRWrapper where Base: UIButton {
    
    
    @MainActor public func disableHighlighted() {
        if #available(iOS 15.0, *) {
            var configuration = base.configuration ?? UIButton.Configuration.plain()
            configuration.background.backgroundColor = .clear
            base.configuration = configuration
        } else {
            base.adjustsImageWhenHighlighted = false
        }
    }
    
    
}
