//
//  BRTipLabel.swift
//  BRUIKit
//
//  Created by BR on 2026/7/21.
//

import UIKit


public final class BRTipLabel: BRLabel {

    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }


    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setup() {
        self
            .br.contentInsets(UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10))
            .br.cornerRadius(8)
            .br.lines(0)
            .br.backgroundColor(.label)
            .br.color(.systemBackground)
            .br.font(UIFont.preferredFont(forTextStyle: .footnote))
    }


    public func show(tip: String?, above target: UIView) {
        guard let window = target.window else { return }

        window.addSubview(self)
        text = tip
        
        let horizontalMargin: CGFloat = 16
        let maxWidth = window.bounds.width - horizontalMargin * 2
        preferredMaxLayoutWidth = maxWidth - contentInsets.left - contentInsets.right
        
        let gap: CGFloat = 8
        let size = intrinsicContentSize
        let targetFrame = target.convert(target.bounds, to: window)
        let minX = horizontalMargin
        let maxX = window.bounds.width - horizontalMargin - size.width
        let x = max(minX, min(targetFrame.midX - size.width / 2, maxX))
        let y = max(window.safeAreaInsets.top, targetFrame.minY - gap - size.height)
        frame = CGRect(x: x, y: y, width: size.width, height: size.height)
    }


}
