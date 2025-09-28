//
//  BRButtonStateHelper.swift
//  BRUIKit
//
//  Created by BR on 2025/9/18.
//

import UIKit

class BRButtonStateHelper {
    
    var titles: [BRButtonState: String] = [:]
    var titleColors: [BRButtonState: UIColor] = [:]
    var images: [BRButtonState: UIImage] = [:]
    var backgrounds: [BRButtonState: UIImage] = [:]

    
    @MainActor
    func applyState(to button: BRButton) {
        let state = button.buttonState
        if let title = titles[state] ?? button.title(for: .normal) {
            button.setTitle(title, for: .normal)
        }
        
        if let titleColor = titleColors[state] ?? button.titleColor(for: .normal) {
            button.setTitleColor(titleColor, for: .normal)
        }
        
        if let image = images[state] ?? button.image(for: .normal) {
            button.setImage(image, for: .normal)
        }
        
        if let backgroundImage = backgrounds[state] ?? button.backgroundImage(for: .normal) {
            button.setBackgroundImage(backgroundImage, for: .normal)
        }
    }

}
