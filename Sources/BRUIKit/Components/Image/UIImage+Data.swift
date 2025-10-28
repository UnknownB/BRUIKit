//
//  UIImage+Data.swift
//  BRUIKit
//
//  Created by BR on 2025/10/28.
//

import UIKit
import BRFoundation


public extension BRWrapper where Base: UIImage {
    
    
    // MARK: - 檔案大小
    
    
    /// 圖片的原始資料大小（以位元組計）
    var fileSize: Int {
        let data = base.br.toData()
        return data?.count ?? 0
    }
    
    
    /// 圖片大小（以 KB 為單位）
    var fileSizeKB: Double {
        Double(fileSize) / 1024.0
    }
    
    
    /// 圖片大小（以 MB 為單位）
    var fileSizeMB: Double {
        Double(fileSize) / 1024.0 / 1024.0
    }
    
    
    // MARK: - 輸出檔案
    

    /// 自動判斷輸出格式（有透明度→PNG，否則 JPEG）
    func toData(auto: Bool = true, jpegQuality: CGFloat = 0.9) -> Data? {
        if auto {
            if hasAlpha {
                return base.pngData()
            } else {
                return base.jpegData(compressionQuality: jpegQuality)
            }
        } else {
            return base.jpegData(compressionQuality: jpegQuality)
        }
    }

    
    /// 指定格式輸出
    func toData(as format: BRImageDataFormat) -> Data? {
        switch format {
        case .png:
            return base.pngData()
        case .jpeg(let quality):
            return base.jpegData(compressionQuality: quality)
        }
    }

    
    /// 是否有透明通道
    var hasAlpha: Bool {
        guard let alphaInfo = base.cgImage?.alphaInfo else {
            return false
        }
        switch alphaInfo {
        case .first, .last, .premultipliedFirst, .premultipliedLast:
            return true
        default:
            return false
        }
    }
    
    
}
