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
    @MainActor
    func animateShake(duration: TimeInterval = 0.05, delta: CGFloat = 3, times: Int = 5) {
        UIView.animate(withDuration: duration, animations: {
            base.layer.setAffineTransform( CGAffineTransform(translationX: delta, y: 0))
        }) { (_) in
            if times != 0 {
                animateShake(duration: duration, delta: delta * -1, times: times - 1)
            } else {
                UIView.animate(withDuration: duration) {
                    base.layer.setAffineTransform(CGAffineTransform.identity)
                }
            }
        }
    }
    
    
    /// 向上下兩側展開動畫
    @MainActor
    @discardableResult
    func animateExpandVertically(duration: TimeInterval = 0.25) -> Base {
        base.alpha = 0
        base.transform = CGAffineTransform(scaleX: 1, y: 0.01)

        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
            base.isHidden = false
            base.alpha = 1
            base.transform = .identity
        }
        return base
    }
    
    
    /// 從上下兩側收合動畫
    @MainActor
    @discardableResult
    func animateCollapseVertically(duration: TimeInterval = 0.2) -> Base {
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn, .allowUserInteraction]) {
            base.alpha = 0
            base.transform = CGAffineTransform(scaleX: 1, y: 0.01)
        } completion: { _ in
            base.isHidden = true
        }
        return base
    }
    
    
    /// 向左右兩側展開動畫
    @MainActor
    @discardableResult
    func animateExpandHorizontally(duration: TimeInterval = 0.25) -> Base {
        base.alpha = 0
        base.transform = CGAffineTransform(scaleX: 0.01, y: 1)

        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
            base.isHidden = false
            base.alpha = 1
            base.transform = .identity
        }
        return base
    }
    
    
    /// 從左右兩側收合動畫
    @MainActor
    @discardableResult
    func animateCollapseHorizontally(duration: TimeInterval = 0.2) -> Base {
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn, .allowUserInteraction]) {
            base.alpha = 0
            base.transform = CGAffineTransform(scaleX: 0.01, y: 1)
        } completion: { _ in
            base.isHidden = true
        }
        return base
    }
    
    
    /// 從上方向下浮現滑入
    @MainActor
    @discardableResult
    func animateShowDownIn(duration: TimeInterval = 0.2, offset: CGFloat = 50, completion: (() -> Void)? = nil) -> Base {
        base.alpha = 0
        base.transform = CGAffineTransform(translationX: 0, y: -offset)

        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
            base.alpha = 1
            base.transform = .identity
        } completion: { _ in
            completion?()
        }
        return base
    }
    
    
    /// 從下方向上消失滑出
    @MainActor
    @discardableResult
    func animateHideUpOut(duration: TimeInterval = 0.2, offset: CGFloat = 50, completion: (() -> Void)? = nil) -> Base {
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
            base.alpha = 0
            base.transform = CGAffineTransform(translationX: 0, y: -offset)
        } completion: { _ in
            base.transform = .identity
            completion?()
        }
        return base
    }

    
}
