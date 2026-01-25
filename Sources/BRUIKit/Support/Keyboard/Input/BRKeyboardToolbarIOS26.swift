//
//  BRKeyboardToolbarIOS26.swift
//  BRUIKit
//
//  Created by BR on 2026/1/6.
//

import BRFoundation
import UIKit


/// 仿照 iOS 26+ 官方 App `Safari` 的 Toolbar
final public class BRKeyboardToolbarIOS26: NSObject, BRKeyboardToolbarProtocol {
    
    private let layout = BRLayout()
    private weak var prevView: UIResponder? = nil
    private weak var nextView: UIResponder? = nil
    
    
    public var onToolbarMaskChange: ((UIViewController) -> Void)? = nil

    
    // MARK: - UI 元件
    
    
    private let container = UIView()
    private let toolbar = UIToolbar()
    private let flexSpaceView = UIView()
    
    public let toolbarMaskView = UIView()
    public lazy var prevButton = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(onPrevTapped))
    public lazy var nextButton = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(onNextTapped))
    public lazy var doneButton = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(onDoneTapped))
    
    
    public var accessoryView: UIView {
        container
    }


    // MARK: - Init
    
    
    public override init() {
        super.init()
        setupUI()
        setupLayout()
    }
        
    
    // MARK: - UI
    
    
    func setupUI() {
        toolbar.sizeToFit()
        prevButton.image = UIImage(systemName: "chevron.up")
        nextButton.image = UIImage(systemName: "chevron.down")
        doneButton.image = UIImage(systemName: "checkmark")
        
        toolbarMaskView.br.cornerRadius(30, maskedConers: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }
    
    
    func setupLayout() {
        container.addSubview(toolbarMaskView)
        container.addSubview(toolbar)
        
        let padding: CGFloat = 7
        let maskHeight = UIScreen.main.bounds.height
        
        layout.activate {
            toolbarMaskView.br.left == container.br.left
            toolbarMaskView.br.right == container.br.right
            toolbarMaskView.br.top == container.br.top
            toolbarMaskView.br.bottom == container.br.bottom + maskHeight // 向下填滿鍵盤背景
            
            toolbar.br.left == container.br.left
            toolbar.br.right == container.br.right
            toolbar.br.top == container.br.top + padding
            
            container.br.height == toolbar.br.height + (padding * 2) // 讓 toolbar 與鍵盤有間隙
            
            (flexSpaceView.br.width == 1000).br.priority(.fittingSizeLevel) // 盡可能撐開使 UI 與系統一致
        }
        
        var items: [UIBarButtonItem] = []
        items.append(prevButton)
        items.append(nextButton)
        items.append(.init(customView: flexSpaceView)) // 使用 flexibleSpace 會與系統原生外觀不同
        items.append(doneButton)
        
        toolbar.setItems(items, animated: false)
    }
    
    
    // MARK: - Data

    
    public func bind(prev: UIResponder?, next: UIResponder?) {
        prevView = prev
        nextView = next
        
        prevButton.isEnabled = prevView != nil
        nextButton.isEnabled = nextView != nil
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
