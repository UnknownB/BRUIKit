//
//  BRCollectionView.swift
//  BRUIKit
//
//  Created by BR on 2025/8/27.
//

import UIKit


public class BRCollectionView: UIView {
    
    
    private let layout = BRLayout()

    
    public let collectionView: UICollectionView
    
    
    public let adapter: BRCollectionAdapter
    
    
    // MARK: - LifeCycle
    
    public init(with collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.adapter = BRCollectionAdapter(collectionView: collectionView)
        super.init(frame: .zero)
        setupLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupLayout() {
        self.addSubview(collectionView)
        
        layout.activate {
            collectionView.br.top == safeAreaLayoutGuide.br.top
            collectionView.br.left == safeAreaLayoutGuide.br.left
            collectionView.br.right == safeAreaLayoutGuide.br.right
            collectionView.br.bottom == safeAreaLayoutGuide.br.bottom
        }
    }
    
    
}
