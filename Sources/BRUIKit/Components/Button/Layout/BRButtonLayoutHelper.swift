//
//  BRButtonLayoutHelper.swift
//  BRUIKit
//
//  Created by BR on 2025/9/19.
//

import BRFoundation
import UIKit


@MainActor
public final class BRButtonLayoutHelper {
    
    
    // MARK: - Public
    
    
    /// 計算元件的自然尺寸
    public func intrinsicContentSize(for button: BRButton, using baseIntrinsicSize: CGSize) -> CGSize {
        let metrics = BRButtonLayoutMetrics(for: button, baseIntrinsicSize: baseIntrinsicSize)
        
        let titleSize = metrics.titleRect.size
        let imageSize = metrics.imageRect.size

        let isVertical = metrics.isVertical
        let imageInset = metrics.imageInset
        let edgeInsets = button.contentEdgeInsets
        let padding = metrics.padding
        
        let contentWidth  = isVertical ? max(imageSize.width, titleSize.width) : imageSize.width + padding + titleSize.width
        let contentHeight = isVertical ? imageSize.height + padding + titleSize.height : max(imageSize.height, titleSize.height)
        let imageInsetSize = CGSize(width: isVertical ? 0 : imageInset, height: isVertical ? imageInset : 0)
        
        let width  = contentWidth + edgeInsets.left + edgeInsets.right + imageInsetSize.width
        let height = contentHeight + edgeInsets.top + edgeInsets.bottom + imageInsetSize.height
        
        return CGSize(width: width, height: height)
    }
    
    
    /// 套用排版設定
    public func applyLayout(for button: BRButton) {
        guard button.bounds.width > 0, button.bounds.height > 0 else {
            return
        }
        guard let imageView = button.imageView, let titleLabel = button.titleLabel else {
            return
        }
        var imageFrame = CGRect.zero
        var titleFrame = CGRect.zero
        
        switch button.layoutMode {
            
        case .fitContent:
            (imageFrame, titleFrame) = FitContentButtonLayout.applyLayout(for: button)
            
        case .pinImageFitTitle:
            (imageFrame, titleFrame) = PinImageFitTitleButtonLayout.applyLayout(for: button)
            
        case .pinImageFreeTitle:
            (imageFrame, titleFrame) = PinImageFreeTitleButtonLayout.applyLayout(for: button)
            
        }
        
        imageView.frame = imageFrame
        titleLabel.frame = titleFrame
    }
    
    
}
