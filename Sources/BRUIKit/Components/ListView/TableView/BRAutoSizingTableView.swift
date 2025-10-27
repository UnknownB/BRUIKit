//
//  BRAutoSizingTableView.swift
//  BRUIKit
//
//  Created by BR on 2025/10/27.
//

import UIKit


/// 依據內容大小自動調整 TableView Size
open class BRAutoSizingTableView: UITableView {
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
