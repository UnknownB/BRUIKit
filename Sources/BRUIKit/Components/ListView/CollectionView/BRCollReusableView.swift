//
//  BRCollReusableView.swift
//  BRUIKit
//
//  Created by BR on 2025/8/21.
//

import UIKit


@MainActor
open class BRCollReusableView: UICollectionReusableView {
    
    public let layout = BRLayout()
    public lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapped))
    
    
    open var onTap: (() -> Void)?

    
    // MARK: - UI 元件
    
    
    public let titleLabel = UILabel()
        .br.font(.semibold, 15)
        .br.color(.gray)
    
    
    // MARK: - LifeCycle
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addGestureRecognizer(tapGestureRecognizer)
        setupUI()
        setupLayout()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    
    open func setupUI() {
    }

    
    open func setupLayout() {
        addSubview(titleLabel)
        
        layout.activate {
            titleLabel.br.left == self.br.left + 16
            titleLabel.br.right == self.br.right - 8
            titleLabel.br.top == self.br.top
            titleLabel.br.bottom == self.br.bottom
        }
    }
    
    
    // MARK: - Event
    
    
    @objc func onTapped() {
        onTap?()
    }
    
    
}
