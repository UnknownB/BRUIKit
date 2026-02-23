//
//  BRTableDefaultCell.swift
//  BRUIKit
//
//  Created by BR on 2025/8/11.
//

import UIKit


open class BRTableCell<Model: BRTableCellModel>: UITableViewCell, BRCellProtocol {
    
    open var model: Model?
    public let layout = BRLayout()

    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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

        self.selectionStyle = model.selectionStyle
        self.accessoryType = model.accessoryType
        self.accessoryView = model.accessoryView
        self.separatorInset = model.separatorInset
    }
    
    
    open func bindContent(with model: Model, isFirst: Bool, isLast: Bool) {
        if #available(iOS 14.0, *) {
            bindContentIOS14(with: model, isFirst: isFirst, isLast: isLast)
        } else {
            bindContentIOS2(with: model, isFirst: isFirst, isLast: isLast)
        }
    }
    
    
    @available(iOS 14.0, *)
    private func bindContentIOS14(with model: Model, isFirst: Bool, isLast: Bool) {
        var config = self.defaultContentConfiguration()
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
    
    
    private func bindContentIOS2(with model: Model, isFirst: Bool, isLast: Bool) {
        imageView?.image = model.image
        imageView?.contentMode = model.imageContentMode ?? .scaleToFill
        imageView?.layer.cornerRadius = model.imageRadius ?? 0
        
        textLabel?.font = model.textFont
        textLabel?.textAlignment = model.textAlignment ?? .natural
        textLabel?.text = model.text
        textLabel?.textColor = model.textColor
        
        detailTextLabel?.text = model.detail
    }
    

}

