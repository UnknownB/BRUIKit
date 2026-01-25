//
//  BRKeyboardInput.swift
//  BRUIKit
//
//  Created by BR on 2026/1/5.
//

import BRFoundation
import UIKit


@MainActor
final class BRKeyboardInputUI: NSObject, UITextFieldDelegate {
    
    private(set) var sortedResponders: [UIResponder] = []
    private(set) var currentResponderIndex: Int? = nil
    private(set) var currentResponder: UIView? = nil
    private(set) var viewController: UIViewController? = nil
    
    private weak var originalTextFieldDelegate: UITextFieldDelegate?
    private var originalTextFieldReturnKey: UIReturnKeyType = .default
    
    
    /// 工具列
    lazy var toolbar = makeToolbar()
    
    
    /// 啟動工具列
    var enableToolbar: Bool = true {
        didSet {
            guard let currentResponder, let viewController = currentResponder.br.viewController() else {
                return
            }
            if enableToolbar {
                handleToolbar(with: currentResponder, activateViewController: viewController)
            } else {
                restoreToolbar(with: currentResponder)
            }
        }
    }
    

    /// 上一個焦點元件
    var prevResponder: UIResponder? {
        guard let index = currentResponderIndex, index > 0 else { return nil }
        return sortedResponders[index - 1]
    }
    
    
    /// 下一個焦點元件
    var nextResponder: UIResponder? {
        guard let index = currentResponderIndex, index + 1 < sortedResponders.count else { return nil }
        return sortedResponders[index + 1]
    }

    
    // MARK: - 螢幕翻轉
    
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(onLayoutDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc private func onLayoutDidChange() {
        guard let viewController, let currentResponder else {
            return
        }
        sortedResponders = sortedResponders(from: viewController)
        currentResponderIndex = currentResponderIndex(from: currentResponder)
        handleReturn(with: currentResponder)
        handleToolbar(with: currentResponder, activateViewController: viewController)
    }

    
    // MARK: - 焦點元件
    
    
    func updateResponder(to view: UIView) {
        guard let activateViewController = view.br.viewController() else {
            return
        }
        viewController = activateViewController
        sortedResponders = sortedResponders(from: activateViewController)
        currentResponder = view
        currentResponderIndex = currentResponderIndex(from: view)
        
        handleReturn(with: view)
        handleToolbar(with: view, activateViewController: activateViewController)
    }
    
    
    func removeResponder() {
        if let currentResponder {
            restoreReturn(with: currentResponder)
            restoreToolbar(with: currentResponder)
        }
        currentResponderIndex = nil
        currentResponder = nil
    }
    
    
    private func sortedResponders(from viewController: UIViewController) -> [UIResponder] {
        var responders: [UIResponder] = []
        let views = viewController.view.br.findSubviews(of: UIView.self)
        let textFields = views
            .compactMap { $0 as? UITextField }
            .filter { $0.canBecomeFirstResponder }
        let textViews = views
            .compactMap { $0 as? UITextView }
            .filter { $0.canBecomeFirstResponder }
            .filter { $0.isEditable }
        
        responders.append(contentsOf: textFields)
        responders.append(contentsOf: textViews)
        
        return responders
            .sorted {
                let rectL = ($0 as? UIView)?.frame ?? .zero
                let rectR = ($1 as? UIView)?.frame ?? .zero
                if rectL.minY != rectR.minY {
                    return rectL.minY < rectR.minY
                } else {
                    return rectL.minX < rectR.minX
                }
            }
    }
    
    
    private func currentResponderIndex(from view: UIView) -> Int? {
        sortedResponders.firstIndex { $0 === view }
    }
    
    
    // MARK: - Return
    
    
    private func handleReturn(with responder: UIResponder) {
        if let textField = responder as? UITextField {
            originalTextFieldDelegate = textField.delegate
            originalTextFieldReturnKey = textField.returnKeyType
            
            if textField.delegate == nil {
                textField.delegate = self
            }
            if textField.returnKeyType == .default {
                textField.returnKeyType = nextResponder == nil ? .done : .next
            }
        }
    }
    
    
    private func restoreReturn(with responder: UIResponder) {
        if let textField = responder as? UITextField {
            textField.delegate = originalTextFieldDelegate
            textField.returnKeyType = originalTextFieldReturnKey
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextResponder = nextResponder {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    
    // MARK: - Toolbar
    
    
    private func makeToolbar() -> BRKeyboardToolbarProtocol {
        if #available(iOS 26.0, *) {
            return BRKeyboardToolbarIOS26()
        } else {
            return BRKeyboardToolbarIOS13()
        }
    }
    
    
    private func handleToolbar(with responder: UIResponder, activateViewController: UIViewController) {
        toolbar.bind(prev: prevResponder, next: nextResponder)
        toolbar.updateToolbarMaskView(with: activateViewController)
        if enableToolbar, let textField = responder as? UITextField, textField.inputAccessoryView == nil {
            textField.inputAccessoryView = toolbar.accessoryView
        }
        if enableToolbar, let textView = responder as? UITextView, textView.inputAccessoryView == nil {
            textView.inputAccessoryView = toolbar.accessoryView
        }
    }
    
    
    private func restoreToolbar(with responder: UIResponder) {
        if let textField = responder as? UITextField, textField.inputAccessoryView == toolbar.accessoryView {
            textField.inputAccessoryView = nil
        }
        if let textView = responder as? UITextView, textView.inputAccessoryView == toolbar.accessoryView {
            textView.inputAccessoryView = nil
        }
    }
    
}
