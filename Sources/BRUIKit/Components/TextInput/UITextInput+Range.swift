//
//  UITextInput+Range.swift
//  BRUIKit
//
//  Created by BR on 2026/7/15.
//

import UIKit
import BRFoundation


@MainActor
public extension BRWrapper where Base: UITextInput {


    /// 將 UITextRange 轉換成 Range，當失敗時 feedback 到文字結尾
    func range(from textRange: UITextRange?, in text: String) -> Range<String.Index> {
        guard let textRange else {
            return text.endIndex..<text.endIndex
        }
        
        let location = base.offset(from: base.beginningOfDocument, to: textRange.start)
        let length = base.offset(from: textRange.start, to: textRange.end)
        let range = Range(NSRange(location: location, length: length), in: text)
        
        guard location >= 0, length >= 0, let range else {
            return text.endIndex..<text.endIndex
        }
        return range
    }


    /// 將 Range 轉換成 UITextRange?
    func textRange(from range: Range<String.Index>, in text: String) -> UITextRange? {
        let nsRange = NSRange(range, in: text)
        guard let start = base.position(from: base.beginningOfDocument, offset: nsRange.location),
              let end = base.position(from: start, offset: nsRange.length) else {
            return nil
        }
        return base.textRange(from: start, to: end)
    }


}
