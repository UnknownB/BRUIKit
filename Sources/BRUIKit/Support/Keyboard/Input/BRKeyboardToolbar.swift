//
//  BRKeyboardToolbar.swift
//  BRUIKit
//
//  Created by BR on 2026/1/6.
//

import BRFoundation
import UIKit


final class BRKeyboardToolbar: UIToolbar {
    
    lazy var prevButton = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(onPrevTapped))
    lazy var nextButton = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(onNextTapped))
    lazy var doneButton = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(onDoneTapped))
    
    weak var prevView: UIResponder? = nil
    weak var nextView: UIResponder? = nil
    
    // MARK: - Init
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sizeToFit()
        prevButton.image = UIImage(systemName: "chevron.up")
        nextButton.image = UIImage(systemName: "chevron.down")
        doneButton.image = UIImage(systemName: "checkmark")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func bind(prev: UIResponder?, next: UIResponder?) {
        prevView = prev
        nextView = next
        
        var items: [UIBarButtonItem] = []
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        if prevView != nil || nextView != nil {
            items.append(prevButton)
            items.append(nextButton)

            prevButton.isEnabled = prevView != nil
            nextButton.isEnabled = nextView != nil
        }

        items.append(flex)
        items.append(doneButton)
        
        self.setItems(items, animated: false)
    }
    
    
    // MARK: - Event
    
    
    @objc private func onPrevTapped() {
        prevView?.becomeFirstResponder()
    }
    
    
    @objc private func onNextTapped() {
        nextView?.becomeFirstResponder()
    }
    
    
    @objc private func onDoneTapped() {
        BRKeyboard.dismissKeyboard()
    }

    
}
