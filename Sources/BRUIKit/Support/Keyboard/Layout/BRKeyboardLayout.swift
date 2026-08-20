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
        case resize
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
        case .resize:
            applyResizeLayout(session: session, keyboard: keyboard)
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
        let resizedViewController = self.resizedViewController
        let anchorScrollView = self.mainScrollView
        let originalViewControllerBottomInset = self.originalViewControllerBottomInset
        let originalScrollViewBottomInset = self.originalScrollViewBottomInset
        let navigationBarHiddenController = self.navigationBarHiddenController

        self.layoutMode = nil
        self.originalScrollViewBottomInset = nil
        self.mainScrollView = nil
        self.lastResponderMinY = 0
        self.resizedViewController = nil
        self.navigationBarHiddenController = nil
        self.isKeyboardVisible = false

        UIView.animate(withDuration: keyboard.animationDuration, delay: 0, options: keyboard.animationOptions) {
            let originalFrame = session?.responder.window?.frame ?? .zero
            session?.containerView.frame = originalFrame
            session?.containerView.setNeedsLayout()
            session?.containerView.layoutIfNeeded()
            navigationBarHiddenController?.setNavigationBarHidden(false, animated: true)
            if let resizedViewController {
                resizedViewController.additionalSafeAreaInsets.bottom = originalViewControllerBottomInset
                resizedViewController.view.layoutIfNeeded()
            }
            if let anchorScrollView, let originalScrollViewBottomInset {
                anchorScrollView.contentInset.bottom = originalScrollViewBottomInset
                anchorScrollView.scrollIndicatorInsets.bottom = originalScrollViewBottomInset
            }
        } completion: { _ in
            completion?()
        }
    }

    
    // MARK: - Private
    
    
    private func resolveLayoutMode(with session: BRKeyboardSession, and keyboard: BRKeyboardContext) -> LayoutMode {
        let rootView = session.viewController.view!
        
        let fittingHeight = rootView.br.compressedFittingHeight()
        let maxShrink = rootView.bounds.height - fittingHeight
        
        if maxShrink >= keyboard.frame.height {
            return .resize
        }

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
