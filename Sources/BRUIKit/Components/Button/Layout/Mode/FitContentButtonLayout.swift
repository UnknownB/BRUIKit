//
//  FitContentButtonLayout.swift
//  BRUIKit
//
//  Created by BR on 2025/9/26.
//

import BRFoundation
import UIKit


enum FitContentButtonLayout {
    
    
    static func applyLayout(for button: BRButton) -> (CGRect, CGRect) {
        let metrics = BRButtonLayoutMetrics(for: button)

        let contentRect1 = button.bounds.inset(by: button.contentEdgeInsets)
        let contentRect = metrics.contentRect
        var imageRect = metrics.imageRect
        var titleRect = metrics.titleRect
        
        let imagePosition = metrics.imagePosition
        let horizontalAlignment = metrics.horizontalAlignment
        let verticalAlignment = metrics.verticalAlignment
        
        let padding = metrics.padding
        
        switch imagePosition {
        case .left:
            switch horizontalAlignment {
            case .center:
                titleRect.origin.x = contentRect.maxX - (contentRect.width - imageRect.width - padding + titleRect.width) / 2
                imageRect.origin.x = titleRect.minX - padding - imageRect.width
            case .left:
                titleRect.origin.x = contentRect.minX + imageRect.width + padding
                imageRect.origin.x = contentRect.minX
            case .right:
                titleRect.origin.x = contentRect.maxX - titleRect.width
                imageRect.origin.x = titleRect.minX - padding - imageRect.width
            case .fill:
                titleRect.origin.x = imageRect.maxX + padding
                titleRect.size.width = contentRect.width - imageRect.width - padding
            default:
                break
            }
            switch verticalAlignment {
            case .center:
                titleRect.origin.y = contentRect.midY - titleRect.height / 2
                imageRect.origin.y = contentRect.midY - imageRect.height / 2
            case .top:
                titleRect.origin.y = contentRect.minY
                imageRect.origin.y = contentRect.minY
            case .bottom:
                titleRect.origin.y = contentRect.maxY - titleRect.height
                imageRect.origin.y = contentRect.maxY - imageRect.height
            case .fill:
                titleRect.origin.y = contentRect.minY
                titleRect.size.height = contentRect.height
                imageRect.origin.y = contentRect.minY
                imageRect.size.height = contentRect.height
            default:
                break
            }

        case .right:
            switch horizontalAlignment {
            case .center:
                imageRect.origin.x = contentRect.maxX - (contentRect.width - titleRect.width - padding + imageRect.width) / 2
                titleRect.origin.x = imageRect.minX - padding - titleRect.width
            case .left:
                titleRect.origin.x = contentRect.minX
                imageRect.origin.x = titleRect.width + padding
            case .right:
                imageRect.origin.x = contentRect.maxX - imageRect.width
                titleRect.origin.x = imageRect.minX - padding - titleRect.width
            case .fill:
                imageRect.origin.x = contentRect.maxX - imageRect.width
                titleRect.origin.x = contentRect.minX
                titleRect.size.width = contentRect.width - padding - imageRect.width
            default:
                break
            }
            switch verticalAlignment {
            case .center:
                titleRect.origin.y = contentRect.midY - titleRect.height / 2
                imageRect.origin.y = contentRect.midY - imageRect.height / 2
            case .top:
                titleRect.origin.y = contentRect.minY
                imageRect.origin.y = contentRect.minY
            case .bottom:
                titleRect.origin.y = contentRect.maxY - titleRect.height
                imageRect.origin.y = contentRect.maxY - imageRect.height
            case .fill:
                titleRect.origin.y = contentRect.minY
                titleRect.size.height = contentRect.height
                imageRect.origin.y = contentRect.minY
                imageRect.size.height = contentRect.height
            default:
                break
            }

        case .top:
            switch horizontalAlignment {
            case .center:
                titleRect.origin.x = contentRect.midX - titleRect.width / 2
                imageRect.origin.x = contentRect.midX - imageRect.width / 2
            case .left:
                titleRect.origin.x = contentRect.minX
                imageRect.origin.x = contentRect.minX
            case .right:
                titleRect.origin.x = contentRect.maxX - titleRect.width
                imageRect.origin.x = contentRect.maxX - imageRect.width
            case .fill:
                titleRect.origin.x = contentRect.minX
                titleRect.size.width = contentRect.width
                imageRect.origin.x = contentRect.minX
                imageRect.size.width = contentRect.width
            default:
                break
            }
            switch verticalAlignment {
            case .center:
                titleRect.origin.y = contentRect.maxY - (contentRect.height - imageRect.height - padding + titleRect.height) / 2
                imageRect.origin.y = titleRect.minY - padding - imageRect.height
            case .top:
                imageRect.origin.y = contentRect.minY
                titleRect.origin.y = imageRect.maxY + padding
            case .bottom:
                titleRect.origin.y = contentRect.maxY - titleRect.height
                imageRect.origin.y = titleRect.minY - padding - imageRect.height
            case .fill:
                titleRect.origin.y = contentRect.maxY - titleRect.height
                imageRect.origin.y = contentRect.minY
                imageRect.size.height = contentRect.height - titleRect.height - padding
            default:
                break
            }
            
        case .bottom:
            switch horizontalAlignment {
            case .center:
                titleRect.origin.x = contentRect.midX - titleRect.width / 2
                imageRect.origin.x = contentRect.midX - imageRect.width / 2
            case .left:
                titleRect.origin.x = contentRect.minX
                imageRect.origin.x = contentRect.minX
            case .right:
                titleRect.origin.x = contentRect.maxX - titleRect.width
                imageRect.origin.x = contentRect.maxX - imageRect.width
            case .fill:
                titleRect.origin.x = contentRect.minX
                titleRect.size.width = contentRect.width
                imageRect.origin.x = contentRect.minX
                imageRect.size.width = contentRect.width
            default:
                break
            }
            switch verticalAlignment {
            case .center:
                imageRect.origin.y = contentRect.maxY - (contentRect.height - titleRect.height - padding + imageRect.height) / 2
                titleRect.origin.y = imageRect.minY - padding - titleRect.height
            case .top:
                titleRect.origin.y = contentRect.minY
                imageRect.origin.y = titleRect.maxY + padding
            case .bottom:
                imageRect.origin.y = contentRect.maxY - imageRect.height
                titleRect.origin.y = imageRect.minY - padding - titleRect.height
            case .fill:
                titleRect.origin.y = contentRect.minY
                imageRect.origin.y = titleRect.maxY + padding
                imageRect.size.height = contentRect.height - titleRect.height - padding
            default:
                break
            }
        default:
            break
        }
        
        return (imageRect, titleRect)
    }
    
    
}
