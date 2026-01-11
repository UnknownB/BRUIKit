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
        BRKeyboardManager.shared.isKeyboardVisible
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
    
    
    /// 設定工具列 `上一個焦點按鈕` 色彩
    ///
    /// - iOS 26+ 預設值為黑與白，依據背景色自動切換
    /// - iOS 13+ 預設值為系統藍
    public static var toolbarPrevButtonTintColor: UIColor? {
        get { BRKeyboardManager.shared.inputUI.toolbar.prevButton.tintColor }
        set { BRKeyboardManager.shared.inputUI.toolbar.prevButton.tintColor = newValue }
    }
    
    
    /// 設定工具列 `下一個焦點按鈕` 色彩
    ///
    /// - iOS 26+ 預設值為黑與白，依據背景色自動切換
    /// - iOS 13+ 預設值為系統藍
    public static var toolbarNextButtonTintColor: UIColor? {
        get { BRKeyboardManager.shared.inputUI.toolbar.nextButton.tintColor }
        set { BRKeyboardManager.shared.inputUI.toolbar.nextButton.tintColor = newValue }
    }
    
    
    /// 設定工具列 `完成按鈕` 色彩
    ///
    /// - iOS 26+ 預設值為黑與白，依據背景色自動切換
    /// - iOS 13+ 預設值為系統藍
    public static var toolbarDoneButtonTintColor: UIColor? {
        get { BRKeyboardManager.shared.inputUI.toolbar.doneButton.tintColor }
        set { BRKeyboardManager.shared.inputUI.toolbar.doneButton.tintColor = newValue }
    }
    
    
    /// 設定工具列 `上一個焦點按鈕` 文字，預設為 nil
    public static var toolbarPrevButtonTitle: String? {
        get { BRKeyboardManager.shared.inputUI.toolbar.prevButton.title }
        set { BRKeyboardManager.shared.inputUI.toolbar.prevButton.title = newValue }
    }
    
    
    /// 設定工具列 `下一個焦點按鈕` 文字，預設為 nil
    public static var toolbarNextButtonTitle: String? {
        get { BRKeyboardManager.shared.inputUI.toolbar.nextButton.title }
        set { BRKeyboardManager.shared.inputUI.toolbar.nextButton.title = newValue }
    }
    
    
    /// 設定工具列 `完成按鈕` 文字，預設為 nil
    public static var toolbarDoneButtonTitle: String? {
        get { BRKeyboardManager.shared.inputUI.toolbar.doneButton.title }
        set { BRKeyboardManager.shared.inputUI.toolbar.doneButton.title = newValue }
    }
    
    
    /// 設定工具列 `上一個焦點按鈕` 圖片，預設為 "chevron.up"
    public static var toolbarPrevButtonImage: UIImage? {
        get { BRKeyboardManager.shared.inputUI.toolbar.prevButton.image }
        set { BRKeyboardManager.shared.inputUI.toolbar.prevButton.image = newValue }
    }


    /// 設定工具列 `下一個焦點按鈕` 圖片，預設為 "chevron.down"
    public static var toolbarNextButtonImage: UIImage? {
        get { BRKeyboardManager.shared.inputUI.toolbar.nextButton.image }
        set { BRKeyboardManager.shared.inputUI.toolbar.nextButton.image = newValue }
    }
    
    
    /// 設定工具列 `完成按鈕` 圖片，預設為 "checkmark"
    public static var toolbarDoneButtonImage: UIImage? {
        get { BRKeyboardManager.shared.inputUI.toolbar.doneButton.image }
        set { BRKeyboardManager.shared.inputUI.toolbar.doneButton.image = newValue }
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
