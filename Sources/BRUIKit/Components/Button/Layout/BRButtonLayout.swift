//
//  BRButtonLayout.swift
//  BRUIKit
//
//  Created by BR on 2025/9/19.
//

import Foundation


/// 設定 Button 圖片與文字的排版方式
public enum BRButtonLayout {
    
    /// Content (圖片與文字) 依據自然尺寸排版對齊
    case fitContent
    
    /// 圖片固定，文字在剩餘空間依據自然尺寸排版對齊
    case pinImageFitTitle
    
    /// 圖片固定，文字在完整空間依據自然尺寸排版對齊
    case pinImageFreeTitle
    
}
