//
//  BRMediaContent.swift
//  BRUIKit
//
//  Created by BR on 2025/11/3.
//

import UIKit


/// 封裝 Media (圖片、影片) 顯示資料
open class BRMediaContent {
    
    public enum Source {
        case image
        case data
        case url
        case null
    }
    
    
    open var image: UIImage?
    open var data: Data?
    open var url: URL?
    
    
    open var source: Source {
        if data != nil { return .data }
        if url != nil { return .url }
        if image != nil { return .image }
        return .null
    }
    
    
    // MARK: - Init
    
    
    public init(image: UIImage? = nil, data: Data? = nil, url: URL? = nil) {
        self.image = image
        self.data = data
        self.url = url
    }
    
    
    public init(from mediaContent: BRMediaContent) {
        self.image = mediaContent.image
        self.data = mediaContent.data
        self.url = mediaContent.url
    }
    
    
    open var value: Any? {
        data ?? image ?? url ?? nil
    }
    
    
    @discardableResult
    open func image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }


    @discardableResult
    open func data(_ data: Data?) -> Self {
        self.data = data
        return self
    }
    
    
    @discardableResult
    open func url(_ url: URL?) -> Self {
        self.url = url
        return self
    }
    
    
}
