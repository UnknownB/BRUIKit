//
//  NSTextAlignment+Transform.swift
//  BRUIKit
//
//  Created by BR on 2026/2/23.
//

import BRFoundation
import UIKit


public extension BRWrapper where Base == NSTextAlignment {
    
    
    @available(iOS 14.0, *)
    var listTextAlignment: UIListContentConfiguration.TextProperties.TextAlignment {
        switch base {
        case .center:
            return .center
        case .justified:
            return .justified
        case .natural:
            return .natural
        default:
            return .natural
        }
    }
    
    
}
