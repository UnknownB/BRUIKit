//
//  BRSegmentBar.swift
//  BRUIKit
//
//  Created by BR on 2025/9/9.
//

import UIKit


/// BRSegmentBar 提供在一組 Button Bar 之中單選按鈕功能
open class BRSegmentBar<Button: UIButton>: BRView {

    
    private let selectionGroup = BRSingleSelectGroup<Button>()


    /// 按鈕清單
    public var buttons: [Button] {
        selectionGroup.buttons
    }
    
    
    /// 目前被選中的按鈕
    public var selectedButton: Button? {
        selectionGroup.selectedButton
    }
    
    
    /// 上一個被選中的按鈕
    public var lastSelectedButton: Button? {
        selectionGroup.lastSelectedButton
    }
    
    
    /// 目前被選中的按鈕索引值
    public var selectedIndex: Int? {
        selectionGroup.selectedIndex
    }
    
    
    /// 上一個被選中的按鈕索引值
    public var lastSelectedIndex: Int? {
        selectionGroup.lastSelectedIndex
    }
    
    
    /// 已更動被選中的按鈕
    public var didChangeSelection: ((Button?) -> Void)? {
        get {
            selectionGroup.didChangeSelection
        }
        set {
            selectionGroup.didChangeSelection = newValue
        }
    }

    
    // MARK: - UI 元件
    
    
    public let scrollView = UIScrollView()
        .br.showsHorizontalIndicator(false)
    
    
    public let stackView = UIStackView()
        .br.axis(.horizontal)
        .br.spacing(8)
        .br.alignment(.fill)
        .br.distribution(.fill)
        
    
    // MARK: - LifeCycle
    

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }

    
    // MARK: - UI
    
    
    open override func setupLayout() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        layout.activate {
            scrollView.br.left == contentView.br.left
            scrollView.br.right == contentView.br.right
            scrollView.br.top == contentView.br.top
            scrollView.br.bottom == contentView.br.bottom
            
            stackView.br.left == scrollView.contentLayoutGuide.br.left
            stackView.br.right == scrollView.contentLayoutGuide.br.right
            stackView.br.top == scrollView.contentLayoutGuide.br.top
            stackView.br.bottom == scrollView.contentLayoutGuide.br.bottom
            stackView.br.height == scrollView.frameLayoutGuide.br.height
        }
    }
    

    @MainActor
    open func addButton(_ button: Button) {
        stackView.addArrangedSubview(button)
        selectionGroup.addButton(button)
    }
    

    /// 指定選擇的按鈕
    @MainActor
    open func selectButton(_ button: Button) {
        selectionGroup.selectButton(button)
    }
    
    
    /// 以索引值指定選擇按鈕
    @MainActor
    open func selectButton(at index: Int) {
        guard index >= 0, index < buttons.count else {
            return
        }
        let button = buttons[index]
        selectionGroup.selectButton(button)
    }
    

    /// 滾動到指定的按鈕
    @MainActor
    open func scrollToButton(_ button: Button, animated: Bool = true) {
        scrollView.scrollRectToVisible(button.frame.insetBy(dx: -16, dy: 0), animated: animated)
    }
    
    
    /// 滾動到指定的索引值
    @MainActor
    open func scrollToButton(at index: Int, animated: Bool = true) {
        guard index >= 0, index < buttons.count else {
            return
        }
        let button = buttons[index]
        scrollToButton(button, animated: animated)
    }
    
    
}
