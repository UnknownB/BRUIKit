//
//  BRTextFieldGroupView.swift
//  BRUIKit
//
//  Created by BR on 2026/1/20.
//

import UIKit


/// BRTextFieldGroupView 提供將一組 TextField 整合成單一輸入框的功能，可以用來做常見的驗證碼輸入介面
open class BRTextFieldGroupView<TextField: BRTextField>: UIView {
    private let layout = BRLayout()
    

    /// 獲得焦點的輸入欄位索引值
    @Published public var focusedTextFieldIndex: Int? = nil
    
    
    /// 所有輸入框都完成輸入
    @Published public var isComplete: Bool = false
    
    
    /// 所有輸入欄位合併字串
    public var combinedText: String {
        stackView.arrangedSubviews.compactMap {$0 as? TextField }.compactMap(\.text).joined()
    }
    
    
    // MARK: - UI 元件

    
    private let stackView: UIStackView = UIStackView()
        .br.axis(.horizontal)
        .br.alignment(.fill)
        .br.distribution(.equalSpacing)
    
    
    // MARK: - LifeCycle
    
    
    public init(with textFields: [TextField]) {
        super.init(frame: .zero)
        setupLayout()
        textFields.forEach { addTextField($0) }
    }
    

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - UI
    
    
    private func setupLayout() {
        self.addSubview(stackView)
                
        layout.activate {
            stackView.br.top == self.br.top
            stackView.br.bottom == self.br.bottom
            stackView.br.left == self.br.left
            stackView.br.right == self.br.right
        }
    }
    
    
    // MARK: - Data
    

    @MainActor
    public func addTextField(_ textField: TextField) {
        adjustText(textField)
        stackView.addArrangedSubview(textField)
        NotificationCenter.default.addObserver(self, selector: #selector(onTextDidBegin), name: UITextField.textDidBeginEditingNotification, object: textField)
        NotificationCenter.default.addObserver(self, selector: #selector(onTextDidChange), name: UITextField.textDidChangeNotification, object: textField)
        NotificationCenter.default.addObserver(self, selector: #selector(onTextDidEnd), name: UITextField.textDidEndEditingNotification, object: textField)
        updateCompletedFlag()
    }
    
    
    public func removeTextField(_ textField: TextField) {
        stackView.removeArrangedSubview(textField)
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
        guard let textField = stackView.arrangedSubviews[index] as? TextField else {
            return
        }
        adjustText(textField)
        updateCompletedFlag()
                        
        if textField.text?.count == 0 {
            if index > 0 {
                stackView.arrangedSubviews[index - 1].becomeFirstResponder()
            }
        } else {
            if index < stackView.arrangedSubviews.count - 1 {
                stackView.arrangedSubviews[index + 1].becomeFirstResponder()
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
        guard let textField = sender.object as? TextField else {
            return nil
        }
        let index = stackView.arrangedSubviews.firstIndex(of: textField)
        return index
    }
    
    
    private func adjustText(_ textField: TextField) {
        if let text = textField.text {
            textField.text = String(text.suffix(1))
        }
    }
    
    
    private func updateCompletedFlag() {
        isComplete = stackView.arrangedSubviews
            .compactMap { $0 as? TextField }
            .allSatisfy { ($0.text?.count ?? 0) == 1 }
    }

    
}
