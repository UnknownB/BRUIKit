//
//  UIImageView+Data.swift
//  BRUIKit
//
//  Created by BR on 2026/5/6.
//

import UIKit
import BRFoundation


public extension BRWrapper where Base: UIImageView {

    
    // MARK: - 載入圖片
    

    /// 從 URL 載入圖片，當此 URL 曾經載入過會自動記錄在 cached
    ///
    /// ## updateCache
    ///     設為 true 時會強制覆蓋原始 cached 資料，預設為 false
    /// ## defaultImage
    ///     預設的圖片
    /// ## failedImage
    ///     當 URL 載入失敗時顯示
    @MainActor
    @discardableResult
    func load(_ url: URL?, updateCache: Bool = false, defaultImage: UIImage? = nil, failedImage: UIImage? = nil) -> Base {
        BRTaskStorage.task(for: base)?.cancel()
        
        if base.image == nil {
            base.image = defaultImage
        }
        
        guard let url = url else {
            base.image = failedImage
            return base
        }
        
        let newTask = Task {
            do {
                let data = try await url.br.cachedData(updateCache: updateCache)
                
                if Task.isCancelled { return }
                
                await MainActor.run {
                    base.image = UIImage.br.load(data)
                }
            } catch {
                if !Task.isCancelled {
                    base.image = failedImage
                }
            }
        }
        
        BRTaskStorage.store(newTask, for: base)
        
        return base
    }
    
    
}
