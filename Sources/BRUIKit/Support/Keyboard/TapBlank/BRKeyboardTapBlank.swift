//
//  BRKeyboardTapBlank.swift
//  BRUIKit
//
//  Created by BR on 2026/1/5.
//

import BRFoundation
import UIKit


/// 封裝鍵盤升起時，點擊空白處關閉鍵盤功能
@MainActor
final class BRKeyboardTapBlank {
    
    
    /// 啟用點擊空白處收起鍵盤，預設為 true
    public var enableTapBlankToDismissKeyboard: Bool = true {
        didSet {
            if enableTapBlankToDismissKeyboard {
                if let session = BRKeyboard.session {
                    addGesture(with: session)
                }
            } else {
                removeGesture()
            }
        }
    }
    
    private var tapBlankGesture: UITapGestureRecognizer?
    
    
    func addGesture(with session: BRKeyboardSession) {
        if tapBlankGesture?.view != session.containerView {
            removeGesture()
            let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapBlank))
            gesture.cancelsTouchesInView = false
            session.containerView.addGestureRecognizer(gesture)
            tapBlankGesture = gesture
        }
    }


    func removeGesture() {
        guard let gesture = tapBlankGesture else {
            return
        }
        gesture.view?.removeGestureRecognizer(gesture)
        tapBlankGesture = nil
    }


    @objc private func onTapBlank(_ gesture: UITapGestureRecognizer) {
        BRKeyboard.dismissKeyboard()
    }
    
    
}
