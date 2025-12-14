//
//  BRTextFieldStateHelper.swift
//  BRUIKit
//
//  Created by BR on 2025/12/9.
//

import UIKit

class BRTextFieldStateHelper {
    
    var borderWidths: [BRTextFieldState: CGFloat] = [:]
    var borderColors: [BRTextFieldState: UIColor] = [:]
    var backgroundColors: [BRTextFieldState: UIColor] = [:]

    
    @MainActor
    func applyState(to textField: BRTextField) {
        let state = textField.fieldState
        
        if let borderWidth = borderWidths[state] {
            textField.layer.borderWidth = borderWidth
        }
        
        if let borderColor = borderColors[state] ?? textField.layer.borderColor as? UIColor {
            textField.layer.borderColor = borderColor.cgColor
        }
        
        if let backgroundColor = backgroundColors[state] ?? textField.backgroundColor {
            textField.backgroundColor = backgroundColor
        }
    }

}
