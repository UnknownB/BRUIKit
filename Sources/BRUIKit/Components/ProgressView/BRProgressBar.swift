//
//  BRProgressBar.swift
//  BRUIKit
//
//  Created by BR on 2026/7/21.
//

import UIKit


private extension String {
    static let progressValue = "progressValue"
}


open class BRProgressBar: BRView {
    
    public let progressView = BRView()


    private var _progress: CGFloat = 0
    
    open var progress: Float {
        get {
            Float(_progress)
        }
        set {
            _progress = CGFloat(newValue)
            layout.setMultiplier(_progress, for: .progressValue)
        }
    }
    
    
    open override func setupLayout() {
        super.setupLayout()
        contentView.addSubview(progressView)
        
        layout.activate {
            progressView.br.top == contentView.br.top
            progressView.br.left == contentView.br.left
            progressView.br.bottom == contentView.br.bottom
            (progressView.br.width == contentView.br.width * 0).br.saved(.progressValue)
        }
    }
    
    
    open func setProgress(_ progress: Float, animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            self.progress = progress
            self.layoutIfNeeded()
        }
    }
    
    
}
