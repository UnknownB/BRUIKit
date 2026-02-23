//
//  BRCollectionViewCell.swift
//  BRUIKit
//
//  Created by BR on 2025/8/20.
//

import UIKit


open class BRCollectionCell<Model: BRCollectionCellModel>: UICollectionViewCell, BRCellProtocol {
    
    open var model: Model?
    public let layout = BRLayout()
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open func setupUI() {
        
    }
    
    
    open func setupLayout() {
        
    }
    
    
    open func bind(with model: Model, isFirst: Bool, isLast: Bool) {
        self.model = model
        bindStyle(with: model, isFirst: isFirst, isLast: isLast)
        bindContent(with: model, isFirst: isFirst, isLast: isLast)
    }
    
    
    open func bindStyle(with model: Model, isFirst: Bool, isLast: Bool) {
        self.isSelected = model.isSelected
        self.selectedBackgroundView = model.selectedBackgroundView
        self.backgroundView = model.backgroundView
        self.backgroundColor = model.backgroundColor
    }
    
    
    open func bindContent(with model: Model, isFirst: Bool, isLast: Bool) {
        if #available(iOS 14.0, *) {
            bindContentIOS14(with: model, isFirst: isFirst, isLast: isLast)
        }
    }
    
    
    @available(iOS 14.0, *)
    private func bindContentIOS14(with model: Model, isFirst: Bool, isLast: Bool) {
        var config = UIListContentConfiguration.cell()
        config.image = model.image
        config.text = model.text
        config.secondaryText = model.detail
        
        if let imageRadius = model.imageRadius {
            config.imageProperties.cornerRadius = imageRadius
        }
        
        if let textFont = model.textFont {
            config.textProperties.font = textFont
        }
        
        if let textAlignment = model.textAlignment {
            config.textProperties.alignment = textAlignment.br.listTextAlignment
        }
        
        if let textColor = model.textColor {
            config.textProperties.color = textColor
        }
        
        self.contentConfiguration = config
    }
    
    
}
