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
    private var config: BRKeyboardToolbarConfig? = nil
    
    
    public var onToolbarMaskChange: ((UIViewController) -> Void)? = nil
    
    
    // MARK: - UI 元件
    

    private let toolbar = UIToolbar()
    private let listBar = BRListBar()
    
    public lazy var prevButton = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(onPrevTapped))
    public lazy var nextButton = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(onNextTapped))
    public lazy var doneButton = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(onDoneTapped))
    
    public var toolbarMaskView: UIView {
        toolbar
    }
    
    public var accessoryView: UIView {
        toolbar
    }
    
    
    // MARK: - Init
    
    
    public override init() {
        super.init()
        setupUI()
    }
        
    
    // MARK: - UI
    
    
    private func setupUI() {
        toolbar.sizeToFit()
        prevButton.image = UIImage(systemName: "chevron.up")
        nextButton.image = UIImage(systemName: "chevron.down")
        doneButton.image = UIImage(systemName: "checkmark")
        
        listBar.scrollView.br.pagingEnabled(true)
    }
        
    
    // MARK: - Data
    

    public func bind(prev: UIResponder?, next: UIResponder?, config: BRKeyboardToolbarConfig?) {
        prevView = prev
        nextView = next
        self.config = config

        prevButton.isEnabled = prevView != nil
        nextButton.isEnabled = nextView != nil
        
        listBar.stackView.br.removeAllArranged()
        
        let hiddenPrevNext = config?.hiddenPrevNext ?? (BRKeyboard.hiddenPrevNextWhenDisabled ? (!prevButton.isEnabled && !nextButton.isEnabled) : false)

        var items: [UIBarButtonItem] = []
        
        if !hiddenPrevNext {
            items.append(prevButton)
            items.append(nextButton)
        }

        let listBarItem = UIBarButtonItem(customView: listBar)
        listBarItem.width = 3000
        items.append(listBarItem)
        
        items.append(doneButton)
        
        config?.additionalItems.forEach { listBar.br.addArranged($0) }
        
        toolbar.setItems(items, animated: false)
    }
    
    
    public func updateToolbarMaskView(with activateViewController: UIViewController) {
        onToolbarMaskChange?(activateViewController)
    }
    
    
    // MARK: - Event
    
    
    @objc private func onPrevTapped() {
        if let onPrev = config?.onPrev {
            onPrev(prevView)
        } else {
            prevView?.becomeFirstResponder()
        }
    }
    
    
    @objc private func onNextTapped() {
        if let onNext = config?.onNext {
            onNext(nextView)
        } else {
            nextView?.becomeFirstResponder()
        }
    }
    
    
    @objc private func onDoneTapped() {
        if let onDone = config?.onDone {
            onDone()
        } else {
            BRKeyboard.dismissKeyboard()
        }
    }

    
}
