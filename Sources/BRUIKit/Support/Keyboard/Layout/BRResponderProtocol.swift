//
//  BRResponderProtocol.swift
//  BRUIKit
//
//  Created by BR on 2026/1/8.
//


/// 為焦點元件添加自訂的鍵盤間距
@MainActor
public protocol BRResponderProtocol {
    var keyboardPadding: CGFloat? { get set }
}
