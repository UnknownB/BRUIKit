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
    private let buttonTip = BRButtonTip()
    
    public var onTap: ((BRButton) -> Void)?

    
    // MARK: - LifeCycle
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
        buttonTip.setup(from: self)
    }
    
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
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
    
    
    @objc private func onTapped() {
        onTap?(self)
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
    
    
    // MARK: - Tip
    
    
    /// 長按顯示的說明文字；設定後長按按鈕會於其上方浮出說明，放開即消失。設為 nil 則不啟用
    public var tip: String? {
        get { buttonTip.tip }
        set { buttonTip.tip = newValue }
    }
    
    
    /// 長按提示 Label
    public var tipLabel: BRLabel {
        buttonTip.tipLabel
    }
    
    
    // MARK: - KeyboardToolbar
    
    
    /// 仿照系統鍵盤工具列按鈕外觀
    public static func toolbarItemStyle(tintColor: UIColor? = nil, titleColor: UIColor? = nil, tip: String? = nil, action: (() -> Void)? = nil) -> BRButton {
        
        let defaultColor: UIColor
        
        if #available(iOS 26.0, *) {
            defaultColor = .label
        } else {
            defaultColor = .systemBlue
        }
        
        let tintColor = tintColor ?? defaultColor
        let titleColor = titleColor ?? defaultColor
        
        let button = BRButton()
            .br.contentInsets(.init(top: 0, left: 8, bottom: 0, right: 8))
            .br.tintColor(tintColor)
            .br.titleColor(titleColor)
            .br.font(.w500, 18)
            .br.contentHorizontalAlignment(.fill)
            .br.contentVerticalAlignment(.fill)
            .br.imageContentMode(.scaleAspectFit)
            .br.imageSize(CGSize(width: 24, height: 24))
            .br.tip(tip)
            .br.onTap { _ in action?() }
        
        return button
    }
    
    
}
