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
    
    
    @discardableResult
    func moveUp(session: BRKeyboardSession, keyboard: BRKeyboardContext) -> LayoutMode {
        let layoutMode = self.layoutMode ?? resolveLayoutMode(with: session.viewController, and: keyboard)
        
        switch layoutMode {
        case .inset:
            applyInsetLayout(session: session, keyboard: keyboard)
        case .offset:
            applyOffsetLayout(session: session, keyboard: keyboard)
        }
        self.layoutMode = layoutMode
        self.isKeyboardVisible = true
        
        return layoutMode
    }
    
    
    func moveDown(session: BRKeyboardSession?, keyboard: BRKeyboardContext, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: keyboard.animationDuration, delay: 0, options: keyboard.animationOptions) {
            let originalFrame = session?.responder.window?.frame ?? .zero
            session?.containerView.frame = originalFrame
            if self.originalScrollViewBottomInset != nil {
                guard let anchorScrollView = self.mainScrollView else { return }
                anchorScrollView.contentInset.bottom = self.originalScrollViewBottomInset!
                anchorScrollView.scrollIndicatorInsets.bottom = self.originalScrollViewBottomInset!
            }
        } completion: { _ in
            self.layoutMode = nil
            self.originalScrollViewBottomInset = nil
            self.mainScrollView = nil
            self.lastResponderMinY = 0
            self.isKeyboardVisible = false
            completion?()
        }
    }

    
    // MARK: - Private
    
    
    private func resolveLayoutMode(with activeViewController: UIViewController, and keyboard: BRKeyboardContext) -> LayoutMode {
        let rootView = activeViewController.view!
        let scrollViews = rootView.br.findSubviews(of: UIScrollView.self)
            .filter { $0.isScrollEnabled }
            .filter { !($0 is UITextView) }
        let sortedMaxYScrollViews = scrollViews.sorted { $0.frame.maxY > $1.frame.maxY }
        
        for scrollView in sortedMaxYScrollViews {
            mainScrollView = scrollView
            return .inset
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

        let scrollViewRect = scrollView.convert(scrollView.bounds, to: rootView)
        let keyboardPadding = (session.responder as? BRResponderProtocol)?.keyboardPadding ?? self.keyboardPadding
        let keyboardMinY = keyboard.frame.minY
        let overlap = scrollViewRect.maxY - keyboardMinY

        guard overlap > 0 else {
            return
        }
        
        var responderFrame: CGRect? = nil
        if let superScrollView = session.responder.br.findSuperview(of: UIScrollView.self) {
            responderFrame = session.responder.convert(responderRect(for: session.responder), to: superScrollView)
            responderFrame!.size.height += keyboardPadding
        }
        
        let isPrevResponder = responderFrame != nil && lastResponderMinY > (responderFrame?.minY ?? 0)
        let duration = isPrevResponder ? 0.2 : 0.0
        
        UIView.animate(withDuration: duration) {
            scrollView.contentInset.bottom = overlap
            scrollView.scrollIndicatorInsets.bottom = overlap
        } completion: { _ in
            if let responderFrame {
                self.lastResponderMinY = responderFrame.minY
                scrollView.scrollRectToVisible(responderFrame, animated: true)
            }
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

        UIView.animate(withDuration: keyboard.animationDuration, delay: 0, options: keyboard.animationOptions) {
            let originalFrame = session.responder.window?.frame ?? .zero
            session.containerView.frame = originalFrame.offsetBy(dx: 0, dy: -overlap)
        }
    }
    
    
}
