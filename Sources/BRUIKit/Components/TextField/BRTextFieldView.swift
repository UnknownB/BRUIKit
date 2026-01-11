//
//  BRFieldView.swift
//  BRUIKit
//
//  Created by BR on 2025/12/4.
//

import BRFoundation
import UIKit


open class BRTextFieldView: UIStackView {

    public let titleLabel = BRLabel()
    public let textField = BRTextField()
    public let ruleStackView = UIStackView()
        .br.axis(.vertical)
    public let hintLabel = BRLabel()
        .br.lines(0)
    
    
    // MARK: - LifeCycle
    

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        bind()
    }
    

    public required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        bind()
    }

    
    private func setup() {
        self
            .br.axis(.vertical)
            .br.spacing(4)
            .br.addArranged(titleLabel)
            .br.addArranged(textField)
            .br.addArranged(ruleStackView)
            .br.addArranged(hintLabel)
    }

    
    private func bind() {
        BRTask.bind(to: textField.$fieldState, on: self) { _ in
            self.updateState()
        }
    }
    
    
    private func updateState() {
        var hint: String?
        for rule in textField.rules {
            updateRuleView(for: rule)
            if rule.status == .failed, hint == nil {
                hint = rule.hint
            }
        }
        if textField.fieldState == .failed {
            hintLabel.text = hint
            hintLabel.isHidden = false
        } else {
            hintLabel.isHidden = true
        }
        self.layoutSubviews()
        textField.keyboardPadding = ruleStackView.frame.height + hintLabel.frame.height + self.spacing + 5
    }
    
    
    private func updateRuleView(for rule: BRTextFieldRule) {
        guard rule.title != nil else {
            return
        }
        
        let view = ruleStackView.arrangedSubviews.first { view in
            if let view = view as? BRTextFieldRuleView {
                return view.rule.title == rule.title
            }
            return false
        }
        
        if let view = view as? BRTextFieldRuleView {
            view.updateState()
        } else {
            let view = BRTextFieldRuleView(rule: rule)
            ruleStackView.br.addArranged(view)
            view.updateState()
        }
    }
    
    
}


open class BRTextFieldRuleView: UIStackView {
    public let rule: BRTextFieldRule
    
    public let iconImageView = UIImageView()
        .br.contentMode(.scaleAspectFit)
    
    public let titleLabel = BRLabel()
    
    
    // MARK: - LifeCycle
    
    
    public init(rule: BRTextFieldRule) {
        self.rule = rule
        super.init(frame: .zero)
        setup()
    }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup() {
        self
            .br.axis(.horizontal)
            .br.spacing(4)
            .br.addArranged(iconImageView)
            .br.addArranged(titleLabel)
        
        BRLayout().activate {
            iconImageView.br.width == 20
        }
    }
    
    
    public func updateState() {
        iconImageView.image = rule.status == .failed ? UIImage(systemName: "xmark.circle") : UIImage(systemName: "checkmark.circle")
        titleLabel.text = rule.title
    }
    
}
