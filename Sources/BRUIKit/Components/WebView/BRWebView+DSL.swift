//
//  BRWebView+DSL.swift
//  BRUIKit
//
//  Created by BR on 2025/10/7.
//

import UIKit
import WebKit
import BRFoundation


@available(iOS 13.0, *)
@MainActor
public extension BRWrapper where Base: BRWebView {
    
        
    /// 添加到黑名單
    @discardableResult
    func addBlacklistedURL(_ urlString: String) -> Base {
        base.adapter.blacklist.add(urlString)
        return base
    }
    
    
    /// 批次添加到黑名單
    @discardableResult
    func addBlacklistedURLs(_ urlStrings: [String]) -> Base {
        base.adapter.blacklist.add(urlStrings)
        return base
    }
    
    
    /// 從黑名單移除
    @discardableResult
    func removeBlacklistedURL(_ urlString: String) -> Base {
        base.adapter.blacklist.remove(urlString)
        return base
    }
    
    
    /// 清空黑名單
    @discardableResult
    func removeAllBlacklistedURLs() -> Base {
        base.adapter.blacklist.removeAll()
        return base
    }

    
}
