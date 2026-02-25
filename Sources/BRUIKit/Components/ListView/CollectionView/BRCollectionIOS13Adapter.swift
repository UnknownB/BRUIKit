//
//  BRCollectionIOS13Adapter.swift
//  BRUIKit
//
//  Created by BR on 2025/8/22.
//

import UIKit


@available(iOS 13.0, *)
public final class BRCollectionIOS13Adapter: UICollectionViewDiffableDataSource<BRSection, BRRow>, UICollectionViewDelegate, BRCollectionAdapterProtocol {
    
    
    public let collectionView: UICollectionView
    
    
    private(set) public var list = BRList {}
    
    
    /// 編輯模式允許移動
    public var canMoveRows: Bool = true
    

    /// tableView 右邊的索引列
    public var sectionIndexTitles: [String]?

    
    /// 選中 cell 的回調
    public var didSelectRow: ((IndexPath, BRRow) -> Void)?
    
    
    /// 完成移動後的回調
    public var didMoveRow: ((IndexPath, IndexPath, BRRow) -> Void)?
    
    
    /// 滾動中
    public var onScrollViewDidScroll: ((UIScrollView) -> Void)?

    
    /// 滾動停止
    public var onScrollViewDidEnd: ((UIScrollView) -> Void)?
    
    
    /// 拖曳停止
    public var onScrollViewDidEndDragging: ((UIScrollView, Bool) -> Void)?
    
    
    /// 更新清單
    public func update(list: BRList, animated: Bool = true) {
        registerAll(in: list)
        self.list = list
        
        var snapshot = NSDiffableDataSourceSnapshot<BRSection, BRRow>()
        for section in list.sections {
            snapshot.appendSections([section])
            snapshot.appendItems(section.rows, toSection: section)
        }
        apply(snapshot, animatingDifferences: animated)
    }
    
    
    // MARK: - LifeCycle
    
    
    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        
        super.init(collectionView: collectionView) { collectionView, indexPath, row in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: row.reuseIdentifier, for: indexPath)
            let isFirst = indexPath.row == 0
            let isLast = indexPath.row  == collectionView.numberOfItems(inSection: indexPath.section) - 1
            
            row.bindCell(cell, isFirst, isLast)
            return cell
        }
        
        supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let self = self else { return nil }
            let supplementary: BRSupplementary = (kind == UICollectionView.elementKindSectionHeader)
                ? self.list.sections[indexPath.section].header
                : self.list.sections[indexPath.section].footer
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: supplementary.collReuseIdentifier, for: indexPath)
            if case .view(_, _, let configure) = supplementary.content?.storage, let view = view as? UIView {
                configure(view)
            } else if case .title(let text) = supplementary.content?.storage, let view = view as? BRCollReusableView {
                view.titleLabel.text = text
            }
            return view
        }

        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    // MARK: - Register
    
        
    private func registerAll(in list: BRList) {
        for section in list.sections {
            for row in section.rows {
                collectionView.register(row.viewType, forCellWithReuseIdentifier: row.reuseIdentifier)
            }
            
            let headerType = section.header.collViewType
            let headerID = section.header.collReuseIdentifier
            collectionView.register(headerType, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
            
            let footerType = section.footer.collViewType
            let footerID = section.footer.collReuseIdentifier
            collectionView.register(footerType, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: footerID)
        }
    }
    
    
    // MARK: - Sections
    
    
    public override func indexTitles(for collectionView: UICollectionView) -> [String]? {
        return sectionIndexTitles
    }
    
    
    // MARK: - Cells
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = list.sections[indexPath.section].rows[indexPath.row]
        row.onSelect?()
        didSelectRow?(indexPath, row)
    }
    
    
    // MARK: - Edit
    
    
    public override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        let row = list.sections[indexPath.section].rows[indexPath.row]
        return row.isMovable && canMoveRows
    }
    
    
    public override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedRow = list.sections[sourceIndexPath.section].rows.remove(at: sourceIndexPath.row)
        list.sections[destinationIndexPath.section].rows.insert(movedRow, at: destinationIndexPath.row)
        
        var snapshot = self.snapshot()
        snapshot.deleteItems([movedRow])
        
        let destSection = list.sections[destinationIndexPath.section]
        let destRows = snapshot.itemIdentifiers(inSection: destSection)
        
        if destinationIndexPath.row >= destRows.count {
            snapshot.appendItems([movedRow], toSection: destSection)
        } else {
            snapshot.insertItems([movedRow], beforeItem: destRows[destinationIndexPath.row])
        }
        apply(snapshot, animatingDifferences: true)
        
        didMoveRow?(sourceIndexPath, destinationIndexPath, movedRow)
    }
    
    
    // MARK: - Scroll
    
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onScrollViewDidScroll?(scrollView)
    }
    
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        onScrollViewDidEnd?(scrollView)
    }
    
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        onScrollViewDidEndDragging?(scrollView, decelerate)
    }

    
}
