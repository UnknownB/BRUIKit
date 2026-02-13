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
        self.selectionStyle = model.selectionStyle
        self.accessoryType = model.accessoryType
        self.accessoryView = model.accessoryView
    }
    
    
    open func bindContent(with model: Model, isFirst: Bool, isLast: Bool) {
        if #available(iOS 14.0, *) {
            // cell 高度適當高度、有間距
            var config = self.defaultContentConfiguration()
            config.image = model.image
            config.text = model.text
            config.secondaryText = model.detail
            
            if let textColor = model.textColor {
                config.textProperties.color = textColor
            }
            self.contentConfiguration = config
        } else {
            // cell 高度切齊、無間距
            self.imageView?.image = model.image
            self.textLabel?.text = model.text
            self.textLabel?.textColor = model.textColor
            self.detailTextLabel?.text = model.detail
        }
    }

}

