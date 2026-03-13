//
//  BRExpandableView.swift
//  BRUIKit
//
//  Created by BR on 2026/3/12.
//

import UIKit


open class BRExpandableView: BRView {
    
    public enum State {
        case normal
        case selected
        case expanded
    }
    
    
    private let stateHelper = BRExpandableViewStateHelper()
    
    
    open var state: State = .normal {
        didSet {
            stateHelper.applyState(to: self)
        }
    }
    
    
    open var onLayout: ((BRExpandableView) -> Void)? {
        didSet { applyLayout() }
    }
    
    
    open var isSelected: Bool = false {
        didSet {
            stateHelper.applyState(to: self)
        }
    }
    
    
    // MARK: - LifeCycle
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        applyLayout()
    }
    
    
    @MainActor required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI元件
    
    
    public let iconImageView = UIImageView()
        .br.contentMode(.scaleAspectFit)
    
    
    public let titleLabel = UILabel()
        .br.font(.w400, 16)

    
    public let arrowImageView = UIImageView()
        .br.contentMode(.scaleAspectFit)
    
    
    // MARK: - DSL
    
    
    @discardableResult
    open func setTitle(_ title: String?, for state: State) -> Self {
        stateHelper.titles[state] = title
        if self.state == state {
            titleLabel.text = title
        }
        return self
    }
    
    
    @discardableResult
    open func setTitleColor(_ color: UIColor?, for state: State) -> Self {
        stateHelper.titleColors[state] = color
        if self.state == state {
            titleLabel.textColor = color
        }
        return self
    }
    
    
    @discardableResult
    open func setIcon(_ image: UIImage?, for state: State) -> Self {
        stateHelper.iconImages[state] = image
        if self.state == state {
            iconImageView.image = image
        }
        return self
    }
    
    
    @discardableResult
    open func setIconTintColor(_ color: UIColor?, for state: State) -> Self {
        stateHelper.iconTintColors[state] = color
        if self.state == state {
            iconImageView.tintColor = color
        }
        return self
    }
    
    
    @discardableResult
    open func setArrow(_ image: UIImage?, for state: State) -> Self {
        stateHelper.arrowImages[state] = image
        if self.state == state {
            arrowImageView.image = image
        }
        return self
    }
    
    
    @discardableResult
    open func setArrowTintColor(_ color: UIColor?, for state: State) -> Self {
        stateHelper.arrowTintColors[state] = color
        if self.state == state {
            arrowImageView.tintColor = color
        }
        return self
    }
    
    
    // MARK: - UI
    
    
    open override func setupLayout() {
        super.setupLayout()
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImageView)
    }
    
    
    private func applyLayout() {
        layout.deactivateAll()
        
        if let onLayout = onLayout {
            onLayout(self)
        } else {
            layout.activate {
                iconImageView.br.top == contentView.br.top
                iconImageView.br.bottom == contentView.br.bottom
                iconImageView.br.left == contentView.br.left
                iconImageView.br.centerY == contentView.br.centerY
                iconImageView.br.width == 30
                iconImageView.br.height == 30

                titleLabel.br.top == contentView.br.top
                titleLabel.br.bottom == contentView.br.bottom
                titleLabel.br.left == iconImageView.br.right + 5
                titleLabel.br.centerY == contentView.br.centerY

                arrowImageView.br.top == contentView.br.top
                arrowImageView.br.bottom == contentView.br.bottom
                arrowImageView.br.right == contentView.br.right
                arrowImageView.br.left == titleLabel.br.right + 5
                arrowImageView.br.centerY == contentView.br.centerY
                arrowImageView.br.width == 30
            }
        }
    }
    
    
    // MARK: - Event
    
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if state == .expanded {
            self.state = isSelected ? .selected : .normal
        } else {
            self.state = .expanded
        }
        isSelected.toggle()
    }
    
    
}


private final class BRExpandableViewStateHelper {
    
    var iconTintColors: [BRExpandableView.State: UIColor] = [:]
    var iconImages: [BRExpandableView.State: UIImage] = [:]
    
    var arrowTintColors: [BRExpandableView.State: UIColor] = [:]
    var arrowImages: [BRExpandableView.State: UIImage] = [:]
    
    var titleColors: [BRExpandableView.State: UIColor] = [:]
    var titles: [BRExpandableView.State: String] = [:]
    
    
    @MainActor func applyState(to view: BRExpandableView) {
        let state = view.state
        let defaultState: BRExpandableView.State = view.isSelected ? .selected : .normal
        
        if let title = titles[state] ?? titles[defaultState] {
            view.titleLabel.text = title
        }
        
        if let titleColor = titleColors[state] ?? titleColors[defaultState] {
            view.titleLabel.textColor = titleColor
        }
        
        if let iconImage = iconImages[state] ?? iconImages[defaultState] {
            view.iconImageView.image = iconImage
        }
        
        if let iconTintColor = iconTintColors[state] ?? iconTintColors[defaultState] {
            view.iconImageView.tintColor = iconTintColor
        }
        
        if let arrowImage = arrowImages[state] ?? arrowImages[defaultState] {
            view.arrowImageView.image = arrowImage
        }
        
        if let arrowTintColor = arrowTintColors[state] ?? arrowTintColors[defaultState] {
            view.arrowImageView.tintColor = arrowTintColor
        }
    }
}
