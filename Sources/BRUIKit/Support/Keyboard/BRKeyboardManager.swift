//
//  BRKeyboardManager.swift
//  BRUIKit
//
//  Created by BR on 2025/12/24.
//

import BRFoundation
import UIKit


@MainActor
final class BRKeyboardManager {
    
    public static let shared = BRKeyboardManager()

    
    /// 輸入介面處理
    public let inputUI = BRKeyboardInputUI()

    
    /// 鍵盤位移排版
    public let layout = BRKeyboardLayout()
    
    
    /// 點擊空白處關閉鍵盤手勢
    public let tapBlank = BRKeyboardTapBlank()
    
    
    /// 焦點響應資訊
    public private(set) var session: BRKeyboardSession?
    
    
    /// 鍵盤資訊
    public private(set) var keyboardContext: BRKeyboardContext?
    
    
    /// 啟動 Log 狀態追蹤，預設為 false
    public var enableDebugLog: Bool = false
    
    
    private init() {}

    
    // MARK: - 啟動/關閉 鍵盤監聽
    
    
    /// 啟用鍵盤控制，預設為 false
    public var enable: Bool = false {
        didSet {
            enable ? start() : stop()
        }
    }
    
    
    private func start() {
        NotificationCenter.default.addObserver(self, selector: #selector(onTextDidBegin), name: UITextField.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onTextDidBegin), name: UITextView.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onTextDidEndEditing), name: UITextField.textDidEndEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onTextDidEndEditing), name: UITextView.textDidEndEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        inputUI.addObserver()
    }


    private func stop() {
        NotificationCenter.default.removeObserver(self)
        inputUI.removeObserver()
        tapBlank.removeGesture()
    }
    
    
    // MARK: - 事件監聽處理
    
    
    /// 監聽輸入框編輯開始事件
    ///
    /// ## 觸發時機
    /// - O 輸入框獲得焦點
    /// - O 鍵盤顯示中切換焦點
    /// - X 鍵盤顯示中切換輸入法
    /// - X 鍵盤顯示中翻轉螢幕
    /// - X 輸入框失去焦點
    /// - X 所有輸入框都失去焦點，觸發鍵盤收起
    @objc private func onTextDidBegin(_ sender: Notification) {
        if enableDebugLog {
            #BRLog(.library, .debug, #function)
        }
        
        guard let view = sender.object as? UIView else {
            return
        }
        inputUI.updateResponder(to: view)
    }
    
    
    /// 監聽輸入框編輯結束事件
    ///
    /// ## 觸發時機
    /// - X 輸入框獲得焦點
    /// - X 鍵盤顯示中切換焦點
    /// - X 鍵盤顯示中切換輸入法
    /// - X 鍵盤顯示中翻轉螢幕
    /// - O 輸入框失去焦點
    /// - O 所有輸入框都失去焦點，觸發鍵盤收起
    @objc private func onTextDidEndEditing(_ sender: Notification) {
        if enableDebugLog {
            #BRLog(.library, .debug, #function)
        }
        inputUI.removeResponder()
    }

    
    
    /// 監聽鍵盤即將顯示事件
    ///
    /// 在不同的 iOS 系統下、使用非官方的 Keyboard ，有可能在單次顯示中重複觸發
    ///
    /// ## 觸發時機
    /// - O 輸入框獲得焦點
    /// - O 鍵盤顯示中切換焦點
    /// - O 鍵盤顯示中切換輸入法
    /// - O 鍵盤顯示中翻轉螢幕
    /// - X 輸入框失去焦點
    /// - X 所有輸入框都失去焦點，觸發鍵盤收起
    @objc private func onKeyboardWillShow(_ sender: Notification) {
        if enableDebugLog {
            #BRLog(.library, .debug, #function)
        }
        
        guard let responder = UIResponder.currentFirstResponder as? UIView else {
            #BRLog(.library, .error, "[BRKeyboard] 鍵盤即將升起，但是不存在焦點元件")
            return
        }
        guard let containerView = responder.window?.rootViewController?.view else {
            #BRLog(.library, .error, "[BRKeyboard] 鍵盤即將升起，但是不存在焦點元件的容器")
            return
        }
        guard let viewController = responder.br.viewController() else {
            #BRLog(.library, .error, "[BRKeyboard] 焦點元件未添加至任何 ViewController")
            return
        }

        let session = BRKeyboardSession(responder: responder, viewController: viewController, containerView: containerView)
        let keyboard = BRKeyboardContext(sender)
        
        self.session = session
        self.keyboardContext = keyboard
        
        if tapBlank.enableTapBlankToDismissKeyboard {
            tapBlank.addGesture(with: session)
        }
        
        let layoutModel = layout.moveUp(session: session, keyboard: keyboard)
        
        if enableDebugLog {
            #BRLog(.library, .debug, "[BRKeyboard] moveUp layoutModel: \(layoutModel.rawValue)")
        }
    }

    
    /// 監聽鍵盤即將隱藏事件
    ///
    /// ## 觸發時機
    /// - X 輸入框獲得焦點
    /// - X 鍵盤顯示中切換焦點
    /// - X 鍵盤顯示中切換輸入法
    /// - O 鍵盤顯示中翻轉螢幕
    /// - X 輸入框失去焦點
    /// - O 所有輸入框都失去焦點，觸發鍵盤收起
    @objc private func onKeyboardWillHide(_ sender: Notification) {
        if enableDebugLog {
            #BRLog(.library, .debug, #function)
        }
        let keyboard = BRKeyboardContext(sender)
        self.keyboardContext = keyboard
        
        layout.moveDown(session: session, keyboard: keyboard) {
            self.session = nil
            self.keyboardContext = nil
        }
    }
    
    
    // MARK: - 關閉鍵盤
    
    
    public func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    
}


// MARK: - 焦點元件


private extension UIResponder {

    private static weak var current: UIResponder?

    static var currentFirstResponder: UIResponder? {
        current = nil
        UIApplication.shared.sendAction(#selector(onTap), to: nil, from: nil, for: nil)
        return current
    }

    @objc private func onTap() {
        UIResponder.current = self
    }
}
