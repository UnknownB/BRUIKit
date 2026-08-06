//
//  BRTextView.swift
//  BRUIKit
//
//  Created by BR on 2025/10/21.
//

import UIKit


/// BRTextView 以組合（BRView 持有內部 UITextView）取代繼承，方便添加子視圖
open class BRTextView: BRView {

    private let countLayout = BRLayout()
    
    public final class InputTextView: UITextView, BRResponderProtocol {
        public var keyboardPadding: CGFloat?
        public var keyboardToolbarConfig = BRKeyboardToolbarConfig()
    }

    public typealias TappableAction = () -> Void

    public let RTF = TextViewRTF()
    
    open var onTextDidBeginEditing: ((BRTextView) -> Void)?
    
    open var onTextDidChange: ((BRTextView) -> Void)?
    
    open var onTextDidEndEditing: ((BRTextView) -> Void)?
    
    
    /// 自訂 countLabel 顯示字串的閉包，傳入目前字數與最大限制字數，回傳要顯示的字串
    public var onCustomCountFormatter: ((_ count: Int, _ maxLength: Int) -> String)? {
        didSet {
            updateCountLabel()
        }
    }
    
    
    // MARK: - UI 元件
    
    
    public let inputTextView = InputTextView()
    public let placeholderLabel = BRLabel()
    public let countLabel = BRLabel()

    
    // MARK: - 屬性
    
    
    /// 鍵盤上緣與輸入框之間的間距
    public var keyboardPadding: CGFloat? {
        get { inputTextView.keyboardPadding }
        set { inputTextView.keyboardPadding = newValue }
    }
    

    /// 字數上限，0 為不限制
    public var maxLength: Int = 0 {
        didSet {
            countLabel.isHidden = maxLength <= 0
            updateCountLabel()
            DispatchQueue.main.async { [self] in
                if inputTextView.br.isExceedingMaxLength(maxLength) {
                    inputTextView.br.removeExceedingText(maxLength: maxLength)
                }
            }
        }
    }

    
    /// 是否啟用基礎注入攻擊樣式過濾，預設關閉
    public var isBasicInjectionFilterEnabled: Bool = false


    /// 文字變更時是否觸發 `onTextDidChange`，預設開啟
    public var isTextChangeEventEnabled: Bool = true


    public var text: String! {
        get { inputTextView.text }
        set { setText(newValue, triggerEvent: isTextChangeEventEnabled) }
    }


    public var attributedText: NSAttributedString? {
        get { inputTextView.attributedText }
        set {
            inputTextView.attributedText = newValue
            RTF.setAttributedText(newValue)
        }
    }


    public var font: UIFont? {
        get { inputTextView.font }
        set {
            inputTextView.font = newValue
            placeholderLabel.font = newValue
        }
    }


    public var textColor: UIColor? {
        get { inputTextView.textColor }
        set { inputTextView.textColor = newValue }
    }
    
    
    open var textBackgroundColor: UIColor? {
        get { inputTextView.backgroundColor }
        set { inputTextView.backgroundColor = newValue }
    }


    public var textAlignment: NSTextAlignment {
        get { inputTextView.textAlignment }
        set { inputTextView.textAlignment = newValue }
    }


    public var linkTextAttributes: [NSAttributedString.Key: Any]! {
        get { inputTextView.linkTextAttributes }
        set { inputTextView.linkTextAttributes = newValue }
    }


    public var isEditable: Bool {
        get { inputTextView.isEditable }
        set { inputTextView.isEditable = newValue }
    }


    public var isSelectable: Bool {
        get { inputTextView.isSelectable }
        set { inputTextView.isSelectable = newValue }
    }


    public var isScrollEnabled: Bool {
        get { inputTextView.isScrollEnabled }
        set { inputTextView.isScrollEnabled = newValue }
    }


    public var keyboardType: UIKeyboardType {
        get { inputTextView.keyboardType }
        set { inputTextView.keyboardType = newValue }
    }


    public var returnKeyType: UIReturnKeyType {
        get { inputTextView.returnKeyType }
        set { inputTextView.returnKeyType = newValue }
    }


    public var autocapitalizationType: UITextAutocapitalizationType {
        get { inputTextView.autocapitalizationType }
        set { inputTextView.autocapitalizationType = newValue }
    }


    public var autocorrectionType: UITextAutocorrectionType {
        get { inputTextView.autocorrectionType }
        set { inputTextView.autocorrectionType = newValue }
    }


    public var spellCheckingType: UITextSpellCheckingType {
        get { inputTextView.spellCheckingType }
        set { inputTextView.spellCheckingType = newValue }
    }


    public var textContainerInset: UIEdgeInsets {
        get { inputTextView.textContainerInset }
        set {
            inputTextView.textContainerInset = newValue
            placeholderLabel.br.contentInsets(newValue)
        }
    }


    public var textContainer: NSTextContainer {
        inputTextView.textContainer
    }


    public weak var delegate: UITextViewDelegate? {
        get { inputTextView.delegate }
        set { inputTextView.delegate = newValue }
    }


    open override var canBecomeFirstResponder: Bool {
        inputTextView.canBecomeFirstResponder
    }


    open override var isFirstResponder: Bool {
        inputTextView.isFirstResponder
    }


    @discardableResult
    open override func becomeFirstResponder() -> Bool {
        inputTextView.becomeFirstResponder()
    }


    @discardableResult
    open override func resignFirstResponder() -> Bool {
        inputTextView.resignFirstResponder()
    }


    // MARK: - LifeCycle


    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - UI


    open override func setupUI() {
        super.setupUI()
        inputTextView.delegate = self
        inputTextView.backgroundColor = .clear
        placeholderLabel.numberOfLines = 0
        placeholderLabel.contentInsets = inputTextView.textContainerInset
        countLabel.isHidden = true
    }


    open override func setupLayout() {
        super.setupLayout()

        contentView.addSubview(inputTextView)
        contentView.addSubview(placeholderLabel)
        contentView.addSubview(countLabel)

        layout.activate {
            inputTextView.br.top == contentView.br.top
            inputTextView.br.left == contentView.br.left
            inputTextView.br.right == contentView.br.right
            inputTextView.br.bottom == contentView.br.bottom

            placeholderLabel.br.top == contentView.br.top
            placeholderLabel.br.left == contentView.br.left + 6 // 視覺調整
            placeholderLabel.br.right == contentView.br.right
        }

        setCountLayout(nil)
    }
    
    
    open func setCountLayout(_ closure: ((BRTextView, BRLabel, BRLayout) -> Void)?) {
        countLayout.deactivateAll()
        if let closure {
            closure(self, countLabel, countLayout)
        } else {
            countLayout.activate {
                countLabel.br.right == self.br.right - 8
                countLabel.br.bottom == self.br.bottom - 8
            }
        }
    }
    
    
    // MARK: - Event


    open override func setupEvent() {
        super.setupEvent()
        NotificationCenter.default.addObserver(self, selector: #selector(textDidBeginEditing), name: UITextView.textDidBeginEditingNotification, object: inputTextView)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: inputTextView)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditing), name: UITextView.textDidEndEditingNotification, object: inputTextView)
    }


    @objc open func textDidBeginEditing() {
        onTextDidBeginEditing?(self)
    }


    @objc open func textDidEndEditing() {
        onTextDidEndEditing?(self)
    }

    
    @objc open func textDidChange() {
        handleTextChange()
    }


    /// 設定文字內容，並決定這次設定是否觸發 `onTextDidChange`
    ///
    /// 僅暫時覆寫 `isTextChangeEventEnabled`，設定完即還原；無論是否觸發事件，字數上限與注入過濾都仍會執行
    open func setText(_ text: String?, triggerEvent: Bool) {
        let isEnabled = isTextChangeEventEnabled
        isTextChangeEventEnabled = triggerEvent
        inputTextView.text = text
        handleTextChange()
        RTF.actions.removeAll()
        isTextChangeEventEnabled = isEnabled
    }


    private func handleTextChange() {
        if isBasicInjectionFilterEnabled {
            if inputTextView.br.removeBasicInjectionPatterns() {
                return
            }
        }
        if inputTextView.br.isExceedingMaxLength(maxLength) {
            inputTextView.br.removeExceedingText(maxLength: maxLength)
            return
        }
        placeholderLabel.isHidden = !inputTextView.text.isEmpty
        updateCountLabel()
        if isTextChangeEventEnabled {
            onTextDidChange?(self)
        }
    }


    private func updateCountLabel() {
        guard maxLength > 0 else { return }
        let currentLength = inputTextView.text?.count ?? 0
        
        if let formatter = onCustomCountFormatter {
            countLabel.text = formatter(currentLength, maxLength)
        } else {
            countLabel.text = "\(currentLength) / \(maxLength)"
        }
    }


}


// MARK: - UITextViewDelegate


extension BRTextView: UITextViewDelegate {

    open func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if let action = RTF.actions[URL] {
            action()
            return false
        }
        return true
    }

}
