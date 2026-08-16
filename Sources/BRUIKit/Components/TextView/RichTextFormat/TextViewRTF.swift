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
    
    
    public func applyAttributes(_ attrs: [NSAttributedString.Key: Any], to word: String, in attributed: NSAttributedString?) -> NSAttributedString? {
        guard
            let attributed = attributed,
            let mutable = attributed.mutableCopy() as? NSMutableAttributedString
        else {
            return attributed
        }
        
        let nsText = attributed.string as NSString
        var searchRange = NSRange(location: 0, length: attributed.length)
        
        while searchRange.length > 0 {
            let tokenRange = nsText.range(of: word, range: searchRange)
            guard tokenRange.location != NSNotFound else { break }
            mutable.addAttributes(attrs, range: tokenRange)
            let nextLocation = tokenRange.location + tokenRange.length
            searchRange = NSRange(location: nextLocation, length: nsText.length - nextLocation)
        }
        return mutable
    }
    
    
}
