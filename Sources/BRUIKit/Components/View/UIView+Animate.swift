//
//  UIView+Animate.swift
//  BRUIKit
//
//  Created by BR on 2025/12/4.
//

import UIKit
import BRFoundation


public extension BRWrapper where Base: UIView {
    
    
    /// 震動動畫
    @MainActor func shake(duration: TimeInterval = 0.05, delta: CGFloat = 3, times: Int = 5) {
       UIView.animate(withDuration: duration, animations: {
          base.layer.setAffineTransform( CGAffineTransform(translationX: delta, y: 0))
       }) { (_) in
          if times != 0 {
             shake(duration: duration, delta: delta * -1, times: times - 1)
          } else {
             UIView.animate(withDuration: duration) {
                 base.layer.setAffineTransform(CGAffineTransform.identity)
             }
          }
       }
    }
    
    
}
