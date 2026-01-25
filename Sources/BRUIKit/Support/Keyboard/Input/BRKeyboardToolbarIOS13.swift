//
//  BRKeyboardToolbarIOS13.swift
//  BRUIKit
//
//  Created by BR on 2026/1/16.
//

import BRFoundation
import UIKit


/// 仿照 iOS 13+ 官方 App `Safari` 的 Toolbar
final public class BRKeyboardToolbarIOS13: NSObject, BRKeyboardToolbarProtocol {
    
    private let layout = BRLayout()
    
    private var prevView: UIResponder? = nil
    private var nextView: UIResponder? = nil
    
    
    public var onToolbarMaskChange: ((UIViewController) -> Void)? = nil
    
    
    // MARK: - UI 元件
    

    private let toolbar = UIToolbar()
    
    public let toolbarMaskView = UIView()
    public lazy var prevButton = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(onPrevTapped))
    public lazy var nextButton = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(onNextTapped))
    public lazy var doneButton = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(onDoneTapped))
    
    
    public var accessoryView: UIView {
        toolbarMaskView
    }
    
    
    // MARK: - Init
    
    
    public override init() {
        super.init()
        setupUI()
        setupLayout()
    }
        
    
    // MARK: - UI
    
    
    private func setupUI() {
        toolbar.sizeToFit()
        prevButton.image = UIImage(systemName: "chevron.up")
        nextButton.image = UIImage(systemName: "chevron.down")
        doneButton.image = UIImage(systemName: "checkmark")
    }
    
    
    private func setupLayout() {
        toolbarMaskView.addSubview(toolbar)
        
        layout.activate {
            toolbar.br.left == toolbarMaskView.br.left
            toolbar.br.right == toolbarMaskView.br.right
            toolbar.br.top == toolbarMaskView.br.top
            
            toolbarMaskView.br.height == toolbar.br.height
        }
    }
    
    
    // MARK: - Data
    

    public func bind(prev: UIResponder?, next: UIResponder?) {
        prevView = prev
        nextView = next
        
        var items: [UIBarButtonItem] = []
        
        if prevView != nil || nextView != nil {
            items.append(prevButton)
            items.append(nextButton)

            prevButton.isEnabled = prevView != nil
            nextButton.isEnabled = nextView != nil
        }

        items.append(.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        items.append(doneButton)
        
        toolbar.setItems(items, animated: false)
    }
    
    
    public func updateToolbarMaskView(with activateViewController: UIViewController) {
        onToolbarMaskChange?(activateViewController)
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
