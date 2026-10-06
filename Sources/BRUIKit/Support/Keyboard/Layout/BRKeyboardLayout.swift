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
        case inset
        case resize
        case offset
    }
    
    
    /// 鍵盤與焦點元件的最小間距
    var keyboardPadding: CGFloat = 20 {
        didSet {
            if let session = BRKeyboard.session, let keyboard = BRKeyboard.keyboardContext {
                moveUp(session: session, keyboard: keyboard)
            }
        }
    }
    
    
    /// 鍵盤是否顯示中
    public private(set) var isKeyboardVisible: Bool = false
    

    private var layoutMode: LayoutMode? = nil
    private var originalScrollViewBottomInset: CGFloat? = nil
    private var mainScrollView: UIScrollView? = nil
    private var lastResponderMinY: CGFloat = 0
    private var originalContainerFrame: CGRect? = nil

    /// resize 模式期間被暫時調整的 VC 與其原始 additionalSafeAreaInsets.bottom，於 moveDown 還原
    private weak var resizedViewController: UIViewController? = nil
    private var originalViewControllerBottomInset: CGFloat = 0
    private var baselineSafeAreaBottomInset: CGFloat = 0

    private weak var navigationBarHiddenController: UINavigationController? = nil


    /// 焦點元件用來計算捲動位置的區域
    ///
    /// - 一般 view 使用自身 bounds
    /// - `UITextView` 因為高度可能很高，改用游標所在位置，避免鍵盤彈出時捲動到整個 UITextView 的底部
    private func responderRect(for responder: UIView) -> CGRect {
        guard let textView = responder as? UITextView else {
            return responder.bounds
        }

        let position = textView.selectedTextRange?.end ?? textView.endOfDocument
        let caretRect = textView.caretRect(for: position)
        guard !caretRect.isNull, !caretRect.isInfinite else {
            return responder.bounds
        }

        return caretRect
    }
    
    
    /// 當空間緊繃時，隱藏導覽列爭取可視空間
    private func hideNavigationBarIfNeeded(session: BRKeyboardSession) {
        guard navigationBarHiddenController == nil,
              !session.isResponderInNavigationBar,
              session.viewController.traitCollection.verticalSizeClass == .compact,
              let navigationController = session.viewController.navigationController,
              !navigationController.isNavigationBarHidden
        else {
            return
        }
        navigationBarHiddenController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    
    @discardableResult
    func moveUp(session: BRKeyboardSession, keyboard: BRKeyboardContext) -> LayoutMode {
        hideNavigationBarIfNeeded(session: session)

        let layoutMode = self.layoutMode ?? resolveLayoutMode(with: session, and: keyboard)
        
        switch layoutMode {
        case .inset:
            applyInsetLayout(session: session, keyboard: keyboard)
        case .resize:
            applyResizeLayout(session: session, keyboard: keyboard)
        case .offset:
            applyOffsetLayout(session: session, keyboard: keyboard)
        }
        self.layoutMode = layoutMode
        self.isKeyboardVisible = true
        
        return layoutMode
    }
    
    
    func moveDown(session: BRKeyboardSession?, keyboard: BRKeyboardContext, completion: (() -> Void)? = nil) {
        if BRKeyboard.enableDebugLog {
            #BRLog(.library, .debug, #function)
        }
        let resizedViewController = self.resizedViewController
        let anchorScrollView = self.mainScrollView
        let originalViewControllerBottomInset = self.originalViewControllerBottomInset
        let originalScrollViewBottomInset = self.originalScrollViewBottomInset
        let originalContainerFrame = self.originalContainerFrame
        let navigationBarHiddenController = self.navigationBarHiddenController

        self.layoutMode = nil
        self.originalScrollViewBottomInset = nil
        self.originalContainerFrame = nil
        self.mainScrollView = nil
        self.lastResponderMinY = 0
        self.resizedViewController = nil
        self.navigationBarHiddenController = nil
        self.isKeyboardVisible = false

        UIView.animate(withDuration: keyboard.animationDuration, delay: 0, options: keyboard.animationOptions) {
            navigationBarHiddenController?.setNavigationBarHidden(false, animated: true)
            if let originalContainerFrame {
                session?.containerView.frame = originalContainerFrame
                session?.containerView.setNeedsLayout()
                session?.containerView.layoutIfNeeded()
            }
            if let resizedViewController {
                resizedViewController.additionalSafeAreaInsets.bottom = originalViewControllerBottomInset
                resizedViewController.view.layoutIfNeeded()
            }
            if let anchorScrollView, let originalScrollViewBottomInset {
                anchorScrollView.contentInset.bottom = originalScrollViewBottomInset
                anchorScrollView.verticalScrollIndicatorInsets.bottom = originalScrollViewBottomInset
            }
        } completion: { _ in
            completion?()
        }
    }

    
    // MARK: - Private
    
    
    private func resolveLayoutMode(with session: BRKeyboardSession, and keyboard: BRKeyboardContext) -> LayoutMode {
        let rootView = session.viewController.view!
        
        if let scrollView = session.responder.br.findSuperview(of: UIScrollView.self), scrollView.isScrollEnabled {
            mainScrollView = scrollView
            return .inset
        }
        
        let fittingHeight = rootView.br.compressedFittingHeight()
        let maxShrink = rootView.bounds.height - fittingHeight
        let keyboardHeight = keyboard.frame.height
        
        if BRKeyboard.enableDebugLog {
            #BRLog(.library, .debug, "view: \(rootView.bounds.height), fitting:\(fittingHeight), maxShrink: \(maxShrink), keyboard:\(keyboardHeight)")
        }
        
        if maxShrink >= keyboardHeight {
            return .resize
        }
        
        return .offset
    }
    
    
    private func applyInsetLayout(session: BRKeyboardSession, keyboard: BRKeyboardContext) {
        guard let scrollView = mainScrollView, let rootView = session.viewController.view else {
            return
        }
        
        if self.originalScrollViewBottomInset == nil {
            self.originalScrollViewBottomInset = scrollView.contentInset.bottom
        }
        
        rootView.layoutIfNeeded()
        
        let scrollViewRect = scrollView.convert(scrollView.bounds, to: rootView)
        let keyboardPadding = (session.responder as? BRResponderProtocol)?.keyboardPadding ?? self.keyboardPadding
        let keyboardMinY = rootView.convert(keyboard.frame, from: nil).minY
        let overlap = scrollViewRect.maxY - keyboardMinY
        
        guard overlap > 0 else {
            return
        }
        
        let responderFrame = session.responder.convert(responderRect(for: session.responder), to: scrollView)
        let bottomInset = max(overlap, responderFrame.maxY + keyboardPadding + overlap - scrollView.contentSize.height)
        let maxOffsetY = max(0, scrollView.contentSize.height + bottomInset - scrollView.bounds.height)
        let visibleOffsetY = responderFrame.maxY + keyboardPadding + overlap - scrollView.bounds.height
        
        var offsetY = scrollView.contentOffset.y
        
        if visibleOffsetY > offsetY {
            offsetY = min(visibleOffsetY, maxOffsetY)
        } else if responderFrame.minY < offsetY {
            offsetY = max(responderFrame.minY, 0)
        }
        
        let duration = lastResponderMinY > responderFrame.minY ? 0.2 : 0.0
        
        UIView.animate(withDuration: duration) {
            scrollView.contentInset.bottom = bottomInset
            scrollView.verticalScrollIndicatorInsets.bottom = overlap
        } completion: { _ in
            self.lastResponderMinY = responderFrame.minY
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: offsetY), animated: true)
        }
    }
    
    
    private func applyOffsetLayout(session: BRKeyboardSession, keyboard: BRKeyboardContext) {
        let responderFrame = session.responder.convert(responderRect(for: session.responder), to: session.containerView)
        let keyboardAndToolbarTop = keyboard.frame.minY
        let keyboardPadding = (session.responder as? BRResponderProtocol)?.keyboardPadding ?? self.keyboardPadding

        let overlap = responderFrame.maxY - keyboardAndToolbarTop + keyboardPadding
        
        guard overlap > 0 else {
            return
        }

        if originalContainerFrame == nil {
            originalContainerFrame = session.containerView.frame
        }
        
        let originalFrame = originalContainerFrame ?? session.containerView.frame
        
        UIView.animate(withDuration: keyboard.animationDuration, delay: 0, options: keyboard.animationOptions) {
            session.containerView.frame = originalFrame.offsetBy(dx: 0, dy: -overlap)
        }
    }
    
    
    private func applyResizeLayout(session: BRKeyboardSession, keyboard: BRKeyboardContext) {
        let viewController = session.viewController
        
        guard let contentView = viewController.view else {
            return
        }

        if resizedViewController == nil {
            resizedViewController = viewController
            originalViewControllerBottomInset = viewController.additionalSafeAreaInsets.bottom
            baselineSafeAreaBottomInset = contentView.safeAreaInsets.bottom
        }

        let keyboardPadding = (session.responder as? BRResponderProtocol)?.keyboardPadding ?? self.keyboardPadding
        let keyboardOverlap = contentView.convert(contentView.bounds, to: nil).maxY - keyboard.frame.minY
        let additional = max(0, keyboardOverlap - baselineSafeAreaBottomInset)

        UIView.animate(withDuration: keyboard.animationDuration, delay: 0, options: keyboard.animationOptions) {
            viewController.additionalSafeAreaInsets.bottom = self.originalViewControllerBottomInset + additional
            contentView.layoutIfNeeded()
        } completion: { _ in
            guard let scrollView = session.responder.br.findSuperview(of: UIScrollView.self) else {
                return
            }
            var responderFrame = session.responder.convert(self.responderRect(for: session.responder), to: scrollView)
            responderFrame.size.height += keyboardPadding
            scrollView.scrollRectToVisible(responderFrame, animated: true)
        }
    }


}
