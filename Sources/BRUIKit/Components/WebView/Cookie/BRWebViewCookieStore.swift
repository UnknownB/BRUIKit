//
//  BRWebViewCookieStore.swift
//  BRUIKit
//
//  Created by BR on 2025/10/8.
//

import Foundation
import WebKit


@MainActor
open class BRWebViewCookieStore {
    
    
    private let webView: WKWebView
    
    
    init(webView: WKWebView) {
        self.webView = webView
    }
    
    
    // MARK: - Cookie Operations
    
    
    /// 設置 Cookie
    @available(iOS 13.0.0, *)
    public func setCookie(_ cookie: HTTPCookie) async {
        await webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
    }
    
    
    /// 批次設置 Cookies
    @available(iOS 13.0.0, *)
    public func setCookies(_ cookies: [HTTPCookie]) async {
        for cookie in cookies {
            await setCookie(cookie)
        }
    }
    
    
    /// 取得所有 Cookies
    @available(iOS 13.0.0, *)
    public func allCookies() async -> [HTTPCookie] {
        await webView.configuration.websiteDataStore.httpCookieStore.allCookies()
    }
    
    
    /// 刪除 Cookie
    @available(iOS 13.0.0, *)
    public func deleteCookie(_ cookie: HTTPCookie) async {
        await webView.configuration.websiteDataStore.httpCookieStore.deleteCookie(cookie)
    }
    
    
    /// 批量刪除 Cookie
    @available(iOS 13.0.0, *)
    public func deleteCookies(_ cookies: [HTTPCookie]) async {
        for cookie in cookies {
            await deleteCookie(cookie)
        }
    }
    
    
}

