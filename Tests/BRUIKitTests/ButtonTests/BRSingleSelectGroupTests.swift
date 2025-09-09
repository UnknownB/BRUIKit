//
//  BRSingleSelectGroupTests.swift
//  BRUIKit
//
//  Created by BR on 2025/9/9.
//

import Testing
import UIKit
@testable import BRUIKit


struct BRSingleSelectGroupTests {
    
    
    @Test("模擬點擊事件")
    @MainActor func singleSelections() {
        let group = BRSingleSelectGroup()
        let buttonA = UIButton()
        let buttonB = UIButton()
        let buttonC = UIButton()
        
        group.addButton(buttonA)
        group.addButton(buttonB)
        group.addButton(buttonC)
                
        group.buttonTapped(buttonA)
        group.buttonTapped(buttonB)
        
        #expect(group.selectedButton == buttonB)
    }
    
    
    @Test("指定選中按鈕")
    @MainActor func setSelections() {
        let group = BRSingleSelectGroup<UIButton>()
        let buttonA = UIButton()
        let buttonB = UIButton()
        let buttonC = UIButton()
        
        group.addButton(buttonA)
        group.addButton(buttonB)
        group.addButton(buttonC)
        
        group.didChangeSelection = { button in
            #expect(button == buttonB)
        }
        
        group.selectButton(buttonB)
        
        #expect(group.selectedButton == buttonB)
    }

    
}
