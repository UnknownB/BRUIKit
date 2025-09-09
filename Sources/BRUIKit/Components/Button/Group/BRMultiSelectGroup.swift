//
//  BRMultiSelectGroup.swift
//  BRUIKit
//
//  Created by BR on 2025/9/9.
//

import UIKit


/// 多選群組
public class BRMultiSelectGroup<Button: UIButton> {
    
    
    /// 按鈕清單
    public private(set) var buttons: [Button] = []

    
    /// 目前所有被選中的按鈕
    public private(set) var selectedButtons: [Button] = []
    
    
    /// 當選中的按鈕集合改變時會呼叫
    public var didChangeSelection: (([Button]) -> Void)?
    
    
    public init() {}
    
    
    @MainActor
    public func addButton(_ button: Button) {
        buttons.append(button)
        button.addTarget(self, action: #selector(onButtonTapped(_:)), for: .touchUpInside)
    }
    
    
    @MainActor
    @objc func onButtonTapped(_ sender: UIControl) {
        guard let tapped = sender as? Button else {
            return
        }
        tapped.isSelected.toggle()
        
        selectedButtons = buttons.filter { $0.isSelected }
        didChangeSelection?(selectedButtons)
    }
    
    
    /// 指定某些按鈕為選中
    @MainActor
    public func selectButtons(_ buttonsToSelect: [Button]) {
        for button in buttons {
            button.isSelected = buttonsToSelect.contains(button)
        }
        selectedButtons = buttons.filter { $0.isSelected }
        didChangeSelection?(selectedButtons)
    }
    
    
}
