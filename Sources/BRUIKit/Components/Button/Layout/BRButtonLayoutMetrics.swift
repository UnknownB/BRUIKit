//
//  BRButtonLayoutMetrics.swift
//  BRUIKit
//
//  Created by BR on 2025/9/26.
//

import BRFoundation
import UIKit


/// Button 排版引擎的數據準備層
@MainActor
public struct BRButtonLayoutMetrics {
    
    public let contentRect: CGRect
    public let titleRect: CGRect
    public let imageRect: CGRect
    
    public let imagePosition: BRPosition
    public let imageInset: CGFloat
    public let padding: CGFloat
    
    public let isVertical: Bool
    public let horizontalAlignment: UIControl.ContentHorizontalAlignment
    public let verticalAlignment: UIControl.ContentVerticalAlignment
    
    
    // MARK: - Init
    
    
    public init(for button: BRButton, baseIntrinsicSize: CGSize? = nil) {
        let baseIntrinsicSize = baseIntrinsicSize ?? button.bounds.inset(by: button.contentEdgeInsets).size
        imagePosition = Self.imagePosition(for: button)
        imageInset = Self.imageInset(for: button, position: imagePosition)
        padding = button.imagePadding
        
        isVertical = imagePosition.isVertical
        horizontalAlignment = Self.horizontalAlignment(for: button)
        verticalAlignment = button.contentVerticalAlignment
        
        contentRect = Self.contentRect(button: button, baseIntrinsicSize: baseIntrinsicSize)
        imageRect = Self.imageRect(for: button, contentRect: contentRect, baseIntrinsicSize: baseIntrinsicSize)
        titleRect = Self.titleRect(for: button, contentRect: contentRect, isVertical: isVertical, imageRect: imageRect, imageInset: imageInset)
    }
    
    
    // MARK: - Help
    
    
    private static func contentRect(button: BRButton, baseIntrinsicSize: CGSize) -> CGRect {
        var bounds = button.bounds.inset(by: button.contentEdgeInsets)
        bounds.size.width = bounds.width > 0 ? bounds.width : baseIntrinsicSize.width
        bounds.size.height = bounds.height > 0 ? bounds.height : baseIntrinsicSize.height
        return bounds
    }
    
    
    private static func titleRect(for button: BRButton, contentRect: CGRect, isVertical: Bool, imageRect: CGRect, imageInset: CGFloat) -> CGRect {
        let padding = button.imagePadding
        let remainingWidth = contentRect.width - imageRect.width - padding - imageInset
        let remainingHeight = contentRect.height - imageRect.height - imageInset - padding
        
        let fittingSize = CGSize(
            width: isVertical ? contentRect.width : remainingWidth,
            height: isVertical ? remainingHeight : contentRect.height
        )
        
        var rect = button.titleRect(forContentRect: contentRect)
        rect.size = button.titleLabel?.sizeThatFits(fittingSize) ?? .zero
        return rect
    }
    
    
    private static func imageRect(for button: BRButton, contentRect: CGRect, baseIntrinsicSize: CGSize) -> CGRect {
        var contentRect = contentRect
        contentRect.size.height = baseIntrinsicSize.height
        var imageRect = button.imageRect(forContentRect: contentRect)
        imageRect.size.width = button.imageSize?.width ?? imageRect.width
        imageRect.size.height = button.imageSize?.height ?? imageRect.height
        return imageRect
    }
    
    
    private static func imageInset(for button: BRButton, position: BRPosition) -> CGFloat {
        if button.layoutMode == .fitContent {
            return 0
        }
        let imageInsets = button.imageInsets
        
        switch position {
        case .top: return imageInsets.top
        case .bottom: return imageInsets.bottom
        case .left: return imageInsets.left
        case .right: return imageInsets.right
        default: return 0
        }
    }

    
    private static func imagePosition(for button: BRButton) -> BRPosition {
        let isRTL = button.effectiveUserInterfaceLayoutDirection == .rightToLeft
        let position = button.imagePosition
        
        if position == .leading {
            return isRTL ? .right : .left
        }
        if position == .trailing {
            return isRTL ? .left : .right
        }
        return position
    }
    
    
    private static func horizontalAlignment(for button: BRButton) -> UIControl.ContentHorizontalAlignment {
        let isRTL = button.effectiveUserInterfaceLayoutDirection == .rightToLeft
        let alignment = button.contentHorizontalAlignment

        if alignment == .leading {
            return isRTL ? .right : .left
        }
        if alignment == .trailing {
            return isRTL ? .left : .right
        }
        return alignment
    }
    
    
}
