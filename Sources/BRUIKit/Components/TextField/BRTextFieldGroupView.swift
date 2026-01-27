//
//  BRTextFieldGroupView.swift
//  BRUIKit
//
//  Created by BR on 2026/1/20.
//

import UIKit


/// BRTextFieldGroupView 提供將一組 TextField 整合成單一輸入框的功能，可以用來做常見的驗證碼輸入介面
open class BRTextFieldGroupView: UIStackView {
    private let layout = BRLayout()
    
    
    /// 將元件添加自 UIStackView 的 arrangedSubviews 時，若元件屬於 UITextField 類型則會自動更新於此
    private(set) public var textFields: [UITextField] = []
    

    /// 獲得焦點的輸入欄位索引值
    @Published public var focusedTextFieldIndex: Int? = nil
    
    
    /// 所有輸入框都完成輸入
    @Published public var isComplete: Bool = false
    
    
    /// 所有輸入欄位合併字串
    public var combinedText: String {
        self.arrangedSubviews.compactMap {$0 as? UITextField }.compactMap(\.text).joined()
    }
    
    
    // MARK: - LifeCycle
    
    
    public init(with textFields: [UITextField]) {
        super.init(frame: .zero)
        setupLayout()
        textFields.forEach { self.addArrangedSubview($0) }
    }
    

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - UI
    
    
    private func setupLayout() {
        self.axis = .horizontal
    }
    
    
    // MARK: - Data
    
    
    open override func addArrangedSubview(_ view: UIView) {
        super.addArrangedSubview(view)
        guard let textField = view as? UITextField else {
            return
        }
        textFields.append(textField)
        adjustText(textField)
        NotificationCenter.default.addObserver(self, selector: #selector(onTextDidBegin), name: UITextField.textDidBeginEditingNotification, object: textField)
        NotificationCenter.default.addObserver(self, selector: #selector(onTextDidChange), name: UITextField.textDidChangeNotification, object: textField)
        NotificationCenter.default.addObserver(self, selector: #selector(onTextDidEnd), name: UITextField.textDidEndEditingNotification, object: textField)
        updateCompletedFlag()
    }
    
    
    open override func insertArrangedSubview(_ view: UIView, at stackIndex: Int) {
        super.insertArrangedSubview(view, at: stackIndex)
        guard let textField = view as? UITextField else {
            return
        }
        for index in self.arrangedSubviews.indices where index > stackIndex {
            if self.arrangedSubviews[index] is UITextField {
                textFields.insert(textField, at: index)
                break
            }
        }
        adjustText(textField)
        NotificationCenter.default.addObserver(self, selector: #selector(onTextDidBegin), name: UITextField.textDidBeginEditingNotification, object: textField)
        NotificationCenter.default.addObserver(self, selector: #selector(onTextDidChange), name: UITextField.textDidChangeNotification, object: textField)
        NotificationCenter.default.addObserver(self, selector: #selector(onTextDidEnd), name: UITextField.textDidEndEditingNotification, object: textField)
        updateCompletedFlag()
    }
    
    
    open override func removeArrangedSubview(_ view: UIView) {
        super.removeArrangedSubview(view)
        guard let textField = view as? UITextField else {
            return
        }
        textFields.br.removingFirstOccurrence(of: textField)
        textField.removeFromSuperview()
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidBeginEditingNotification, object: textField)
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: textField)
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidEndEditingNotification, object: textField)
        updateCompletedFlag()
    }
    

    // MARK: - Event
    
    
    @objc private func onTextDidBegin(_ sender: Notification) {
        guard let index = focusedTextFieldIndex(from: sender) else {
            return
        }
        focusedTextFieldIndex = index
    }
    
    
    @objc private func onTextDidChange(_ sender: Notification) {
        guard let index = focusedTextFieldIndex(from: sender) else {
            return
        }
        let textField = textFields[index]
        adjustText(textField)
        updateCompletedFlag()
                        
        if textField.text?.count == 0 {
            if index > 0 {
                textFields[index - 1].becomeFirstResponder()
            }
        } else {
            if index < textFields.count - 1 {
                textFields[index + 1].becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }
    }
    
    
    @objc private func onTextDidEnd(_ sender: Notification) {
        focusedTextFieldIndex = nil
    }
    
    
    // MARK: - Help
    
    
    private func focusedTextFieldIndex(from sender: Notification) -> Int? {
        guard let textField = sender.object as? UITextField else {
            return nil
        }
        let index = textFields.firstIndex(of: textField)
        return index
    }
    
    
    private func adjustText(_ textField: UITextField) {
        if let text = textField.text {
            textField.text = String(text.suffix(1))
        }
    }
    
    
    private func updateCompletedFlag() {
        isComplete = textFields.allSatisfy { ($0.text?.count ?? 0) == 1 }
    }

    
}
