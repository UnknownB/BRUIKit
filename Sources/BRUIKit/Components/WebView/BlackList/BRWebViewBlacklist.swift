//
//  BRWebViewBlacklist.swift
//  BRUIKit
//
//  Created by BR on 2025/10/9.
//

import Foundation


open class BRWebViewBlacklist {
    
    
    /// URL 黑名單
    public var blacklist: Set<String> = []

    
    /// 添加到黑名單
    public func add(_ urlString: String) {
        blacklist.insert(urlString)
    }
    
    
    /// 批次添加到黑名單
    public func add(_ urlStrings: [String]) {
        blacklist.formUnion(urlStrings)
    }
    
    
    /// 從黑名單移除
    public func remove(_ urlString: String) {
        blacklist.remove(urlString)
    }
    
    
    /// 清空黑名單
    public func removeAll() {
        blacklist.removeAll()
    }
    
    
    /// 檢查 URL 是否在黑名單
    public func contains(_ url: URL) -> Bool {
        let urlString = url.absoluteString
        
        if blacklist.contains(urlString) {
            return true
        }
        
        if let host = url.host {
            for pattern in blacklist {
                if pattern.hasPrefix("*") {
                    let domain = pattern.dropFirst()
                    if host.hasSuffix(String(domain)) {
                        return true
                    }
                } else if host == pattern || host.hasSuffix(".\(pattern)") {
                    return true
                }
            }
        }
        
        for pattern in blacklist {
            if pattern.contains("*") {
                let regex = pattern
                    .replacingOccurrences(of: ".", with: "\\.")
                    .replacingOccurrences(of: "*", with: ".*")
                if urlString.range(of: regex, options: .regularExpression) != nil {
                    return true
                }
            }
        }
        
        return false
    }
}

