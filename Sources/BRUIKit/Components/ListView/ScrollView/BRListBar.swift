//
//  BRListBar.swift
//  BRUIKit
//
//  Created by BR on 2025/9/29.
//

import UIKit


/// BRListBar 繼承自 UIScrollView 並且以 UIStackView 封裝成水平滾動的 ListBar
open class BRListBar: UIScrollView {

    public let layout = BRLayout()
        
    public let stackView = UIStackView()
        .br.axis(.horizontal)
        .br.alignment(.fill)
        .br.distribution(.fill)
    
    
    // MARK: - LifeCycle
    

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupLayout()
    }

    
    open override var contentInset: UIEdgeInsets {
        didSet {
            stackView.br.margins(contentInset)
        }
    }
    
        
    // MARK: - UI
    
    
    private func setupUI() {
    }
    
    
    private func setupLayout() {
        self.addSubview(stackView)
        
        layout.activate {
            stackView.br.left == self.contentLayoutGuide.br.left
            stackView.br.right == self.contentLayoutGuide.br.right
            stackView.br.top == self.contentLayoutGuide.br.top
            stackView.br.bottom == self.contentLayoutGuide.br.bottom
            stackView.br.height == self.frameLayoutGuide.br.height
        }
    }
        
    
}
