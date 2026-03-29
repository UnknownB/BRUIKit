//
//  BRView.swift
//  BRUIKit
//
//  Created by BR on 2026/3/12.
//

import UIKit


private extension String {
    static let top = "top"
    static let left = "left"
    static let right = "right"
    static let bottom = "bottom"
}


/// BRView 繼承自 UIView 提供常用的簡單封裝
///
/// ## 初始化封裝
///
/// - BRView 初始化時會依序呼叫以下 funcs
///     - `setupUI()`
///         - 風格、樣式設定
///     - `setupLayout()`
///         - 添加子元件、排版設定
///     - `setupEvent()`
///         - 按鈕事件、子元件的 closure
///     - `bindViewModel()`
///         - 資料捆綁
///
/// ## contentInsets 屬性
///
/// - 使用時需透過 `contentView` 進行 layout
///
open class BRView: UIView {
    
    public let layout = BRLayout()
    
    private let contentLayout = BRLayout()
    
    
    public var contentInsets: UIEdgeInsets = .zero {
        didSet {
            contentLayout.setContent(contentInsets.top, for: .top)
            contentLayout.setContent(contentInsets.left, for: .left)
            contentLayout.setContent(-contentInsets.right, for: .right)
            contentLayout.setContent(-contentInsets.bottom, for: .bottom)
        }
    }
    
    
    // MARK: - UI 元件
    
    
    public let contentView = UIView()
        .br.backgroundColor(.clear)

    
    // MARK: - LifeCycle
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
        setupUI()
        setupLayout()
        setupEvent()
        bindViewModel()
    }
    
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - UI
    
    
    private func setupContentView() {
        self.addSubview(contentView)
        
        contentLayout.activate {
            (contentView.br.top == self.br.top).br.saved(.top)
            (contentView.br.left == self.br.left).br.saved(.left)
            (contentView.br.right == self.br.right).br.saved(.right)
            (contentView.br.bottom == self.br.bottom).br.saved(.bottom)
        }
    }
    
    
    open func setupUI() {
    }
    
    
    open func setupLayout() {
    }
    
    
    // MARK: - Data
    
    
    open func bindViewModel() {
        
    }
    
    
    // MARK: - Event
    
    
    open func setupEvent() {
        
    }
    
    
}
