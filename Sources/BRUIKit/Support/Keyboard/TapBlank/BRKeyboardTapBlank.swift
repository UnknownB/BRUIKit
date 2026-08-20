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
final class BRKeyboardTapBlank: NSObject, UIGestureRecognizerDelegate {
    
    
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
    private let excludedViews = NSHashTable<UIView>.weakObjects()
    
    
    func addGesture(with session: BRKeyboardSession) {
        if tapBlankGesture?.view != session.viewController.view {
            removeGesture()
            let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapBlank))
            gesture.cancelsTouchesInView = false
            gesture.delegate = self
            session.viewController.view.addGestureRecognizer(gesture)
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
        DispatchQueue.main.async {
            BRKeyboard.dismissKeyboard()
        }
    }
    
    
    // MARK: - 排除視圖
    
    
    func addExcludedView(_ view: UIView) {
        excludedViews.add(view)
    }
    
    
    func removeExcludedView(_ view: UIView) {
        excludedViews.remove(view)
    }
    
    
    private func isExcluded(_ view: UIView) -> Bool {
        excludedViews.allObjects.contains { view.isDescendant(of: $0) }
    }
    
    
    // MARK: - UIGestureRecognizerDelegate
    
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchedView = touch.view else {
            return true
        }
        return !isExcluded(touchedView)
    }

    
}
