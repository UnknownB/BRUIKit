//
//  BRListView.swift
//  BRUIKit
//
//  Created by BR on 2025/9/29.
//

import UIKit


/// BRListView 使用 UIScrollView 與 UIStackView 封裝成垂直滾動的 ListView
open class BRListView: UIView {

    let layout = BRLayout()
    
    let scrollView = UIScrollView()
        
    let stackView = UIStackView()
        .br.axis(.vertical)
        .br.alignment(.fill)
        .br.distribution(.fill)
    
    
    // MARK: - LifeCycle
    

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }

    
    // MARK: - UI
    
    
    private func setupLayout() {
        self.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        layout.activate {
            scrollView.br.left == self.br.left
            scrollView.br.right == self.br.right
            scrollView.br.top == self.br.top
            scrollView.br.bottom == self.br.bottom
            
            stackView.br.left == scrollView.contentLayoutGuide.br.left
            stackView.br.right == scrollView.contentLayoutGuide.br.right
            stackView.br.top == scrollView.contentLayoutGuide.br.top
            stackView.br.bottom == scrollView.contentLayoutGuide.br.bottom
            stackView.br.width == scrollView.frameLayoutGuide.br.width
            (stackView.br.height == scrollView.frameLayoutGuide.br.height).br.priority(.fittingSizeLevel)
        }
    }
        
    
}
