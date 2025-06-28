//
//  UIImageView+DSL.swift
//  BRUIKit
//
//  Created by BR on 2025/6/19.
//

import UIKit
import BRFoundation


public extension BRWrapper where Base: UIImageView {

    
    // MARK: - 圖片設定
    

    @MainActor
    @discardableResult
    func image(_ image: UIImage?) -> Base {
        base.image = image
        return base
    }

    
    @MainActor
    @discardableResult
    func image(named name: String) -> Base {
        base.image = UIImage(named: name)
        return base
    }

    
    @MainActor
    @discardableResult
    func highlightedImage(_ image: UIImage?) -> Base {
        base.highlightedImage = image
        return base
    }
    
    
}
