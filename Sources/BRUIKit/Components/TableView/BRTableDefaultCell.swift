//
//  BRTableDefaultCell.swift
//  BRUIKit
//
//  Created by BR on 2025/8/11.
//

import UIKit


public struct BRTableDefaultCellModel {
    let text: String?
    let detail: String?
    let selectionStyle: UITableViewCell.SelectionStyle
    let accessoryType: UITableViewCell.AccessoryType
    let accessoryView: UIView?
    
    init(text: String?, detail: String?, selectionStyle: UITableViewCell.SelectionStyle = .none, accessoryType: UITableViewCell.AccessoryType = .none, accessoryView: UIView?) {
        self.text = text
        self.detail = detail
        self.selectionStyle = selectionStyle
        self.accessoryType = accessoryType
        self.accessoryView = accessoryView
    }
}


open class BRTableDefaultCell: UITableViewCell, BRTableCellProtocol {
    public typealias Model = BRTableDefaultCellModel
    
    
    public func bind(with model: BRTableDefaultCellModel) {
        self.textLabel?.text = model.text
        self.detailTextLabel?.text = model.detail
        self.selectionStyle = model.selectionStyle
        self.accessoryType = model.accessoryType
        self.accessoryView = model.accessoryView
    }
    
    
}

