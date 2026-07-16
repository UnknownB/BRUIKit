//
//  UITextInput+Text.swift
//  BRUIKit
//
//  Created by BR on 2026/7/15.
//

import UIKit
import BRFoundation


@MainActor
public extension BRWrapper where Base: UITextInput {


    /// 輸入文字
    private var text: String {
        if let range = base.textRange(from: base.beginningOfDocument, to: base.endOfDocument), let text = base.text(in: range) {
            return text
        }
        return ""
    }

    
    /// 檢查輸入文字是否超出字數上限
    func isExceedingMaxLength(_ maxLength: Int) -> Bool {
        guard maxLength > 0 else {
            return false
        }
        
        // 當 markedTextRange != nil 代表目前正在拼音組字中
        guard base.markedTextRange == nil else {
            return false
            
        }
        return text.count > maxLength
    }

    
    /// 根據游標位置刪除超過上限的字串
    func removeExceedingText(maxLength: Int) {
        let text = self.text
        let dropCount = max(0, text.count - maxLength)
        
        let cursorIndex = self.range(from: base.selectedTextRange, in: text).upperBound
        let removeStart = text.index(cursorIndex, offsetBy: -dropCount, limitedBy: text.startIndex) ?? text.startIndex
        guard let removeRange = self.textRange(from: removeStart..<cursorIndex, in: text) else { return }
        
        base.replace(removeRange, withText: "")
        
        DispatchQueue.main.async {
            base.selectedTextRange = self.textRange(from: removeStart..<removeStart, in: text)
        }
    }
    
    
    /// 移除輸入文字中的基礎注入攻擊樣式
    @discardableResult
    func removeBasicInjectionPatterns() -> Bool {
        guard base.markedTextRange == nil else { return false }

        let text = self.text
        let filtered = text.br.removingBasicInjectionPatterns()
        guard filtered != text else { return false }
        
        guard let fullRange = base.textRange(from: base.beginningOfDocument, to: base.endOfDocument) else { return false }
        base.replace(fullRange, withText: filtered)

        if let newCursorIndex = text.br.firstDifferenceIndex(with: filtered) {
            DispatchQueue.main.async {
                base.selectedTextRange = self.textRange(from: newCursorIndex..<newCursorIndex, in: filtered)
            }
        }
        
        return true
    }


}
