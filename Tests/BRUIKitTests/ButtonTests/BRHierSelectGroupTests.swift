//
//  BRHierSelectGroupTests.swift
//  BRUIKit
//
//  Created by BR on 2025/9/9.
//

import Testing
import UIKit
@testable import BRUIKit


struct BRHierSelectGroupTests {
    
    
    @Test("主層選擇所有子層")
    @MainActor func parentSelectsAllChildren() {
        let group = BRHierSelectGroup<BRButton, BRButton>()
        let parent = BRButton()
        let child1 = BRButton()
        let child2 = BRButton()

        group.setParentButton(parent)
        group.addChildButton(child1)
        group.addChildButton(child2)
        
        group.didParentSelectionChanged = { parent in
            #expect(parent.buttonState == .on)
        }
        
        group.didChildSelectionChanged = { childs in
            childs.forEach { child in
                #expect(child.buttonState == .on)
            }
        }

        group.onParentTapped(parent)

        #expect(parent.buttonState == .on)
        #expect(child1.buttonState == .on)
        #expect(child2.buttonState == .on)
    }
    
    
    @Test("子層選擇更新主層")
    @MainActor func childSelectionUpdatesParent() {
        let group = BRHierSelectGroup<BRButton, BRButton>()
        let parent = BRButton()
        let child1 = BRButton()
        let child2 = BRButton()

        group.setParentButton(parent)
        group.addChildButton(child1)
        group.addChildButton(child2)

        group.onChildTapped(child1)
        #expect(parent.buttonState == .partial)

        group.onChildTapped(child2)
        #expect(parent.buttonState == .on)
    }
    
    
    @Test("梳狀層級選擇")
    @MainActor func multiLevelHierarchy() {
        let rootGroup = BRHierSelectGroup<BRButton, BRButton>()
        let middleGroup = BRHierSelectGroup<BRButton, BRButton>()
        
        let rootParent = BRButton()
        let middleParent = BRButton()

        let grandChild1 = BRButton()
        let grandChild2 = BRButton()
        
        rootGroup.setParentButton(rootParent)
        rootGroup.addChildButton(middleParent)
        rootGroup.addChildGroup(middleGroup)
        
        middleGroup.setParentButton(middleParent)
        middleGroup.addChildButton(grandChild1)
        middleGroup.addChildButton(grandChild2)

        rootGroup.onParentTapped(rootParent)

        #expect(rootParent.buttonState == .on)
        #expect(middleParent.buttonState == .on)
        #expect(grandChild1.buttonState == .on)
        #expect(grandChild2.buttonState == .on)

        middleGroup.onChildTapped(grandChild1)

        #expect(middleParent.buttonState == .partial)
        #expect(rootParent.buttonState == .partial)
    }
    
    
}
