//
//  WKWebView+DSL.swift
//  BRUIKit
//
//  Created by BR on 2025/10/12.
//


import UIKit
import WebKit
import BRFoundation


@MainActor
public extension BRWrapper where Base: WKWebView {


    /// 設定使用者代理字串 (web 識別名稱)
    @discardableResult
    func customUserAgent(_ value: String?) -> Base {
        base.customUserAgent = value
        return base
    }

    
    /// 允許手勢滑動觸發向後、向前的頁面導覽，預設為 false
    @discardableResult
    func allowsBackForwardNavigationGestures(_ enabled: Bool) -> Base {
        base.allowsBackForwardNavigationGestures = enabled
        return base
    }

    
    /// 允許連結預覽畫面，預設為 true
    @discardableResult
    func allowsLinkPreview(_ enabled: Bool) -> Base {
        base.allowsLinkPreview = enabled
        return base
    }


}

