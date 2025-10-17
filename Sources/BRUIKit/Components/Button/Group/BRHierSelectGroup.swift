//
//  BRHierSelectGroup.swift
//  BRUIKit
//
//  Created by BR on 2025/9/9.
//

import UIKit
import Combine


/// 主從群組
public class BRHierSelectGroup<Parent: BRButton, Child: BRButton> {
    
    
    /// 父群組（弱引用，避免循環）
    public weak var parentGroup: BRHierSelectGroup<Parent, Child>?
    
    
    /// 子群組
    public private(set) var childGroups: [BRHierSelectGroup<Parent, Child>] = []
    
    
    /// 主層按鈕
    public private(set) var parentButton: Parent?
    
    
    /// 子層按鈕
    public private(set) var childButtons: [Child] = []
    
    
    /// 當主按鈕狀態改變時
    public var didParentSelectionChanged: ((Parent) -> Void)?
    
    
    /// 當子按鈕狀態改變時
    public var didChildSelectionChanged: (([Child]) -> Void)?
    
    
    public init() {}
    
    
    /// 設定父層按鈕
    @MainActor
    public func setParentButton(_ button: Parent) {
        parentButton = button
        button.addTarget(self, action: #selector(onParentTapped(_:)), for: .touchUpInside)
    }
    
    
    /// 添加子層按鈕
    @MainActor
    public func addChildButton(_ button: Child) {
        childButtons.append(button)
        button.addTarget(self, action: #selector(onChildTapped(_:)), for: .touchUpInside)
    }
    
    
    /// 移除子層按鈕
    @MainActor
    public func removeChildButton(_ button: Child) {
        childButtons = childButtons.br.removingFirstOccurrence(of: button)
        setParentState(newParentState(), changeChildren: false)
    }

    
    /// 添加子Group
    @MainActor
    public func addChildGroup(_ group: BRHierSelectGroup<Parent, Child>) {
        childGroups.append(group)
        group.parentGroup = self
    }
    
    
    /// 觸發父層按鈕事件
    @MainActor
    @objc public func onParentTapped(_ sender: UIControl) {
        guard let parent = sender as? Parent else { return }
        
        switch parent.buttonState {
        case .off, .partial:
            setParentState(.on)
        case .on:
            setParentState(.off)
        }
    }
    
    
    /// 設定父層按鈕狀態
    @MainActor
    public func setParentState(_ state: BRButtonState, changeChildren: Bool = true) {
        guard let parent = parentButton else {
            return
        }
        parent.buttonState = state
        didParentSelectionChanged?(parent)
        
        if changeChildren {
            childButtons.forEach { $0.buttonState = state }
            didChildSelectionChanged?(childButtons.filter { $0.buttonState == .on })
            childGroups.forEach { $0.setParentState(state, changeChildren: true) }
        }
    }

    
    /// 觸發子層按鈕事件
    @MainActor
    @objc public func onChildTapped(_ sender: UIControl) {
        guard let tapped = sender as? Child else { return }
        let newState: BRButtonState = tapped.buttonState == .on ? .off : .on
        setChildState(button: tapped, state: newState)
    }
    
    
    /// 設定子層按鈕狀態
    @MainActor
    public func setChildState(button child: Child, state: BRButtonState, changeParent: Bool = true) {
        child.buttonState = state
        didChildSelectionChanged?(childButtons.filter { $0.buttonState == .on })

        if changeParent {
            let parentState = newParentState()
            setParentState(parentState, changeChildren: false)
            
            var parentGroup = parentGroup
            while parentGroup != nil {
                parentGroup?.setParentState(parentState, changeChildren: false)
                parentGroup = parentGroup?.parentGroup
            }
        }
    }
    
    
    @MainActor
    private func newParentState() -> BRButtonState {
        let allSelected = childButtons.allSatisfy { $0.buttonState == .on }
        let noneSelected = childButtons.allSatisfy { $0.buttonState == .off }
        let parentState: BRButtonState = allSelected ? .on : noneSelected ? .off : .partial
        return parentState
    }

    
}
