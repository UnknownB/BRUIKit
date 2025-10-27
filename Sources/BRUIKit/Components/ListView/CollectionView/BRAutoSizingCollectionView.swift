//
//  BRAutoSizingCollectionView.swift
//  BRUIKit
//
//  Created by BR on 2025/10/27.
//

import UIKit


/// 依據內容大小自動調整 CollectionView Size
open class BRAutoSizingCollectionView: UICollectionView {
    public override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        let height = contentSize.height + contentInset.top + contentInset.bottom
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }

    public override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
}
