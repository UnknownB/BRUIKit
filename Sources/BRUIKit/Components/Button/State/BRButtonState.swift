//
//  BRButtonState.swift
//  BRUIKit
//
//  Created by BR on 2025/9/9.
//

import UIKit


/// 自訂義按鈕狀態
public enum BRButtonState {
    
    /// 未選取
    case off
    
    /// 部分選取
    case partial
    
    /// 全部選取
    case on
}


@MainActor
public protocol BRButtonStateProtocol: AnyObject {
    var buttonState: BRButtonState { get set }
    
    func setTitle(_ title: String?, for state: BRButtonState)
    func setTitleColor(_ color: UIColor?, for state: BRButtonState)
    func setImage(_ image: UIImage?, for state: BRButtonState)
    func setBackgroundImage(_ image: UIImage?, for state: BRButtonState)
}
