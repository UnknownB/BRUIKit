//
//  BRCollectionViewCell.swift
//  BRUIKit
//
//  Created by BR on 2025/8/20.
//

import UIKit


public final class BRCollectionCellModel: Hashable {
    public var image: UIImage?
    public var text: String?
    public var detail: String?
    
    public var backgroundColor: UIColor?
    public var backgroundView: UIView?
    public var selectedBackgroundView: UIView?
    
    public var isSelected: Bool = false
    public var isHighlighted: Bool = false
    
    
    public static func == (lhs: BRCollectionCellModel, rhs: BRCollectionCellModel) -> Bool {
        lhs.text == rhs.text && lhs.detail == rhs.detail
    }

    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(detail)
    }
    
    
    public init(_ text: String? = nil) {
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
    public func backgroundColor(_ color: UIColor?) -> Self {
        self.backgroundColor = color
        return self
    }
    
    @discardableResult
    public func backgroundView(_ view: UIView?) -> Self {
        self.backgroundView = view
        return self
    }
    
    @discardableResult
    public func selectedBackgroundView(_ view: UIView?) -> Self {
        self.selectedBackgroundView = view
        return self
    }
    
    @discardableResult
    public func isSelected(_ flag: Bool) -> Self {
        self.isSelected = flag
        return self
    }
    
    @discardableResult
    public func isHighlighted(_ flag: Bool) -> Self {
        self.isHighlighted = flag
        return self
    }

    
}


open class BRCollectionCell: UICollectionViewCell, BRCellProtocol {
    public typealias Model = BRCollectionCellModel
    
    
    public func bind(with model: BRCollectionCellModel, isFirst: Bool, isLast: Bool) {
        if #available(iOS 14.0, *) {
            var config = UIListContentConfiguration.cell()
            config.image = model.image
            config.text = model.text
            config.secondaryText = model.detail
            self.contentConfiguration = config
        }
        self.isSelected = model.isSelected
        self.isHighlighted = model.isHighlighted
        self.selectedBackgroundView = model.selectedBackgroundView
        self.backgroundView = model.backgroundView
        self.backgroundColor = model.backgroundColor
    }
}

