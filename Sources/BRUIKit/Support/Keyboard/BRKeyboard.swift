//
//  BRKeyboard.swift
//  BRUIKit
//
//  Created by BR on 2025/12/18.
//

import BRFoundation
import UIKit


@MainActor
public enum BRKeyboard {
    
    
    // MARK: - Start
    
    
    /// 啟用鍵盤控制，預設為 false
    public static var enable: Bool {
        get { BRKeyboardManager.shared.enable }
        set { BRKeyboardManager.shared.enable = newValue }
    }
    
    
    // MARK: - Properties
    
    
    /// 封裝單次焦點響應資訊
    public static var session: BRKeyboardSession? {
        BRKeyboardManager.shared.session
    }

    
    /// 鍵盤是否顯示中
    public static var isKeyboardVisible: Bool {
        BRKeyboardManager.shared.layout.isKeyboardVisible
    }

    
    /// 鍵盤相關資訊
    public static var keyboardContext: BRKeyboardContext? {
        BRKeyboardManager.shared.keyboardContext
    }
    
    
    /// 上一個焦點元件，當不存在時回傳 nil
    public static var prevResponder: UIResponder? {
        BRKeyboardManager.shared.inputUI.prevResponder
    }
    
    
    /// 下一個焦點元件，當不存在時回傳 nil
    public static var nextResponder: UIResponder? {
        BRKeyboardManager.shared.inputUI.nextResponder
    }
    

    /// 操作工具列
    public static var toolbar: BRKeyboardToolbarProtocol {
        BRKeyboardManager.shared.inputUI.toolbar
    }
    
    
    // MARK: - Configuration
    
    
    /// 鍵盤與焦點元件的最小間距
    public static var keyboardPadding: CGFloat {
        get { BRKeyboardManager.shared.layout.keyboardPadding }
        set { BRKeyboardManager.shared.layout.keyboardPadding = newValue }
    }
    
    
    /// 啟用點擊空白處收起鍵盤，預設為 true
    public static var enableTapBlankToDismissKeyboard: Bool {
        get { BRKeyboardManager.shared.tapBlank.enableTapBlankToDismissKeyboard }
        set { BRKeyboardManager.shared.tapBlank.enableTapBlankToDismissKeyboard = newValue }
    }
    
    
    /// 啟動 Toolbar，預設為 true
    public static var enableToolbar: Bool {
        get { BRKeyboardManager.shared.inputUI.enableToolbar }
        set { BRKeyboardManager.shared.inputUI.enableToolbar = newValue }
    }
    
    
    /// 操作工具列
    public static var onToolbarMaskChange: ((UIViewController) -> Void)? {
        get { BRKeyboardManager.shared.inputUI.toolbar.onToolbarMaskChange }
        set { BRKeyboardManager.shared.inputUI.toolbar.onToolbarMaskChange = newValue }
    }
    
    
    /// 啟動 Log 狀態追蹤，預設為 false
    public static var enableDebugLog: Bool {
        get { BRKeyboardManager.shared.enableDebugLog }
        set { BRKeyboardManager.shared.enableDebugLog = newValue }
    }
    
    
    // MARK: - Methods
    
    
    /// 隱藏鍵盤
    public static func dismissKeyboard() {
        BRKeyboardManager.shared.dismissKeyboard()
    }


}
