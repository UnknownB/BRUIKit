//
//  BRDisclosureStack.swift
//  BRUIKit
//
//  Created by BR on 2026/3/26.
//

import UIKit


/// 具備狀態管理功能的展開式控制容器
///
/// - `BRDisclosureStack`
///     - 繼承自 `UIStackView`
///     - 初始化時注入 `disclosureView` 來決定外觀
///
/// - `disclosureView`
///     - 初始化時由外部注入的 `BRDisclosureView` 控制項
///     - 負責提供展開式的操作介面、狀態管理
///
/// - `detailStack`
///     - `UIStackView` 物件
///     - 負責提供展開後的內容
open class BRDisclosureStack: UIStackView {
    
    
    /// 展開與收合的動畫時長，預設 0.2
    open var animationDuration: TimeInterval = 0.2
    
    
    // MARK: - UI 元件
    

    /// 展開控制項，由外部建立後注入
    public let disclosureView: BRDisclosureView
    
    
    /// 展開後顯示的內容容器
    ///
    /// ## 特性
    ///
    /// - 直接對其呼叫 `addArrangedSubview` 加入內容
    /// - 初始狀態為隱藏，展開時以動畫淡入顯示。
    ///
    public let detailStack = UIStackView()
        .br.hidden(true)
    

    // MARK: - LifeCycle

    
    public init(disclosureView: BRDisclosureView, axis: NSLayoutConstraint.Axis) {
        self.disclosureView = disclosureView
        super.init(frame: .zero)
        setupLayout(axis: axis)
        setupEvent()
    }
    
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
    // MARK: - UI
    
    
    private func setupLayout(axis: NSLayoutConstraint.Axis) {
        self.axis = axis
        self.spacing = 5
        detailStack.axis = axis

        addArrangedSubview(disclosureView)
        addArrangedSubview(detailStack)
    }
    
    
    // MARK: - Event
    
    
    private func setupEvent() {
        self.disclosureView.setStateChange(onStateChange)
    }
    
    
    private func onStateChange(view: BRDisclosureView, state: BRDisclosureView.State) {
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
            self.detailStack.isHidden = !view.isExpanded
            self.detailStack.alpha = view.isExpanded ? 1 : 0
            self.layoutIfNeeded()
        }
    }

    
}
