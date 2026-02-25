//
//  BRTableReusableView.swift
//  BRUIKit
//
//  Created by BR on 2026/2/25.
//

import UIKit


@MainActor
open class BRTableReusableView: UITableViewHeaderFooterView {
    
    public let layout = BRLayout()
    public lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapped))
    
    
    open var onTap: (() -> Void)?
    
    
    // MARK: - LifeCycle
    
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
    }
    
    
    // MARK: - Event
    
    
    @objc func onTapped() {
        onTap?()
    }
    
    
}
