//
//  BRWebViewJSBridge.swift
//  BRUIKit
//
//  Created by BR on 2025/10/8.
//

import Foundation
import WebKit


@MainActor
open class BRWebViewJSBridge: NSObject, WKScriptMessageHandler {
    
    
    private let webView: WKWebView
    private var messageHandlers: [String: (WKScriptMessage) -> Void] = [:]
    
    
    public init(webView: WKWebView, name: String) {
        self.webView = webView
    }
    
    
    @MainActor
    deinit {
        removeAllHandlers()
    }
    
    
    // MARK: - JavaScript Execution
    
    
    /// 執行 JavaScript
    @available(iOS 13.0.0, *)
    public func evaluateJavaScript(_ script: String) async throws -> Any? {
        try await webView.evaluateJavaScript(script)
    }
    
    
    /// 執行 JavaScript
    public func evaluateJavaScript(_ script: String, completion: ((Result<Any, Error>) -> Void)? = nil) {
        webView.evaluateJavaScript(script) { result, error in
            if let error = error {
                completion?(.failure(error))
            } else if let result = result {
                completion?(.success(result))
            }
        }
    }
    
    
    // MARK: - 接收訊息
    
    
    /// 註冊 JavaScript Message Handler
    public func addHandler(name: String, handler: @escaping (WKScriptMessage) -> Void) {
        messageHandlers[name] = handler
        webView.configuration.userContentController.add(self, name: name)
    }
    
    
    /// 移除 JavaScript Message Handler
    public func removeHandler(name: String) {
        messageHandlers.removeValue(forKey: name)
        webView.configuration.userContentController.removeScriptMessageHandler(forName: name)
    }
    
    
    /// 移除所有 JavaScript Message Handlers
    public func removeAllHandlers() {
        for name in messageHandlers.keys {
            webView.configuration.userContentController.removeScriptMessageHandler(forName: name)
        }
        messageHandlers.removeAll()
    }
    
    
    /// 接受 web 透過 javaScript 傳來的訊息
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        messageHandlers[message.name]?(message)
    }
    
    
    // MARK: - UserScript
    
    
    /// 添加 javaScript 到網頁中
    ///
    /// - injectionTime
    ///     - .atDocumentStart
    ///         - 在 DOM 建立前注入 (攔截或覆寫)
    ///     - .atDocumentEnd
    ///         - 在 DOM 建立後注入 (操作畫面、CSS)
    /// - forMainFrameOnly
    ///     - 是否只注入主頁框架 (不包含 iframe)
    ///
    public func addUserScript(_ script: String, injectionTime: WKUserScriptInjectionTime = .atDocumentEnd, forMainFrameOnly: Bool = true) {
        let userScript = WKUserScript(source: script, injectionTime: injectionTime, forMainFrameOnly: forMainFrameOnly)
        webView.configuration.userContentController.addUserScript(userScript)
    }
    
    
    /// 移除所有的 UserScripts
    public func removeAllUserScripts() {
        webView.configuration.userContentController.removeAllUserScripts()
    }

    
}
