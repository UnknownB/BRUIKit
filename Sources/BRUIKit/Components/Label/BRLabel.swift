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
        // 內邊距 計算修正
        let size = super.intrinsicContentSize
        let width = size.width + contentInsets.left + contentInsets.right
        let height = size.height + contentInsets.top + contentInsets.bottom
        return CGSize(width: width, height: height)
    }
    
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        // 內邊距 計算修正
        let insetRect = bounds.inset(by: contentInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        return textRect
    }
    
    
}
