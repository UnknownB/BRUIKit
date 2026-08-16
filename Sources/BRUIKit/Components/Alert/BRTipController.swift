//
//  BRTipController.swift
//  BRUIKit
//
//  Created by BR on 2026/8/11.
//

import UIKit


/// 顯示簡單的提示訊息
open class BRTipController: BRViewController {
    public let tipLabel = BRTipLabel()
    
    
    open override func setupUI() {
        super.setupUI()
        view.backgroundColor = .clear
        tipLabel.alpha = 0
    }
    
    
    open func show(tip: String, above target: UIView, in viewController: UIViewController? = nil, completion: (() -> Void)? = nil) {
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        self.br.show(in: viewController, animated: false)
        tipLabel.show(tip: tip, above: target)
        tipLabel.br.animateExpandHorizontally(completion: completion)
    }
    
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        tipLabel.br.animateCollapseHorizontally {
            self.tipLabel.removeFromSuperview()
        }
        self.dismiss(animated: false)
    }
    
    
}
