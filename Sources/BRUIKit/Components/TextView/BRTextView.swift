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
    
    
    open override var textContainerInset: UIEdgeInsets {
        didSet {
            placeholderLabel.br.contentInsets(textContainerInset)
        }
    }
    
    
    // MARK: - UI
    
    
    private func setup() {
        RTF.setup(for: self)
        delegate = self
        
        placeholderLabel.numberOfLines = 0
        placeholderLabel.isUserInteractionEnabled = false
        addSubview(placeholderLabel)
        
        BRLayout().activate {
            placeholderLabel.br.top == self.br.top
            placeholderLabel.br.left == self.br.left + 6 // 視覺調整
            placeholderLabel.br.bottom == self.br.bottom
            placeholderLabel.br.right == self.br.right
            placeholderLabel.br.width <= self.br.width
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
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
