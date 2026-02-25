//
//  BRReusableView.swift
//  BRUIKit
//
//  Created by BR on 2025/8/21.
//

import UIKit


@MainActor
open class BRReusableView: UICollectionReusableView {
    
    private let layout = BRLayout()
    
    
    public var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    
    private let titleLabel = UILabel()
        .br.font(.semibold, 15)
        .br.color(.gray)
    
    
    // MARK: - LifeCycle
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    
    public required init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    
    // MARK: - UI

    
    private func setupLayout() {
        addSubview(titleLabel)
        
        layout.activate {
            titleLabel.br.left == self.br.left + 16
            titleLabel.br.right == self.br.right - 8
            titleLabel.br.top == self.br.top
            titleLabel.br.bottom == self.br.bottom
        }
    }
}
