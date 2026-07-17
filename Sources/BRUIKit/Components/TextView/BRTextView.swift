//
//  BRTextView.swift
//  BRUIKit
//
//  Created by BR on 2025/10/21.
//

import UIKit


open class BRTextView: UITextView, UITextViewDelegate, BRResponderProtocol {
    
    
    public let RTF = TextViewRTF()
    public let placeholderLabel = BRLabel()

    public typealias TappableAction = () -> Void

    public var keyboardPadding: CGFloat?

    open var onTextDidChange: ((BRTextView) -> Void)?

    /// 字數上限，0 為不限制
    public var maxLength: Int = 0 {
        didSet {
            if self.br.isExceedingMaxLength(maxLength) {
                self.br.removeExceedingText(maxLength: maxLength)
            }
        }
    }

    /// 是否啟用基礎注入攻擊樣式過濾，預設關閉
    public var isBasicInjectionFilterEnabled: Bool = false

    
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
        delegate = self
        inputAccessoryView = BRKeyboard.toolbar.accessoryView
        
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
    
    
    @objc open func textDidChange() {
        if isBasicInjectionFilterEnabled {
            if self.br.removeBasicInjectionPatterns() {
                return
            }
        }
        if self.br.isExceedingMaxLength(maxLength) {
            self.br.removeExceedingText(maxLength: maxLength)
            return
        }
        placeholderLabel.isHidden = !text.isEmpty
        onTextDidChange?(self)
    }


    // MARK: - UITextViewDelegate
    
    
    open func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if let action = RTF.actions[URL] {
            action()
            return false // prevent system default
        }
        return true
    }
    
    
}
