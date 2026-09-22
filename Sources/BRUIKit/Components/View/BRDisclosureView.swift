//
//  BRDisclosureView.swift
//  BRUIKit
//
//  Created by BR on 2026/3/23.
//

import UIKit


/// 具備狀態管理功能的展開式控制項。
///
/// - `BRDisclosureView` 提供 `iconImageView`、`titleLabel`、`arrowImageView` 三個子視圖，每個子視圖的外觀皆可針對不同 `State` 個別設定。
/// - 預設提供基本的水平排列佈局與箭頭旋轉動畫，兩者皆可透過 closure 替換。
///
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
    
    private let stateManager = BRState()

    
    /// 狀態變更
    open var onStateChange: ((BRDisclosureView, State) -> Void)?
    
    
    /// 展開狀態變更
    open var onExpandedStateChange: ((BRDisclosureView, State) -> Void)?
    
    
    /// 自訂箭頭動畫取代預設的旋轉動畫
    ///
    /// ```swift
    /// disclosure.onArrowAnimation = { imageView, isExpanded in
    ///     // 上下翻轉
    ///     imageView.transform = CGAffineTransform(scaleX: 1, y: isExpanded ? -1 : 1)
    /// }
    /// ```
    open var onArrowAnimation: ((UIImageView, Bool) -> Void)?
    

    /// 當值為 true 時每次點擊視圖會切換展開與收合狀態，當 false 時固定展開，預設為 true
    public var isToggleEnabled = true
    
    
    /// 當值為 false 時，下次展開狀態變更不會觸發 onExpandedStateChange 事件
    public var isExpandedChangeEventEnabled = true
    
    
    // MARK: - UI元件
    
    
    public let contentStack = UIStackView()
    
    
    public let itemStack = UIStackView()
    
    
    public let iconImageView = UIImageView()
        .br.contentMode(.scaleAspectFit)
        .br.setContentHuggingPriority(.required, for: .horizontal)

    
    public let titleLabel = BRLabel()
        .br.lines(0)

    
    public let arrowImageView = UIImageView()
        .br.contentMode(.scaleAspectFit)
        .br.setContentHuggingPriority(.required, for: .horizontal)
    
    
    // MARK: - LifeCycle
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
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
        
        if isToggleEnabled {
            isExpanded.toggle()
        } else {
            isExpanded = true
        }
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
        setTitleFont(UIFont.br.font(.w400, size: 16), for: .normal)
        setArrow(.init(systemName: "chevron.down"), for: .normal)
    }
    
    
    open override func setupLayout() {
        super.setupLayout()
        
        contentView.addSubview(contentStack)
        
        itemStack
            .br.spacing(5)
            .br.addArranged(iconImageView)
            .br.addArranged(titleLabel)
            .br.addArranged(arrowImageView)
        
        contentStack
            .br.axis(.vertical)
            .br.addArranged(itemStack)
        
        layout.activate {
            contentStack.br.top == contentView.br.top
            contentStack.br.left == contentView.br.left
            contentStack.br.right == contentView.br.right
            contentStack.br.bottom == contentView.br.bottom
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
    open func setExpanded(_ flag: Bool, triggerEvent: Bool = true) -> Self {
        self.isExpandedChangeEventEnabled = triggerEvent
        self.isExpanded = flag
        return self
    }
    
    
    /// 設定狀態變更回調。
    @discardableResult
    open func setStateChange(_ closure: ((BRDisclosureView, State) -> Void)?) -> Self {
        self.onStateChange = closure
        return self
    }
    
    
    /// 設定展開狀態變更回調。
    @discardableResult
    open func setExpandedStateChange(_ closure: ((BRDisclosureView, State) -> Void)?) -> Self {
        self.onExpandedStateChange = closure
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
    
    
    /// 設定指定狀態下的標題字型。
    @discardableResult
    open func setTitleFont(_ font: UIFont?, for state: State) -> Self {
        stateManager.titleFonts[state] = font
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
    
    
    // MARK: - State
    
    
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
                
                guard isExpandedChangeEventEnabled else {
                    isExpandedChangeEventEnabled = true
                    return
                }
                onExpandedStateChange?(self, state)
            }
        }
    }
    
    
}
    

// MARK: -


private final class BRState {
    
    var titles: [BRDisclosureView.State: String] = [:]
    var titleFonts: [BRDisclosureView.State: UIFont] = [:]
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
            view.onStateChange?(view, view.state)
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
            if let titleFont = fetch(titleFonts, for: state) {
                view.titleLabel.font = titleFont
            }
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
