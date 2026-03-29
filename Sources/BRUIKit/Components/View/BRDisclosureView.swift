//
//  BRDisclosureView.swift
//  BRUIKit
//
//  Created by BR on 2026/3/23.
//

import UIKit


/// 具備狀態管理功能的展開式控制項。
///
/// ## 特性
///
/// - `BRDisclosureView` 提供 `iconImageView`、`titleLabel`、`arrowImageView` 三個子視圖，
/// 每個子視圖的外觀皆可針對不同 `State` 個別設定。
/// - 預設提供基本的水平排列佈局與箭頭旋轉動畫，兩者皆可透過 closure 替換。
///
/// ## 使用範例
/// ```swift
/// let disclosure = BRDisclosureView()
///     .setTitle("展開", for: .normal)
///     .setTitle("收合", for: .expanded)
///     .setTitleColor(.label, for: .normal)
///     .setTitleColor(.systemBlue, for: .expanded)
///     .setStateChange { view, state in
///         contentView.isHidden = !view.isExpanded
///     }
/// ```
open class BRDisclosureView: BRView {
            
    public struct State: OptionSet, Hashable, Sendable {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static let normal = State([])
        public static let selected = State(rawValue: 1 << 0)
        public static let highlighted = State(rawValue: 1 << 1)
        public static let disabled = State(rawValue: 1 << 2)
        public static let expanded = State(rawValue: 1 << 3)
    }
    
    
    private let stateManager = BRState()
    private let layoutManager = BRLayout()
    
    
    /// 獲取目前的組合狀態（例如：[.selected, .expanded]）
    public var state: State {
        var state: State = .normal
        if isSelected { state.insert(.selected) }
        if isHighlighted { state.insert(.highlighted) }
        if !isEnable { state.insert(.disabled) }
        if isExpanded { state.insert(.expanded) }
        return state
    }
    
    
    /// 是否處於選取狀態。預設為 `false`。
    open var isSelected: Bool = false {
        didSet {
            if oldValue != isSelected {
                stateManager.setNeedsUpdateState(to: self, animated: true)
            }
        }
    }
    
    
    /// 是否處於按壓高亮狀態。由 touch 事件自動管理，外部唯讀。
    open private(set) var isHighlighted: Bool = false {
        didSet {
            if oldValue != isHighlighted {
                stateManager.setNeedsUpdateState(to: self, animated: true)
            }
        }
    }
    
    
    /// 是否啟用互動。設為 `false` 時不回應觸控，外觀切換至 `.disabled` 狀態。預設為 `true`。
    open var isEnable: Bool = true {
        didSet {
            if oldValue != isEnable {
                stateManager.setNeedsUpdateState(to: self, animated: true)
            }
        }
    }
    
    
    /// 是否處於展開狀態。變更時會觸發外觀更新與 `onStateChange` 回調。預設為 `false`。
    open var isExpanded: Bool = false {
        didSet {
            if oldValue != isExpanded {
                stateManager.setNeedsUpdateState(to: self, animated: true)
                onStateChange?(self, state)
            }
        }
    }
    
    
    /// 展開狀態變更時的回調，無論是使用者點擊或外部程式設值皆會觸發。
    ///
    /// - Note: 此 closure 觸發時 UI 外觀更新尚未完成（外觀更新為非同步），
    ///   請勿在此讀取子視圖的外觀屬性（如 `titleLabel.text`）。
    open var onStateChange: ((BRDisclosureView, State) -> Void)?
    
    
    /// 自訂佈局 closure，設定後取代預設的水平排列佈局。
    ///
    /// ## 範例
    ///
    /// ```swift
    /// disclosure.onLayout = { view, layout in
    ///     layout.activate {
    ///         view.iconImageView.br.height == 40
    ///         // ...
    ///     }
    /// }
    /// ```
    open var onLayout: ((BRDisclosureView, BRLayout) -> Void)? {
        didSet { applyLayout() }
    }
    
    
    /// 自訂箭頭動畫 closure，設定後取代預設的旋轉動畫。
    ///
    /// ## 範例
    ///
    /// ```swift
    /// disclosure.onArrowAnimation = { imageView, isExpanded in
    ///     // 上下翻轉
    ///     imageView.transform = CGAffineTransform(scaleX: 1, y: isExpanded ? -1 : 1)
    /// }
    /// ```
    open var onArrowAnimation: ((UIImageView, Bool) -> Void)?
    
    
    // MARK: - UI元件
    
    
    /// 左側圖示視圖。
    public let iconImageView = UIImageView()
        .br.contentMode(.scaleAspectFit)
        .br.userInteractionEnabled(false)

    
    /// 中間標題文字。
    public let titleLabel = UILabel()
        .br.font(.w400, 16)
        .br.userInteractionEnabled(false)

    
    /// 右側箭頭圖示，預設為 `chevron.down`，展開時旋轉 180°。
    public let arrowImageView = UIImageView()
        .br.contentMode(.scaleAspectFit)
        .br.userInteractionEnabled(false)
    
    
    // MARK: - LifeCycle
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        applyLayout()
        stateManager.setNeedsUpdateState(to: self, animated: false)
    }
    
    
    @MainActor required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard isEnable else {
            return
        }
        isHighlighted = true
    }
    
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard isEnable, isHighlighted else {
            return
        }
        isHighlighted = false
        isExpanded.toggle()
    }
    
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard isEnable, let touch = touches.first else {
            return
        }
        isHighlighted = bounds.contains(touch.location(in: self))
    }
    
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isHighlighted = false
    }
    
    
    // MARK: - UI
    
    
    open override func setupUI() {
        super.setupUI()
        setArrow(.init(systemName: "chevron.down"), for: .normal)
    }
    
    
    open override func setupLayout() {
        super.setupLayout()
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImageView)
    }
    
    
    private func applyLayout() {
        layoutManager.deactivateAll()
        
        if let onLayout = onLayout {
            onLayout(self, layoutManager)
        } else {
            layoutManager.activate {
                iconImageView.br.top == contentView.br.top
                iconImageView.br.bottom == contentView.br.bottom
                iconImageView.br.left == contentView.br.left
                iconImageView.br.width == 30
                iconImageView.br.height == 30

                titleLabel.br.top == contentView.br.top
                titleLabel.br.bottom == contentView.br.bottom
                titleLabel.br.left == iconImageView.br.right + 5

                arrowImageView.br.top == contentView.br.top
                arrowImageView.br.bottom == contentView.br.bottom
                arrowImageView.br.right == contentView.br.right
                arrowImageView.br.left == titleLabel.br.right + 5
                arrowImageView.br.width == 30
            }
        }
    }
    
    
    // MARK: - DSL
    
    
    /// 設定選取狀態。
    @discardableResult
    open func setSelected(_ flag: Bool) -> Self {
        self.isSelected = flag
        return self
    }
    
    
    /// 設定啟用狀態。
    @discardableResult
    open func setEnable(_ flag: Bool) -> Self {
        self.isEnable = flag
        return self
    }

    
    /// 設定展開狀態。
    @discardableResult
    open func setExpanded(_ flag: Bool) -> Self {
        self.isExpanded = flag
        return self
    }
    
    
    /// 設定狀態變更回調。
    @discardableResult
    open func setStateChange(_ closure: ((BRDisclosureView, State) -> Void)?) -> Self {
        self.onStateChange = closure
        return self
    }
    
    
    /// 設定自訂佈局 closure，取代預設佈局。
    @discardableResult
    open func setLayout(_ closure: ((BRDisclosureView, BRLayout) -> Void)?) -> Self {
        self.onLayout = closure
        return self
    }
    
    
    /// 設定自訂箭頭動畫 closure，取代預設旋轉動畫。
    @discardableResult
    open func setArrowAnimation(_ closure: ((UIImageView, Bool) -> Void)?) -> Self {
        self.onArrowAnimation = closure
        return self
    }
    
    
    /// 設定指定狀態下的標題文字。
    @discardableResult
    open func setTitle(_ title: String?, for state: State) -> Self {
        stateManager.titles[state] = title
        stateManager.setNeedsUpdateState(to: self, animated: false)
        return self
    }
    
    
    /// 設定指定狀態下的標題顏色。
    @discardableResult
    open func setTitleColor(_ color: UIColor?, for state: State) -> Self {
        stateManager.titleColors[state] = color
        stateManager.setNeedsUpdateState(to: self, animated: false)
        return self
    }
    
    
    /// 設定指定狀態下的圖示影像。
    @discardableResult
    open func setIcon(_ image: UIImage?, for state: State) -> Self {
        stateManager.iconImages[state] = image
        stateManager.setNeedsUpdateState(to: self, animated: false)
        return self
    }
    
    
    /// 設定指定狀態下的圖示 tint 顏色。
    @discardableResult
    open func setIconTintColor(_ color: UIColor?, for state: State) -> Self {
        stateManager.iconTintColors[state] = color
        stateManager.setNeedsUpdateState(to: self, animated: false)
        return self
    }
    
    
    /// 設定指定狀態下的箭頭影像。
    @discardableResult
    open func setArrow(_ image: UIImage?, for state: State) -> Self {
        stateManager.arrowImages[state] = image
        stateManager.setNeedsUpdateState(to: self, animated: false)
        return self
    }
    
    
    /// 設定指定狀態下的箭頭 tint 顏色。
    @discardableResult
    open func setArrowTintColor(_ color: UIColor?, for state: State) -> Self {
        stateManager.arrowTintColors[state] = color
        stateManager.setNeedsUpdateState(to: self, animated: false)
        return self
    }
    
    
}
    

// MARK: -


private final class BRState {
    
    var titles: [BRDisclosureView.State: String] = [:]
    var titleColors: [BRDisclosureView.State: UIColor] = [:]
    var iconImages: [BRDisclosureView.State: UIImage] = [:]
    var iconTintColors: [BRDisclosureView.State: UIColor] = [:]
    var arrowImages: [BRDisclosureView.State: UIImage] = [:]
    var arrowTintColors: [BRDisclosureView.State: UIColor] = [:]
    private var isUpdateQueued = false
    private var pendingAnimated = false
    
    
    @MainActor func setNeedsUpdateState(to view: BRDisclosureView, animated: Bool = true) {
        pendingAnimated = pendingAnimated || animated
        guard !isUpdateQueued else { return }
        isUpdateQueued = true
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.applyState(to: view, animated: self.pendingAnimated)
            self.isUpdateQueued = false
            self.pendingAnimated = false
        }
    }
    
    
    func fetch<T>(_ map: [BRDisclosureView.State: T], for currentState: BRDisclosureView.State) -> T? {
        if let style = map[currentState] {
            return style
        }
        
        if currentState.contains(.disabled) {
            return map[.disabled] ?? map[.normal]
        }
        
        if currentState.contains(.highlighted), let style = map[.highlighted] {
            return style
        }
        
        if currentState.contains(.selected), let style = map[.selected] {
            return style
        }
        
        if currentState.contains(.expanded), let style = map[.expanded] {
            return style
        }
        
        return map[.normal]
    }
    
    
    @MainActor func applyState(to view: BRDisclosureView, animated: Bool = true) {
        let state = view.state
        
        let updates = { [self] in
            if let title = fetch(titles, for: state) {
                view.titleLabel.text = title
            }
            if let titleColor = fetch(titleColors, for: state) {
                view.titleLabel.textColor = titleColor
            }
            if let iconImage = fetch(iconImages, for: state) {
                view.iconImageView.image = iconImage
            }
            if let iconTintColor = fetch(iconTintColors, for: state) {
                view.iconImageView.tintColor = iconTintColor
            }
            if let arrowImage = fetch(arrowImages, for: state) {
                view.arrowImageView.image = arrowImage
            }
            if let arrowTintColor = fetch(arrowTintColors, for: state) {
                view.arrowImageView.tintColor = arrowTintColor
            }
            
            if let onArrowAnimation = view.onArrowAnimation {
                onArrowAnimation(view.arrowImageView, view.isExpanded)
            } else {
                let angle: CGFloat = view.isExpanded ? .pi : 0
                view.arrowImageView.transform = CGAffineTransform(rotationAngle: angle)
            }
        }

        if animated {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: updates)
        } else {
            updates()
        }
    }
    
    
}
