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
    
    
    /// 上一個被選中的按鈕
    public private(set) var lastSelectedButton: Button?
    
    
    /// 目前被選中的按鈕索引值
    public var selectedIndex: Int? {
        guard let selectedButton else { return nil }
        return buttons.firstIndex(of: selectedButton)
    }
    
    
    /// 上一個被選中的按鈕索引值
    public var lastSelectedIndex: Int? {
        guard let lastSelectedButton else { return nil }
        return buttons.firstIndex(of: lastSelectedButton)
    }
    
    
    /// 是否允許取消選取（再次點擊已選中按鈕時）
    public var allowsDeselection: Bool = false
    
    
    /// 已更動被選中的按鈕
    public var didChangeSelection: ((Button?) -> Void)?
    
    
    public init() {}
    
    
    /// 添加按鈕
    @MainActor
    public func addButton(_ button: Button) {
        buttons.append(button)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    
    /// 移除按鈕
    @MainActor
    public func removeButton(_ button: Button) {
        buttons = buttons.br.removingFirstOccurrence(of: button)
        if selectedButton == button {
            selectedButton = nil
            didChangeSelection?(nil)
        }
    }
    
    
    /// 觸發按鈕事件
    @MainActor
    @objc func buttonTapped(_ sender: UIButton) {
        guard let tapped = sender as? Button else { return }
        lastSelectedButton = selectedButton
        
        if tapped == selectedButton {
            if allowsDeselection {
                tapped.isSelected = false
                selectedButton = nil
                didChangeSelection?(nil)
            }
            return
        }
        
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
