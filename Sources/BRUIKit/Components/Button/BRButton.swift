//
//  BRButton.swift
//  BRUIKit
//
//  Created by BR on 2025/9/9.
//

import BRFoundation
import UIKit


/// 繼承 UIButton 以擴充功能
///
/// - 自訂義按鈕狀態
///     - 添加 checkBox 常用狀態 (off、partial、on)
///     - 與系統 API 設定狀態方法一致
///     - 需透過 buttonState 手動指定狀態
///
open class BRButton: UIButton, BRButtonStateProtocol {
    
    private var lastWidth: CGFloat = 0
    private let stateHelper = BRButtonStateHelper()
    private let layoutHelper = BRButtonLayoutHelper()
    
    // MARK: - LifeCycle
    
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.width != lastWidth {
            lastWidth = bounds.width
            invalidateIntrinsicContentSize()
        }
        layoutHelper.applyLayout(for: self)
    }
    
    
    open override var intrinsicContentSize: CGSize {
        let newSize = layoutHelper.intrinsicContentSize(for: self, using: super.intrinsicContentSize)
        return newSize
    }
    
    
    // MARK: - State
    
    
    open var buttonState: BRButtonState = .off {
        didSet {
            stateHelper.applyState(to: self)
        }
    }
    

    open func setTitle(_ title: String?, for state: BRButtonState) {
        stateHelper.titles[state] = title
        if buttonState == state {
            super.setTitle(title, for: .normal)
        }
    }
    
    
    open func setTitleColor(_ color: UIColor?, for state: BRButtonState) {
        stateHelper.titleColors[state] = color
        if buttonState == state {
            super.setTitleColor(color, for: .normal)
        }
    }
    
    
    open func setImage(_ image: UIImage?, for state: BRButtonState) {
        stateHelper.images[state] = image
        if buttonState == state {
            super.setImage(image, for: .normal)
        }
    }
    
    
    open func setBackgroundImage(_ image: UIImage?, for state: BRButtonState) {
        stateHelper.backgrounds[state] = image
        if buttonState == state {
            super.setBackgroundImage(image, for: .normal)
        }
    }
    
    
    // MARK: - Layout
    
    
    /// 設定圖片與文字的排版方式
    open var layoutMode: BRButtonLayout = .fitContent {
        didSet { setNeedsLayout() }
    }
    
    
    /// 設定圖片在按鈕中的位置
    open var imagePosition: BRPosition = .left {
        didSet { setNeedsLayout() }
    }
    
    
    /// 設定圖片尺寸
    open var imageSize: CGSize? = nil {
        didSet { setNeedsLayout() }
    }
    
    
    /// 設定圖片與文字的間距
    open var imagePadding: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }
    
    
    /// 設定圖片額外的內縮值
    open var imageInsets: UIEdgeInsets = .zero {
        didSet { setNeedsLayout() }
    }
    
    
    /// 設定水平對齊模式
    open override var contentHorizontalAlignment: UIControl.ContentHorizontalAlignment {
        didSet { setNeedsLayout() }
    }
    
    
    /// 設定垂直對齊模式
    open override var contentVerticalAlignment: UIControl.ContentVerticalAlignment {
        didSet { setNeedsLayout() }
    }
    
    
}
