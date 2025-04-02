//
//  BRLayoutTests.swift
//  BRUIKit
//
//  Created by BR on 2025/3/30.
//

import Testing
@testable import BRUIKit

@Test("DSL 語法測試")
func core() async throws {
    
    let layout = BRLayout()
    
    let viewContent = UIViewController()
    let button = UIButton(type: .system)
    
    viewContent.view.addSubview(button)
    
    layout.activate {
        button.widthAnchor.constraint(equalToConstant: 80)
        button.heightAnchor.constraint(equalToConstant: 30)
    }

    viewContent.view.layoutIfNeeded()
    
    #expect(true)
}

