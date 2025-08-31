//
//  BRCollectionAdapter.swift
//  BRUIKit
//
//  Created by BR on 2025/8/27.
//

import UIKit


open class BRCollectionAdapter: NSObject, BRListAdapterProtocol, BRCollectionAdapterProtocol {
    
    
    private var adapter: BRCollectionAdapterProtocol
    
    
    public var collectionView: UICollectionView {
        adapter.collectionView
    }
    
    
    public var list: BRList {
        adapter.list
    }
    
    
    public var canMoveRows: Bool {
        get { adapter.canMoveRows }
        set { adapter.canMoveRows = newValue }
    }
    
    
    public var sectionIndexTitles: [String]? {
        get { adapter.sectionIndexTitles }
        set { adapter.sectionIndexTitles = newValue }
    }
    
    
    public var didSelectRow: ((IndexPath, BRRow) -> Void)? {
        get { adapter.didSelectRow }
        set { adapter.didSelectRow = newValue }
    }
    
    
    public var didMoveRow: ((IndexPath, IndexPath, BRRow) -> Void)? {
        get { adapter.didMoveRow }
        set { adapter.didMoveRow = newValue }
    }
    
    
    // MARK: - Init
    
    
    public init(collectionView: UICollectionView) {
        if #available(iOS 13.0, *) {
            self.adapter = BRCollectionIOS13Adapter(collectionView: collectionView)
        } else {
            self.adapter = BRCollectionIOS6Adapter(collectionView: collectionView)
        }
        super.init()
    }
    
    
    // MARK: - Protocol Methods
    
    
    public func update(list: BRList, animated: Bool = true) {
        adapter.update(list: list, animated: animated)
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        adapter.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    
}
