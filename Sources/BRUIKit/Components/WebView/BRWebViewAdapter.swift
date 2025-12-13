//
//  BRWebViewAdapter.swift
//  BRUIKit
//
//  Created by BR on 2025/10/8.
//

import BRFoundation
import WebKit
import Combine


@available(iOS 13.0, *)
open class BRWebViewAdapter: NSObject, ObservableObject, WKUIDelegate, WKNavigationDelegate {
    
    public struct NewWebViewContext {
        public let parent: WKWebView
        public let child: WKWebView
        public let request: URLRequest
    }
    
    public let webView: WKWebView
    public let jsBridge: BRWebViewJSBridge
    public let cookieStore: BRWebViewCookieStore
    public let blacklist: BRWebViewBlacklist
    
    
    /// 開始載入
    public var onDidStart: ((URL?) -> Void)?

    
    /// 載入中
    public var onDidCommit: ((URL?) -> Void)?

    
    /// 載入完成
    public var onDidFinish: ((URL?) -> Void)?
    

    /// 載入失敗
    public var onDidFail: ((Error) -> Void)?
    
    
    /// 開啟新的分頁
    public var onOpenNewTab: ((URL) -> Void)?
    
    
    /// 開啟新的視窗頁面
    public var onCreateNewWebView: ((NewWebViewContext) -> Void)?
    
    
    /// 關閉新的視窗頁面
    public var onCloseNewWebView: ((WKWebView) -> Void)?
    
    
    /// JavaScript 提示視窗
    public var onJSAlert: ((BRJSAlertData, @escaping () -> Void) -> Void)?
    
    
    /// JavaScript 確認視窗
    public var onJSConfirmAlert: ((BRJSConfirmData, @escaping (Bool) -> Void) -> Void)?
    
    
    /// JavaScript 輸入視窗
    public var onJSTextFeildAlert: ((BRJSPromptData, @escaping (String?) -> Void) -> Void)?
    
    
    /// 網頁標題
    @Published public var webTitle: String? = nil
    
    
    /// 目前載入的 URL
    @Published public var currentURL: URL? = nil
    
    
    /// 即將載入的 URL
    @Published public var loadingURL: URL? = nil
    
    
    /// 網頁是否正在載入 (從 Navigation Delegate 推導)
    @Published public var isLoading: Bool = false
    
    
    /// 載入進度 (0.0 到 1.0)
    @Published public var progress: Double = 0.0
    
    
    /// 是否可以返回上一頁
    @Published public var canGoBack: Bool = false
    
    
    /// 是否可以前進下一頁
    @Published public var canGoForward: Bool = false
    
    
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Init
    
    
    init(webView: WKWebView) {
        self.webView = webView
        self.jsBridge = BRWebViewJSBridge(webView: webView, name: "")
        self.cookieStore = BRWebViewCookieStore(webView: webView)
        self.blacklist = BRWebViewBlacklist()
        super.init( )
        webView.uiDelegate = self
        webView.navigationDelegate = self
        setupCombineBindings()
    }
    
    
    private func setupCombineBindings() {
        webView.publisher(for: \.title)
            .assign(to: \.webTitle, on: self)
            .store(in: &cancellables)
        
        webView.publisher(for: \.url)
            .assign(to: \.currentURL, on: self)
            .store(in: &cancellables)
        
        webView.publisher(for: \.url, options: [.new])
            .assign(to: \.loadingURL, on: self)
            .store(in: &cancellables)
        
        webView.publisher(for: \.isLoading)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)

        webView.publisher(for: \.estimatedProgress)
            .assign(to: \.progress, on: self)
            .store(in: &cancellables)

        webView.publisher(for: \.canGoBack)
            .assign(to: \.canGoBack, on: self)
            .store(in: &cancellables)

        webView.publisher(for: \.canGoForward)
            .assign(to: \.canGoForward, on: self)
            .store(in: &cancellables)
    }
    
    
    // MARK: - WKNavigationDelegate
    
    
    /// 開始載入網頁
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        onDidStart?(webView.url)
    }
    
    
    /// 收到內容
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        onDidCommit?(webView.url)
    }
    
    
    /// 載入完成
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        onDidFinish?(webView.url)
    }
    
    
    /// 收到內容後載入失敗
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        onDidFail?(error)
    }
    
    
    /// 未收到內容就載入失敗
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        onDidFail?(error)
    }
    
    
    /// 開啟 URL 事件處理
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        guard let url = navigationAction.request.url else {
            return .cancel
        }
        
        if blacklist.contains(url) {
            return .cancel
        }
        
        // 開新頁面
        if navigationAction.targetFrame == nil {
            if let onOpenNewTab = onOpenNewTab {
                onOpenNewTab(url)
            } else {
                webView.load(navigationAction.request)
            }
            return .cancel
        }
        return .allow
    }
    
    
    /// redirect (重定向) 跳轉事件處理
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse) async -> WKNavigationResponsePolicy {
        guard let url = navigationResponse.response.url else {
            return .cancel
        }
        let isBlack = blacklist.contains(url)
        return isBlack ? .cancel : .allow
    }
        
    
    // MARK: - WKUIDelegate
    
    
    /// 支援 window.open 或 target="_blank"
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        guard navigationAction.request.url != nil else {
            #BRLog(.library, .info, "Invalid window.open detected. request: \(navigationAction.request)")
            return nil
        }
        
        if let onCreateNewWebView = onCreateNewWebView {
            let newWebView = WKWebView(frame: .zero, configuration: configuration)
            newWebView.navigationDelegate = self
            newWebView.uiDelegate = self
            let newWebViewContext = NewWebViewContext(parent: webView, child: newWebView, request: navigationAction.request)
            onCreateNewWebView(newWebViewContext)
            return newWebView
        } else {
            webView.load(navigationAction.request)
            return nil
        }
    }
    
    
    /// 關閉新視窗頁面
    public func webViewDidClose(_ webView: WKWebView) {
        onCloseNewWebView?(webView)
    }

    
    /// JavaScript 提示視窗
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        guard let onJSAlert else {
            UIAlertController(title: nil, message: message, preferredStyle: .alert)
                .br.addDoneAction()
                .br.show(in: webView.br.viewController()!, completion: completionHandler)
            return
        }
        onJSAlert(BRJSAlertData(message: message, frame: frame), completionHandler)
    }
    
    
    /// JavaScript 確認視窗
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        guard let onJSConfirmAlert else {
            UIAlertController(title: nil, message: message, preferredStyle: .alert)
                .br.addCancelAction { _ in
                    completionHandler(false)
                }
                .br.addDoneAction { _ in
                    completionHandler(true)
                }
                .br.show(in: webView.br.viewController()!)
            return
        }
        onJSConfirmAlert(BRJSConfirmData(message: message, frame: frame), completionHandler)
    }
    
    
    /// JavaScript 輸入視窗
    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        guard let onJSTextFeildAlert else {
            let alert = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)
            alert
                .br.addTextField { textField in
                    textField.text = defaultText
                }
                .br.addCancelAction { _ in
                    completionHandler(nil)
                }
                .br.addDoneAction { _ in
                    completionHandler(alert.textFields?.first?.text)
                }
                .br.show(in: webView.br.viewController()!)
            return
        }
        onJSTextFeildAlert(BRJSPromptData(message: prompt, defaultText: defaultText, frame: frame), completionHandler)
    }

    
}
