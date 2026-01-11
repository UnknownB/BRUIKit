//
//  BRKeyboardLayout.swift
//  BRUIKit
//
//  Created by BR on 2026/1/5.
//

import BRFoundation
import UIKit


@MainActor
final class BRKeyboardLayout {
    
    enum LayoutMode: String {
        case offset
        case scroll
    }
    
    
    /// 鍵盤與焦點元件的最小間距
    var keyboardPadding: CGFloat = 20 {
        didSet {
            if let session = BRKeyboard.session, let keyboard = BRKeyboard.keyboardContext {
                moveUp(session: session, keyboard: keyboard, isKeyboardVisible: BRKeyboard.isKeyboardVisible)
            }
        }
    }
    

    private var layoutMode: LayoutMode? = nil
    private var originalScrollViewBottomInset: CGFloat? = nil
    
    
    func moveUp(session: BRKeyboardSession, keyboard: BRKeyboardContext, isKeyboardVisible: Bool) -> LayoutMode {
        let layoutMode = self.layoutMode ?? layoutMode(with: session.viewController, and: keyboard)
        
        switch layoutMode {
        case .offset:
            handleOffsetMode(session: session, keyboard: keyboard)
        case .scroll:
            handleScrollMode(session: session, keyboard: keyboard, isKeyboardVisible: isKeyboardVisible)
        }
        self.layoutMode = layoutMode
        
        return layoutMode
    }
    
    
    func moveDown(session: BRKeyboardSession?, keyboard: BRKeyboardContext, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: keyboard.animationDuration, delay: 0, options: keyboard.animationOptions) {
            let originalFrame = session?.responder.window?.frame ?? .zero
            session?.containerView.frame = originalFrame
            if self.originalScrollViewBottomInset != nil {
                guard let anchorScrollView = session?.responder.br.findSuperview(of: UIScrollView.self) else { return }
                anchorScrollView.contentInset.bottom = self.originalScrollViewBottomInset!
                anchorScrollView.scrollIndicatorInsets.bottom = self.originalScrollViewBottomInset!
            }
        } completion: { _ in
            self.layoutMode = nil
            self.originalScrollViewBottomInset = nil
            completion?()
        }
    }

    
    // MARK: - Private
    
    
    private func layoutMode(with activeViewController: UIViewController, and keyboard: BRKeyboardContext) -> LayoutMode {
        let sortedScrollViews = activeViewController.view!.br.findSubviews(of: UIScrollView.self).sorted { $0.frame.height > $1.frame.height }
        
        for scrollView in sortedScrollViews {
            if scrollView.bounds.height > keyboard.frame.height && scrollView.br.canDecreaseHeight() {
                return .scroll
            }
        }
        return .offset
    }
    
    
    private func handleOffsetMode(session: BRKeyboardSession, keyboard: BRKeyboardContext) {
        let responderFrame = session.responder.convert(session.responder.bounds, to: session.containerView)
        let toolbarHeight = session.responder.inputAccessoryView?.bounds.height ?? 0
        let keyboardTop = keyboard.frame.minY + toolbarHeight
        let keyboardPadding = (session.responder as? BRResponderProtocol)?.keyboardPadding ?? self.keyboardPadding

        let overlap = responderFrame.maxY - keyboardTop + keyboardPadding
        
        guard overlap > 0 else {
            return
        }

        UIView.animate(withDuration: keyboard.animationDuration, delay: 0, options: keyboard.animationOptions) {
            let originalFrame = session.responder.window?.frame ?? .zero
            session.containerView.frame = originalFrame.offsetBy(dx: 0, dy: -overlap)
        }
    }
    
    
    private func handleScrollMode(session: BRKeyboardSession, keyboard: BRKeyboardContext, isKeyboardVisible: Bool) {
        UIView.animate(withDuration: keyboard.animationDuration, delay: 0, options: keyboard.animationOptions) {
            
            guard let anchorScrollView = session.responder.br.findSuperview(of: UIScrollView.self) else { return }
            
            if self.originalScrollViewBottomInset == nil {
                self.originalScrollViewBottomInset = anchorScrollView.contentInset.bottom
            }
            
            // 調整 containerView 高度時，觸發系統自動滾動，補充 contenInset 可以自然調整滾動間距
            let toolbarHeight = session.responder.inputAccessoryView?.bounds.height ?? 0
            let keyboardPadding = (session.responder as? BRResponderProtocol)?.keyboardPadding ?? self.keyboardPadding
            let bottomInset = keyboardPadding + toolbarHeight
            anchorScrollView.contentInset.bottom = bottomInset
            anchorScrollView.scrollIndicatorInsets.bottom = bottomInset
            
            // 校正常數：補償 tabBar / 系統邊界殘留
            let safeAreaCoverAdjustment = 40.0
            
            let originalFrame = session.responder.window?.frame ?? .zero
            let keyboardHeight = keyboard.frame.height
            let safeAreaBottomInset = session.viewController.view.safeAreaInsets.bottom
            let cutHeight = keyboardHeight - safeAreaBottomInset - safeAreaCoverAdjustment
            session.containerView.frame = originalFrame.inset(by: .init(top: 0, left: 0, bottom: cutHeight, right: 0))
        }
    }
    
    
}
