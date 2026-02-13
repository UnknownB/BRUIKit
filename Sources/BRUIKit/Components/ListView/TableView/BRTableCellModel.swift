//
//  BRTableCellModel.swift
//  BRUIKit
//
//  Created by BR on 2026/2/12.
//

import UIKit


open class BRTableCellModel: Hashable {
    open var id: String
    open var image: UIImage?
    open var text: String?
    open var textColor: UIColor?
    open var detail: String?
    open var selectionStyle: UITableViewCell.SelectionStyle = .none
    open var accessoryType: UITableViewCell.AccessoryType = .none
    open var accessoryView: UIView? = nil
    
    
    public static func == (lhs: BRTableCellModel, rhs: BRTableCellModel) -> Bool {
        lhs.id == rhs.id
    }

    
    open func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
    public init(_ text: String? = nil, id: String? = nil) {
        self.id = id ?? text ?? UUID().uuidString
        self.text = text
        setup()
    }

    
    open func setup() {
    }
    
    
    @discardableResult
    open func id(_ value: String) -> Self {
        self.id = value
        return self
    }
    
    
    @discardableResult
    open func image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }
    
    
    @discardableResult
    open func text(_ text: String?) -> Self {
        self.text = text
        return self
    }
    
    
    @discardableResult
    open func textColor(_ color: UIColor?) -> Self {
        self.textColor = color
        return self
    }
    
    
    @discardableResult
    open func detail(_ detail: String?) -> Self {
        self.detail = detail
        return self
    }
    
    
    @discardableResult
    open func selectionStyle(_ style: UITableViewCell.SelectionStyle) -> Self {
        self.selectionStyle = style
        return self
    }
    
    
    @discardableResult
    open func accessory(_ type: UITableViewCell.AccessoryType, view: UIView?) -> Self {
        self.accessoryType = type
        self.accessoryView = view
        return self
    }
    
    
}
