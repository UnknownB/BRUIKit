//
//  UIAlertController+DSL.swift
//  BRUIKit
//
//  Created by BR on 2025/10/9.
//

import BRFoundation
import UIKit


@MainActor
public extension BRWrapper where Base: UIAlertController {
    
    
    static func style(_ preferredStyle: UIAlertController.Style) -> UIAlertController {
        UIAlertController(title: nil, message: nil, preferredStyle: preferredStyle)
    }
    
    
    @discardableResult
    func title(_ title: String) -> Base {
        base.title = title
        return base
    }
    
    
    @discardableResult
    func message(_ message: String) -> Base {
        base.message = message
        return base
    }
    
    
    @discardableResult
    func addAction(_ action: UIAlertAction) -> Base {
        base.addAction(action)
        return base
    }
    
    
    @discardableResult
    func addActions(_ actions: [UIAlertAction]) -> Base {
        actions.forEach(base.addAction)
        return base
    }
    
    
    @discardableResult
    func addDoneAction(title: String = "done".br.localized, style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> Void)? = nil) -> Base {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        base.addAction(action)
        return base
    }
    
    
    @discardableResult
    func addCancelAction(title: String = "cancel".br.localized, style: UIAlertAction.Style = .cancel, handler: ((UIAlertAction) -> Void)? = nil) -> Base {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        base.addAction(action)
        return base
    }
    
    
    @discardableResult
    func addTextField(configurationHandler: ((UITextField) -> Void)? = nil) -> Base {
        base.addTextField(configurationHandler: configurationHandler)
        return base
    }


}
