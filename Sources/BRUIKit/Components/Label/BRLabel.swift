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
    
    
    // MARK: - LifeCycle
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open override var text: String? {
        didSet {
            actions.removeAll()
        }
    }
    
    
    open override var attributedText: NSAttributedString? {
        didSet {
            if let attributedText = attributedText {
                textStorage = NSTextStorage(attributedString: attributedText)
                textStorage?.addLayoutManager(layoutManager)
            } else {
                textStorage = nil
            }
        }
    }
    

    open override var numberOfLines: Int {
        didSet {
            textContainer.maximumNumberOfLines = numberOfLines
        }
    }
    

    open override var lineBreakMode: NSLineBreakMode {
        didSet {
            textContainer.lineBreakMode = lineBreakMode
        }
    }
    
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let insetBounds = bounds.inset(by: contentInsets)
        textContainer.size = insetBounds.size
    }
    
    
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
    
    
    // MARK: - 內邊距
    

    /// 設定 label 的內邊距
    @discardableResult
    open func contentInsets(_ insets: UIEdgeInsets) -> Self {
        self.contentInsets = insets
        return self
    }
    
    
    // MARK: - 富文本
    
    
    public typealias TappableAction = () -> Void
    private var actions: [NSRange: TappableAction] = [:]
    
    private let layoutManager = NSLayoutManager()
    private let textContainer = NSTextContainer(size: .zero)
    private var textStorage: NSTextStorage?

    
    private func setup() {
        isUserInteractionEnabled = true

        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        layoutManager.addTextContainer(textContainer)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tap)
    }
    
    
    /// 設定某個字串的字體
    @discardableResult
    public func font(for word: String, font: UIFont) -> Self {
        guard let range = getRange(of: word) else {
            return self
        }
        applyAttributes([.font: font], to: range)
        return self
    }
    
    
    /// 設定某個字串的顏色
    @discardableResult
    public func color(for word: String, color: UIColor) -> Self {
        guard let range = getRange(of: word) else {
            return self
        }
        applyAttributes([.foregroundColor: color], to: range)
        return self
    }

    
    /// 設定下劃線
    @discardableResult
    public func underline(for word: String, style: NSUnderlineStyle = .single, color: UIColor? = nil) -> Self {
        guard let range = getRange(of: word) else {
            return self
        }
        var attrs: [NSAttributedString.Key: Any] = [.underlineStyle: style.rawValue]
        if let color = color {
            attrs[.underlineColor] = color
        }
        applyAttributes(attrs, to: range)
        return self
    }

    
    /// 設定刪除線
    @discardableResult
    public func strikethrough(for word: String, style: NSUnderlineStyle = .single, color: UIColor? = nil) -> Self {
        guard let range = getRange(of: word) else {
            return self
        }
        var attrs: [NSAttributedString.Key: Any] = [.strikethroughStyle: style.rawValue]
        if let color = color {
            attrs[.strikethroughColor] = color
        }
        applyAttributes(attrs, to: range)
        return self
    }
    
    
    /// 設定點擊事件
    @discardableResult
    public func tappable(for word: String, action: @escaping TappableAction) -> Self {
        guard let range = getRange(of: word) else {
            return self
        }
        actions[range] = action
        return self
    }
    
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let _ = attributedText, let storage = textStorage else { return }

        // 1) 取得 touch 在 label 上的位置（label 的座標系）
        let locationInLabel = gesture.location(in: self)

        // 2) 抵消 contentInsets，得到在「扣掉 padding」後的座標
        let locationMinusInsets = CGPoint(x: locationInLabel.x - contentInsets.left, y: locationInLabel.y - contentInsets.top)

        // 3) 確保 layout 已經完成（usedRect / glyph info 準備好）
        layoutManager.ensureLayout(for: textContainer)

        // 4) 用於計算的 bounds（已扣內邊距）
        let insetBounds = bounds.inset(by: contentInsets)

        // 5) 文字實際使用空間（相對於 textContainer 的座標系，origin 可能非 0 或負值）
        let textBoundingBox = layoutManager.usedRect(for: textContainer)

        // 6) 根據 alignment 計算水平 offset（UILabel 會在可用寬度多餘時做置中/右對齊）
        let widthDiff = max(0, insetBounds.width - textBoundingBox.width)
        let horizontalAlignmentOffset: CGFloat
        switch textAlignment {
        case .center:
            horizontalAlignmentOffset = widthDiff / 2.0
        case .right:
            horizontalAlignmentOffset = widthDiff
        default:
            horizontalAlignmentOffset = 0.0
        }

        // 7) 垂直 offset（UILabel 會在可用高度多餘時垂直置中）
        let heightDiff = max(0, insetBounds.height - textBoundingBox.height)
        let verticalOffset = heightDiff / 2.0

        // 8) 計算 text origin（把 usedRect.origin 考慮進來）
        //    之所以要 -textBoundingBox.origin 是因為 usedRect 的 origin 可能為負或非 0
        let textOffset = CGPoint(x: horizontalAlignmentOffset - textBoundingBox.origin.x,
                                 y: verticalOffset - textBoundingBox.origin.y)

        // 9) 把 touch 點轉換到 text container 的座標系
        let locationInTextContainer = CGPoint(x: locationMinusInsets.x - textOffset.x,
                                              y: locationMinusInsets.y - textOffset.y)

        // 10) 檢查是否在 text container 範圍內（避免越界）
        guard locationInTextContainer.x >= 0,
              locationInTextContainer.y >= 0,
              locationInTextContainer.x <= textContainer.size.width,
              locationInTextContainer.y <= textContainer.size.height else {
            return
        }

        // 11) 取得 glyph -> character index（更穩健）
        let glyphIndex = layoutManager.glyphIndex(for: locationInTextContainer, in: textContainer)
        let charIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)
        guard charIndex < storage.length else { return }

        // 12) 檢查 actions（你目前用 NSRange map）
        for (range, action) in actions {
            if NSLocationInRange(charIndex, range) {
                action()
                break
            }
        }
    }
    
    
    // MARK: - Help
    
        
    private func getRange(of word: String) -> NSRange? {
        guard let attributed = attributedText else { return nil }
        let nsText = attributed.string as NSString
        let range = nsText.range(of: word)
        return range.location == NSNotFound ? nil : range
    }
    

    private func applyAttributes(_ attrs: [NSAttributedString.Key: Any], to range: NSRange) {
        guard let mutable = attributedText?.mutableCopy() as? NSMutableAttributedString else { return }
        mutable.addAttributes(attrs, range: range)
        attributedText = mutable
    }

    
}
