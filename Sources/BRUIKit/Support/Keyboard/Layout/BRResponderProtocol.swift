//
//  BRResponderProtocol.swift
//  BRUIKit
//
//  Created by BR on 2026/1/8.
//

import UIKit


/// 為焦點元件自訂的鍵盤相關設定
@MainActor
public protocol BRResponderProtocol {

    /// 焦點元件與鍵盤的間距
    var keyboardPadding: CGFloat? { get set }

    /// 自訂的鍵盤工具列設定
    var keyboardToolbarConfig: BRKeyboardToolbarConfig { get set }
}
