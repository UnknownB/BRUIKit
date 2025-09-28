//
//  BRButton.swift
//  BRUIKit
//
//  Created by BR on 2025/9/9.
//

import UIKit


/// 繼承 UIButton 以擴充功能
///
/// - 自訂義按鈕狀態
///     - 添加 checkBox 常用狀態 (off、partial、on)
///     - 與系統 API 設定狀態方法一致
///     - 需透過 buttonState 手動指定狀態
///
open class BRButton: UIButton, BRButtonStateProtocol {
    
    private let stateHelper = BRButtonStateHelper()

    
    // MARK: - State
    
    
    public var buttonState: BRButtonState = .off {
        didSet {
            stateHelper.applyState(to: self)
        }
    }
    

    public func setTitle(_ title: String?, for state: BRButtonState) {
        stateHelper.titles[state] = title
        if buttonState == state {
            super.setTitle(title, for: .normal)
        }
    }
    
    
    public func setTitleColor(_ color: UIColor?, for state: BRButtonState) {
        stateHelper.titleColors[state] = color
        if buttonState == state {
            super.setTitleColor(color, for: .normal)
        }
    }
    
    
    public func setImage(_ image: UIImage?, for state: BRButtonState) {
        stateHelper.images[state] = image
        if buttonState == state {
            super.setImage(image, for: .normal)
        }
    }
    
    
    public func setBackgroundImage(_ image: UIImage?, for state: BRButtonState) {
        stateHelper.backgrounds[state] = image
        if buttonState == state {
            super.setBackgroundImage(image, for: .normal)
        }
    }
    
    
}
