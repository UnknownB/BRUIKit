//
//  BRTextView.swift
//  BRUIKit
//
//  Created by BR on 2025/10/21.
//

import UIKit


open class BRTextView: UITextView, UITextViewDelegate {
    
    public let RTF = TextViewRTF()
    public let placeholderLabel = BRLabel()
    
    public typealias TappableAction = () -> Void
    
    
    // MARK: - LifeCycle
    
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    open override var text: String! {
        didSet {
            textDidChange()
            RTF.actions.removeAll()
        }
    }
    
    
    open override var attributedText: NSAttributedString? {
        didSet {
            RTF.setAttributedText(attributedText)
        }
    }
    
    
    open override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    
    // MARK: - UI
    
    
    private func setup() {
        RTF.setup(for: self)
        delegate = self
        placeholderLabel.numberOfLines = 0
        placeholderLabel.font = font
        placeholderLabel.isUserInteractionEnabled = false
        addSubview(placeholderLabel)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
    }
    
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let inset = textContainerInset
        let horizontalPadding = textContainer.lineFragmentPadding
        let maxWidth = bounds.width - inset.left - inset.right - horizontalPadding * 2
        
        placeholderLabel.frame = CGRect(
            x: inset.left + horizontalPadding,
            y: inset.top,
            width: maxWidth,
            height: placeholderLabel.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude)).height
        )
    }
    
    
    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    
    // MARK: - UITextViewDelegate
    
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if let action = RTF.actions[URL] {
            action()
            return false // prevent system default
        }
        return true
    }
    
    
}
