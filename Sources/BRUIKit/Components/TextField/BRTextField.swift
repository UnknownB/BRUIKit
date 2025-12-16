//
//  BRTextField.swift
//  BRUIKit
//
//  Created by BR on 2025/12/4.
//

import UIKit

open class BRTextField: UITextField, ObservableObject {

    private let stateHelper = BRTextFieldStateHelper()
    private let validator = BRTextFieldValidator()
    private(set) public var rules: [BRTextFieldRule] = []

    private var isRequired = false
    
    /// 輸入緩衝，預設為1秒
    public var debounce: TimeInterval = 1
    
    /// 內邊距
    public var contentInsets: UIEdgeInsets = .zero
    

    // MARK: - LifeCycle

    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupEvent()
    }

    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupEvent()
    }
    
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        let insetRect = bounds.inset(by: contentInsets)
        return super.textRect(forBounds: insetRect)
    }
    

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let insetRect = bounds.inset(by: contentInsets)
        return super.editingRect(forBounds: insetRect)
    }

    
    open override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let width = size.width + contentInsets.left + contentInsets.right
        let height = size.height + contentInsets.top + contentInsets.bottom
        return CGSize(width: width, height: height)
    }

    
    // MARK: - State
    
    
    /// 輸入框驗證狀態
    @Published open private(set) var fieldState: BRTextFieldState = .normal

    
    open func setBackgroundColor(_ color: UIColor?, for state: BRTextFieldState) {
        stateHelper.backgroundColors[state] = color
        if fieldState == state {
            backgroundColor = color
        }
    }
    
    
    open func setBorder(color: UIColor?, width: CGFloat, for state: BRTextFieldState) {
        stateHelper.borderColors[state] = color
        stateHelper.borderWidths[state] = width
        if fieldState == state {
            layer.borderColor = color?.cgColor
            layer.borderWidth = width
        }
    }
    
    
    // MARK: - Rule
    
    
    /// 已驗證
    open var isValid: Bool {
        if isRequired, text?.isEmpty == true {
            return false
        }
        return rules.filter({ $0.status == .failed }).count == 0
    }
    
    
    /// 驗證所有規則
    open func validateAll() {
        validator.validateAll(with: rules) {
            self.updateState()
        }
    }
    
    
    /// 清除規則
    open func removeRules() {
        rules.removeAll()
        updateState()
    }
    
    
    /// 添加必填規則
    @discardableResult
    open func addRequiredRule(at events: [BRTextFieldRule.Event]) -> BRTextFieldRule {
        let rule = BRTextFieldRule.required(with: self, events: events)
        rules.append(rule)
        isRequired = true
        return rule
    }
    
    
    /// 添加最小長度規則
    @discardableResult
    open func addMinLengthRule(at events: [BRTextFieldRule.Event], length: Int) -> BRTextFieldRule {
        let rule = BRTextFieldRule.min(with: self, events: events, length: length)
        rules.append(rule)
        return rule
    }
    
    
    /// 添加最大長度規則
    @discardableResult
    open func addMaxLengthRule(at events: [BRTextFieldRule.Event], length: Int) -> BRTextFieldRule {
        let rule = BRTextFieldRule.max(with: self, events: events, length: length)
        rules.append(rule)
        return rule
    }


    /// 添加正則表示法規則
    @discardableResult
    open func addRegexRule(at events: [BRTextFieldRule.Event], pattern: String) -> BRTextFieldRule {
        let rule = BRTextFieldRule.regex(with: self, events: events, pattern: pattern)
        rules.append(rule)
        return rule
    }
    
    
    /// 添加自訂規則
    @discardableResult
    open func addCustomRule(at events: [BRTextFieldRule.Event], constraint: @escaping BRTextFieldRule.Constraint) -> BRTextFieldRule {
        let rule = BRTextFieldRule.init(textField: self, events: events, constraint: constraint)
        rules.append(rule)
        return rule
    }
    
    
    // MARK: - Password
    
    
    open func setSecureTextEntryButton(_ button: UIButton) {
        button.addTarget(self, action: #selector(onSecureButtonTapped(_:)), for: .touchUpInside)
        self.br.rightView(button, mode: .always)
        self.isSecureTextEntry = true
    }
    
    
    @objc private func onSecureButtonTapped(_ sender: UIButton) {
        isSecureTextEntry.toggle()
        sender.isSelected.toggle()
    }

    
    // MARK: - Event
    

    private func setupEvent() {
        addTarget(self, action: #selector(onTextDidBegin), for: .editingDidBegin)
        addTarget(self, action: #selector(onTextChanged), for: .editingChanged)
        addTarget(self, action: #selector(onTextDidEnd), for: .editingDidEnd)
    }
    
    
    @objc private func onTextDidBegin() {
        validator.onBeging(with: rules) {
            self.updateState()
        }
    }

    
    @objc private func onTextChanged() {
        validator.onChange(with: rules, debounce: debounce) {
            self.updateState()
        }
    }
    
    
    @objc private func onTextDidEnd() {
        validator.onEnd(with: rules) {
            self.updateState()
        }
    }
    
    
    private func updateState() {
        if isValid {
            fieldState = isFocused ? .focused : .normal
        } else {
            fieldState = .failed
        }
        stateHelper.applyState(to: self)
    }


}
