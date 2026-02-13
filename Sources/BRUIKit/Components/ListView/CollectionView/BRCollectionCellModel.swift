//
//  BRCollectionCellModel.swift
//  BRUIKit
//
//  Created by BR on 2026/2/12.
//

import UIKit


open class BRCollectionCellModel: Hashable {
    open var id: String
    open var image: UIImage?
    open var text: String?
    open var textColor: UIColor?
    open var detail: String?
    
    open var backgroundColor: UIColor?
    open var backgroundView: UIView?
    open var selectedBackgroundView: UIView?
    
    open var isSelected: Bool = false
    
    
    public static func == (lhs: BRCollectionCellModel, rhs: BRCollectionCellModel) -> Bool {
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
    open func backgroundColor(_ color: UIColor?) -> Self {
        self.backgroundColor = color
        return self
    }
    
    
    @discardableResult
    open func backgroundView(_ view: UIView?) -> Self {
        self.backgroundView = view
        return self
    }
    
    
    @discardableResult
    open func selectedBackgroundView(_ view: UIView?) -> Self {
        self.selectedBackgroundView = view
        return self
    }
    
    
    @discardableResult
    open func isSelected(_ flag: Bool) -> Self {
        self.isSelected = flag
        return self
    }
        
    
}
