//
//  BRLeftAligendFlowLayout.swift
//  BRUIKit
//
//  Created by BR on 2025/10/27.
//

import UIKit


/// 讓 item 從左到右自然排列
open class BRLeftAlignedFlowLayout: UICollectionViewFlowLayout {
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1

        for layoutAttribute in attributes where layoutAttribute.representedElementCategory == .cell {
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        return attributes
    }
    
}
