//
//  BRMultiSelectGroupTests.swift
//  BRUIKit
//
//  Created by BR on 2025/9/9.
//

import Testing
import UIKit
@testable import BRUIKit


struct BRMultiSelectGroupTests {
    
    
    @Test("多選")
    @MainActor func multipleSelections() {
        let group = BRMultiSelectGroup<UIButton>()
        let buttonA = UIButton()
        let buttonB = UIButton()
        let buttonC = UIButton()
        
        group.addButton(buttonA)
        group.addButton(buttonB)
        group.addButton(buttonC)
        
        group.onButtonTapped(buttonA)
        group.onButtonTapped(buttonB)
        
        #expect(group.selectedButtons.contains(buttonA))
        #expect(group.selectedButtons.contains(buttonB))
        #expect(group.selectedButtons.count == 2)
    }
    
    
    @Test("設定被選擇的按鈕")
    @MainActor func setSelections() {
        let group = BRMultiSelectGroup<UIButton>()
        let buttonA = UIButton()
        let buttonB = UIButton()
        let buttonC = UIButton()
        
        group.addButton(buttonA)
        group.addButton(buttonB)
        group.addButton(buttonC)
        
        group.didChangeSelection = { buttons in
            #expect(buttons.contains(buttonA))
            #expect(buttons.contains(buttonB))
        }
        
        group.selectButtons([buttonA, buttonB])
        
        #expect(group.selectedButtons.contains(buttonA))
        #expect(group.selectedButtons.contains(buttonB))
        #expect(group.selectedButtons.count == 2)
    }
    
    
}
