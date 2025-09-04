//
//  BRLabel.swift
//  BRUIKit
//
//  Created by BR on 2025/9/4.
//

import UIKit


open class BRLabel: UILabel {
    
    /// label 的內邊距
    public var contentInsets: UIEdgeInsets = .zero
    
    
    // MARK: - DSL
    

    /// 設定 label 的內邊距
    @discardableResult
    open func contentInset(_ insets: UIEdgeInsets) -> Self {
        self.contentInsets = insets
        return self
    }

    
    // MARK: - LifeCycle
    
    
    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInsets))
    }
    

    open override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let width = size.width + contentInsets.left + contentInsets.right
        let height = size.height + contentInsets.top + contentInsets.bottom
        return CGSize(width: width, height: height)
    }
    
    
}
