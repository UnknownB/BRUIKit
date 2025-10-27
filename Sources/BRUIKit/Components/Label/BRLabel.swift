//
//  BRLabel.swift
//  BRUIKit
//
//  Created by BR on 2025/9/4.
//

import UIKit


open class BRLabel: UILabel {
    
    public typealias TappableAction = () -> Void
    public let RTF = LabelRTF()
    
    
    /// label 的內邊距
    open var contentInsets: UIEdgeInsets = .zero
    
    
    // MARK: - LifeCycle
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup() {
        RTF.setup(for: self)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
    }
    
    
    // MARK: - 富文本設定
    
    
    open override var text: String? {
        didSet {
            RTF.actions.removeAll()
        }
    }
    
    
    open override var attributedText: NSAttributedString? {
        didSet {
            RTF.setAttributedText(attributedText)
        }
    }
    

    open override var numberOfLines: Int {
        didSet {
            RTF.setNumberOfLines(numberOfLines)
        }
    }
    

    open override var lineBreakMode: NSLineBreakMode {
        didSet {
            RTF.setLineBreakMode(lineBreakMode)
        }
    }
    
    
    // MARK: - Layout
    
    
    open override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let width = size.width + contentInsets.left + contentInsets.right
        let height = size.height + contentInsets.top + contentInsets.bottom
        return CGSize(width: width, height: height)
    }
    
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let insetBounds = bounds.inset(by: contentInsets)
        RTF.setSize(insetBounds.size)
    }
    
    
    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInsets))
    }
        
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: contentInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        return textRect
    }
    
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        RTF.handleTap(for: self, gesture: gesture)
    }
    
    
}
