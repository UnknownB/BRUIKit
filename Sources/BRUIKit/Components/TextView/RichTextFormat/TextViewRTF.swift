//
//  TextViewRTF.swift
//  BRUIKit
//
//  Created by BR on 2025/10/21.
//

import Foundation
import UIKit


public final class TextViewRTF {

    public var textStorage: NSTextStorage?
    public var actions: [URL: BRTextView.TappableAction] = [:]
    
    
    // MARK: - Init

    
    public func setup(for textView: UITextView) {
    }
    
    
    // MARK: - 屬性設定

    
    public func setAttributedText(_ attributed: NSAttributedString?) {
        if let attributedText = attributed {
            textStorage = NSTextStorage(attributedString: attributedText)
        } else {
            textStorage = nil
        }
    }
    
    
    // MARK: - 添加富文本
    
    
    public func font(for word: String, font: UIFont) -> NSAttributedString? {
        applyAttributes([.font: font], to: word)
    }
    
    
    public func color(for word: String, color: UIColor) -> NSAttributedString? {
        applyAttributes([.foregroundColor: color], to: word)
    }
    
    
    public func underline(for word: String, style: NSUnderlineStyle = .single, color: UIColor? = nil) -> NSAttributedString? {
        var attrs: [NSAttributedString.Key: Any] = [.underlineStyle: style.rawValue]
        if let color = color { attrs[.underlineColor] = color }
        return applyAttributes(attrs, to: word)
    }
    
    
    public func strikethrough(for word: String, style: NSUnderlineStyle = .single, color: UIColor? = nil) -> NSAttributedString? {
        var attrs: [NSAttributedString.Key: Any] = [.strikethroughStyle: style.rawValue]
        if let color = color { attrs[.strikethroughColor] = color }
        return applyAttributes(attrs, to: word)
    }
    
    
    // MARK: - Tap
    
    
    public func addTappable(for word: String, action: @escaping BRTextView.TappableAction) -> NSAttributedString? {
        let linkID = UUID().uuidString
        let fakeURL = URL(string: "richtext://\(linkID)")!
        actions[fakeURL] = action
        
        var attrs: [NSAttributedString.Key: Any] = [:]
        attrs[.link] = fakeURL
        return applyAttributes(attrs, to: word)
    }

    
    // MARK: - Help
    
    
    func range(of word: String) -> NSRange? {
        guard let textStorage = textStorage else {
            return nil
        }
        let nsText = textStorage.string as NSString
        let range = nsText.range(of: word)
        return range.location == NSNotFound ? nil : range
    }

    
    public func applyAttributes(_ attrs: [NSAttributedString.Key: Any], to word: String) -> NSAttributedString? {
        guard
            let textStorage = textStorage,
            let range = range(of: word)
        else {
            return textStorage
        }
        textStorage.addAttributes(attrs, range: range)
        return textStorage
    }
    
    
}
