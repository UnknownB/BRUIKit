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
    
    
    public var buttonState: BRButtonState = .off {
        didSet {
            applyButtonState()
        }
    }
    
    
    private var stateTitles: [BRButtonState: String] = [:]
    private var stateTitleColors: [BRButtonState: UIColor] = [:]
    private var stateImages: [BRButtonState: UIImage] = [:]
    private var stateBackgrounds: [BRButtonState: UIImage] = [:]


    public func setTitle(_ title: String?, for state: BRButtonState) {
        stateTitles[state] = title
        if buttonState == state {
            applyButtonState()
        }
    }
    
    
    public func setTitleColor(_ color: UIColor?, for state: BRButtonState) {
        stateTitleColors[state] = color
        if buttonState == state {
            applyButtonState()
        }
    }
    
    
    public func setImage(_ image: UIImage?, for state: BRButtonState) {
        stateImages[state] = image
        if buttonState == state {
            applyButtonState()
        }
    }
    
    
    public func setBackgroundImage(_ image: UIImage?, for state: BRButtonState) {
        stateBackgrounds[state] = image
        if buttonState == state {
            applyButtonState()
        }
    }
    
    
    public func applyButtonState() {
        if let title = stateTitles[buttonState] ?? title(for: .normal) {
            super.setTitle(title, for: .normal)
        }
        
        if let titleColor = stateTitleColors[buttonState] ?? titleColor(for: .normal) {
            super.setTitleColor(titleColor, for: .normal)
        }
        
        if let image = stateImages[buttonState] ?? image(for: .normal) {
            super.setImage(image, for: .normal)
        }
        
        if let backgroundImage = stateBackgrounds[buttonState] ?? backgroundImage(for: .normal) {
            super.setBackgroundImage(backgroundImage, for: .normal)
        }
    }
    
    
}
