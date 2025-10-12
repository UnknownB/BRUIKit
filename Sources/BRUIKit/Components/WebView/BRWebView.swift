//
//  BRWebView.swift
//  BRUIKit
//
//  Created by BR on 2025/10/7.
//


import UIKit
import WebKit
import BRFoundation


@available(iOS 13.0, *)
open class BRWebView: WKWebView {
    
    
    private(set) public var adapter: BRWebViewAdapter!
    
    
    // MARK: - Init
    
    
    public init(configuration: WKWebViewConfiguration = WKWebViewConfiguration(), appName: String? = nil) {
        configuration.applicationNameForUserAgent = appName
        super.init(frame: .zero, configuration: configuration)
        self.adapter = BRWebViewAdapter(webView: self)
    }
    
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Loading
    
    
    @discardableResult
    public func load(url: URL) -> WKNavigation? {
        self.load(URLRequest(url: url))
    }
    
    
}

