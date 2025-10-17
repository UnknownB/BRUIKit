//
//  PinImageFitTitleButtonLayout.swift
//  BRUIKit
//
//  Created by BR on 2025/9/26.
//

import BRFoundation
import UIKit


@MainActor
enum PinImageFitTitleButtonLayout {
    
    
    static func applyLayout(for button: BRButton) -> (CGRect, CGRect) {
        let metrics = BRButtonLayoutMetrics(for: button)

        let contentRect = metrics.contentRect
        var imageRect = metrics.imageRect
        var titleRect = metrics.titleRect
        
        let imagePosition = metrics.imagePosition
        let horizontalAlignment = metrics.horizontalAlignment
        let verticalAlignment = metrics.verticalAlignment
        
        let imageInset = metrics.imageInset
        let padding = metrics.padding

        switch imagePosition {
        case .left:
            switch horizontalAlignment {
            case .center:
                imageRect.origin.x = contentRect.minX + imageInset
                titleRect.origin.x = imageRect.maxX + (contentRect.maxX - imageRect.maxX - titleRect.width) / 2
                if titleRect.minX - imageRect.maxX < padding {
                    titleRect.origin.x = imageRect.maxX + padding
                }
            case .left:
                imageRect.origin.x = contentRect.minX + imageInset
                titleRect.origin.x = imageRect.maxX + padding
            case .right:
                imageRect.origin.x = contentRect.minX + imageInset
                titleRect.origin.x = contentRect.maxX - titleRect.width
            case .fill:
                imageRect.origin.x = contentRect.minX + imageInset
                titleRect.size.width = contentRect.maxX - imageRect.maxX - padding
                titleRect.origin.x = contentRect.maxX - titleRect.width
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
                imageRect.origin.x = contentRect.maxX - imageInset - imageRect.width
                titleRect.origin.x = imageRect.minX - (imageRect.minX - contentRect.minX - titleRect.width) / 2 - titleRect.width
                if imageRect.minX - titleRect.maxX < padding {
                    titleRect.origin.x = imageRect.minX - padding - titleRect.width
                }
            case .left:
                imageRect.origin.x = contentRect.maxX - imageInset - imageRect.width
                titleRect.origin.x = contentRect.minX
            case .right:
                imageRect.origin.x = contentRect.maxX - imageInset - imageRect.width
                titleRect.origin.x = imageRect.minX - padding - titleRect.width
            case .fill:
                imageRect.origin.x = contentRect.maxX - imageInset - imageRect.width
                titleRect.size.width = imageRect.minX - contentRect.minX - padding
                titleRect.origin.x = contentRect.minX
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
                imageRect.origin.y = contentRect.minY + imageInset
                titleRect.origin.y = imageRect.maxY + (contentRect.maxY - imageRect.maxY - titleRect.height) / 2
                if titleRect.minY - imageRect.maxY < padding {
                    titleRect.origin.y = imageRect.maxY + padding
                }
            case .top:
                imageRect.origin.y = contentRect.minY + imageInset
                titleRect.origin.y = imageRect.maxY + padding
            case .bottom:
                imageRect.origin.y = contentRect.minY + imageInset
                titleRect.origin.y = contentRect.maxY - titleRect.height
            case .fill:
                imageRect.origin.y = contentRect.minY + imageInset
                imageRect.size.height = contentRect.height - titleRect.height - padding - imageInset
                titleRect.origin.y = imageRect.maxY + padding
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
                imageRect.origin.y = contentRect.maxY - imageInset - imageRect.height
                titleRect.origin.y = imageRect.minY - (imageRect.minY - contentRect.minY - titleRect.height) / 2 - titleRect.height
                if imageRect.minY - titleRect.maxY < padding {
                    titleRect.origin.y = imageRect.minY - padding - titleRect.height
                }
            case .top:
                titleRect.origin.y = contentRect.minY
                imageRect.origin.y = contentRect.maxY - imageInset - imageRect.height
            case .bottom:
                imageRect.origin.y = contentRect.maxY - imageInset - imageRect.height
                titleRect.origin.y = imageRect.minY - padding - titleRect.height
            case .fill:
                titleRect.origin.y = contentRect.minY
                imageRect.origin.y = titleRect.maxY + padding
                imageRect.size.height = contentRect.height - titleRect.height - padding - imageInset
            default:
                break
            }
        default:
            break
        }
        return (imageRect, titleRect)
    }
    
    
}
