//
//  BRLimitedTextView.swift
//  BRUIKit
//
//  Created by BR on 2025/11/3.
//

import UIKit


open class BRLimitedTextView: BRTextView {
    
    
    public var maxLength: Int = 0 {
        didSet {
            enforceLimitIfNeeded()
        }
    }
    
    
    /// 設定字數上限
    @discardableResult
    open func maxLength(_ maxLength: Int) -> Self {
        self.maxLength = maxLength
        return self
    }
    
    
    open override func textDidChange() {
        enforceLimitIfNeeded()
        super.textDidChange()
    }
    
    
    private func enforceLimitIfNeeded() {
        guard maxLength > 0, text.count > maxLength else {
            return
        }
        let limitedText = text.prefix(maxLength)
        text = String(limitedText)
        selectedRange = NSRange(location: text.count, length: 0)
    }
    
    
}
