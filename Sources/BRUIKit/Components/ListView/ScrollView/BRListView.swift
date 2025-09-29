//
//  BRListView.swift
//  BRUIKit
//
//  Created by BR on 2025/9/29.
//

import UIKit


/// BRListView 繼承自 UIScrollView 並且以 UIStackView 封裝成垂直滾動的 ListView
open class BRListView: UIScrollView {

    public let layout = BRLayout()
        
    public let stackView = UIStackView()
        .br.axis(.vertical)
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
    
        
    open override func layoutSubviews() {
        super.layoutSubviews()
        fixContentWidthForVerticalScrolling()
    }
    
    
    private func fixContentWidthForVerticalScrolling() {
        let contentWidth = bounds.inset(by: contentInset).width
        contentSize.width = contentWidth
    }

    
    // MARK: - UI
    
    
    private func setupUI() {
        self.setContentHuggingPriority(.defaultLow, for: .vertical)
        stackView.setContentHuggingPriority(.required, for: .vertical)
    }
    
    
    private func setupLayout() {
        self.addSubview(stackView)
        
        layout.activate {
            stackView.br.left == self.contentLayoutGuide.br.left
            stackView.br.right == self.contentLayoutGuide.br.right
            stackView.br.top == self.contentLayoutGuide.br.top
            stackView.br.bottom == self.contentLayoutGuide.br.bottom
            stackView.br.width == self.frameLayoutGuide.br.width
            (stackView.br.height == self.frameLayoutGuide.br.height).br.priority(.fittingSizeLevel)
        }
    }
        
    
}
