//
//  LabelRTF.swift
//  BRUIKit
//
//  Created by BR on 2025/10/21.
//

import Foundation
import UIKit


@MainActor
public final class LabelRTF {

    public let layoutManager = NSLayoutManager()
    public let textContainer = NSTextContainer(size: .zero)
    public var textStorage: NSTextStorage?
    public var actions: [NSRange: BRLabel.TappableAction] = [:]
    
    
    // MARK: - Init

    
    public func setup(for label: UILabel) {
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        layoutManager.addTextContainer(textContainer)
    }
    
    
    // MARK: - 屬性設定
    
    
    public func setSize(_ size: CGSize) {
        textContainer.size = size
    }
    
    
    public func setAttributedText(_ attributed: NSAttributedString?) {
        if let attributedText = attributed {
            textStorage = NSTextStorage(attributedString: attributedText)
            textStorage?.addLayoutManager(layoutManager)
        } else {
            textStorage = nil
        }
    }
    
    
    public func setNumberOfLines(_ numberOfLines: Int) {
        textContainer.maximumNumberOfLines = numberOfLines

    }
    
    
    public func setLineBreakMode(_ lineBreakMode: NSLineBreakMode) {
        textContainer.lineBreakMode = lineBreakMode
    }
    

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
    
    
    @discardableResult
    public func addTappable(for word: String, action: @escaping BRLabel.TappableAction, in attributed: NSAttributedString?) -> Self {
        guard
            let attributed = attributed,
            let range = range(of: word, in: attributed)
        else { return self }
        
        actions[range] = action
        return self
    }

    
    public func handleTap(for label: BRLabel, gesture: UITapGestureRecognizer) {
        guard
            let _ = label.attributedText,
            let storage = textStorage
        else { return }

        let locationInLabel = gesture.location(in: label)
        let locationMinusInsets = CGPoint(x: locationInLabel.x - label.contentInsets.left, y: locationInLabel.y - label.contentInsets.top)
        
        layoutManager.ensureLayout(for: textContainer)
        let insetBounds = label.bounds.inset(by: label.contentInsets)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)

        // 根據 alignment 計算水平 offset（UILabel 會在可用寬度多餘時做置中/右對齊）
        
        let widthDiff = max(0, insetBounds.width - textBoundingBox.width)
        let horizontalAlignmentOffset: CGFloat
        switch label.textAlignment {
        case .center:
            horizontalAlignmentOffset = widthDiff / 2.0
        case .right:
            horizontalAlignmentOffset = widthDiff
        default:
            horizontalAlignmentOffset = 0.0
        }

        // offset（UILabel 會在可用高度多餘時垂直置中）
        
        let heightDiff = max(0, insetBounds.height - textBoundingBox.height)
        let verticalOffset = heightDiff / 2.0

        let textOffset = CGPoint(x: horizontalAlignmentOffset - textBoundingBox.origin.x,
                                 y: verticalOffset - textBoundingBox.origin.y)

        let locationInTextContainer = CGPoint(x: locationMinusInsets.x - textOffset.x,
                                              y: locationMinusInsets.y - textOffset.y)

        guard locationInTextContainer.x >= 0,
              locationInTextContainer.y >= 0,
              locationInTextContainer.x <= textContainer.size.width,
              locationInTextContainer.y <= textContainer.size.height else {
            return
        }

        let glyphIndex = layoutManager.glyphIndex(for: locationInTextContainer, in: textContainer)
        let charIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)
        guard charIndex < storage.length else {
            return
        }

        for (range, action) in actions {
            if NSLocationInRange(charIndex, range) {
                action()
                break
            }
        }
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
