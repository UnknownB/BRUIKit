//
//  BRButtonTip.swift
//  BRUIKit
//
//  Created by BR on 2026/7/22.
//

import Foundation
import UIKit


/// 設定 Button 長按提示
@MainActor
final public class BRButtonTip {
    
    public var tip: String?
    
    private weak var button: BRButton?
    
    public var tipLabel = BRTipLabel()

    
    public func setup(from button: BRButton) {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
        button.addGestureRecognizer(gesture)
        self.button = button
    }
    

    @objc private func onLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard let tip else {
            return
        }
        
        switch gesture.state {
        case .began:
            showTipView(tip)
        case .ended, .cancelled, .failed:
            hideTipView()
        default:
            break
        }
    }


    private func showTipView(_ tip: String) {
        guard let button else {
            return
        }
        tipLabel.show(tip: tip, above: button)
    }


    private func hideTipView() {
        tipLabel.removeFromSuperview()
    }


}
