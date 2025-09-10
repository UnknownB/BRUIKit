//
//  BRTableDefaultCell.swift
//  BRUIKit
//
//  Created by BR on 2025/8/11.
//

import UIKit


public final class BRTableCellModel: Hashable {
    public var image: UIImage?
    public var text: String?
    public var detail: String?
    public var selectionStyle: UITableViewCell.SelectionStyle = .none
    public var accessoryType: UITableViewCell.AccessoryType = .none
    public var accessoryView: UIView? = nil
    
    
    public static func == (lhs: BRTableCellModel, rhs: BRTableCellModel) -> Bool {
        lhs.text == rhs.text && lhs.detail == rhs.detail
    }

    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(detail)
    }
    
    
    public init(_ text: String?) {
        self.text = text
    }
    
    
    @discardableResult
    public func image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }
    
    @discardableResult
    public func text(_ text: String?) -> Self {
        self.text = text
        return self
    }
    
    @discardableResult
    public func detail(_ detail: String?) -> Self {
        self.detail = detail
        return self
    }
    
    @discardableResult
    public func selectionStyle(_ style: UITableViewCell.SelectionStyle) -> Self {
        self.selectionStyle = style
        return self
    }
    
    @discardableResult
    public func accessory(_ type: UITableViewCell.AccessoryType, view: UIView?) -> Self {
        self.accessoryType = type
        self.accessoryView = view
        return self
    }
    
}


open class BRTableCell: UITableViewCell, BRCellProtocol {
    public typealias Model = BRTableCellModel
    
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
        if #available(iOS 14.0, *) {
            // cell 高度適當高度、有間距
            var config = self.defaultContentConfiguration()
            config.image = model.image
            config.text = model.text
            config.secondaryText = model.detail
            self.contentConfiguration = config
            self.selectionStyle = model.selectionStyle
            self.accessoryType = model.accessoryType
            self.accessoryView = model.accessoryView
        } else {
            // cell 高度切齊、無間距
            self.imageView?.image = model.image
            self.textLabel?.text = model.text
            self.detailTextLabel?.text = model.detail
            self.selectionStyle = model.selectionStyle
            self.accessoryType = model.accessoryType
            self.accessoryView = model.accessoryView
        }
    }
}

