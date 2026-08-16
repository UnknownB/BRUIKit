//
//  TextViewRTF.swift
//  BRUIKit
//
//  Created by BR on 2025/10/21.
//

import Foundation
import UIKit


@MainActor
public final class TextViewRTF {
    
    public var actions: [URL: BRTextView.TappableAction] = [:]
        
    
    // MARK: - 添加富文本
    
    
    public func font(for word: String, font: UIFont, in attributed: NSAttributedString?) -> NSAttributedString? {
        applyAttributes([.font: font], to: word, in: attributed)
    }
    
    
    public func color(for word: String, color: UIColor, in attributed: NSAttributedString?) -> NSAttributedString? {
        applyAttributes([.foregroundColor: color], to: word, in: attributed)
    }
    
    
    public func underline(for word: String, style: NSUnderlineStyle = .single, color: UIColor? = nil, in attributed: NSAttributedString?) -> NSAttributedString? {
        var attrs: [NSAttributedString.Key: Any] = [.underlineStyle: style.rawValue]
        if let color = color { attrs[.underlineColor] = color }
        return applyAttributes(attrs, to: word, in: attributed)
    }
    
    
    public func strikethrough(for word: String, style: NSUnderlineStyle = .single, color: UIColor? = nil, in attributed: NSAttributedString?) -> NSAttributedString? {
        var attrs: [NSAttributedString.Key: Any] = [.strikethroughStyle: style.rawValue]
        if let color = color { attrs[.strikethroughColor] = color }
        return applyAttributes(attrs, to: word, in: attributed)
    }
    
    
    // MARK: - Tap
    
    
    public func addTappable(for word: String, action: @escaping BRTextView.TappableAction, in attributed: NSAttributedString?) -> NSAttributedString? {
        let linkID = UUID().uuidString
        let fakeURL = URL(string: "richtext://\(linkID)")!
        actions[fakeURL] = action
        
        var attrs: [NSAttributedString.Key: Any] = [:]
        attrs[.link] = fakeURL
        return applyAttributes([.link: fakeURL], to: word, in: attributed)
    }
    
    
    // MARK: - Help
    
    
    public func range(of word: String, in attributed: NSAttributedString?) -> NSRange? {
        guard let attributed = attributed else {
            return nil
        }
        let nsText = attributed.string as NSString
        let range = nsText.range(of: word)
        return range.location == NSNotFound ? nil : range
    }
    
    
    public func applyAttributes(_ attrs: [NSAttributedString.Key: Any], to word: String, in attributed: NSAttributedString?) -> NSAttributedString? {
        guard
            let attributed = attributed,
            let range = range(of: word, in: attributed),
            let mutable = attributed.mutableCopy() as? NSMutableAttributedString
        else {
            return attributed
        }
        mutable.addAttributes(attrs, range: range)
        return mutable
    }
    
    
}
