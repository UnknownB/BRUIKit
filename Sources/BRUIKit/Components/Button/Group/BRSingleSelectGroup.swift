//
//  BRSingleSelectGroup.swift
//  BRUIKit
//
//  Created by BR on 2025/9/9.
//

import UIKit


/// 單選群組
public class BRSingleSelectGroup<Button: UIButton> {
    
    
    /// 按鈕清單
    public private(set) var buttons: [Button] = []
    
    
    /// 目前被選中的按鈕
    public private(set) var selectedButton: Button?
    
    
    /// 當選中的按鈕改變時會呼叫
    public var didChangeSelection: ((Button?) -> Void)?
    
    
    public init() {}
    
    
    /// 添加按鈕
    @MainActor
    public func addButton(_ button: Button) {
        buttons.append(button)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    
    /// 觸發按鈕事件
    @MainActor
    @objc func buttonTapped(_ sender: UIButton) {
        guard let tapped = sender as? Button else { return }
        
        for button in buttons {
            let isSelected = (button == tapped)
            button.isSelected = isSelected
            if isSelected {
                selectedButton = button
            }
        }
        
        didChangeSelection?(selectedButton)
    }
    
    
    /// 指定某個按鈕為選中
    @MainActor
    public func selectButton(_ button: Button) {
        guard buttons.contains(button) else { return }
        buttonTapped(button)
    }
    
    
}
