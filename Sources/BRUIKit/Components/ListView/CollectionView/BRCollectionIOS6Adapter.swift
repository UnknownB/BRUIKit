//
//  BRCollectionIOS6Adapter.swift
//  BRUIKit
//
//  Created by BR on 2025/8/19.
//

import UIKit


public final class BRCollectionIOS6Adapter: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, BRCollectionAdapterProtocol {
    
    
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
    public func update(list newList: BRList, animated: Bool = true) {
        registerAll(in: newList)
        
        guard animated, !self.list.sections.isEmpty else {
            self.list = newList
            collectionView.reloadData()
            return
        }
        
        let oldList = self.list
        self.list = newList

        collectionView.performBatchUpdates({

            let oldSectionMap = Dictionary(uniqueKeysWithValues: oldList.sections.enumerated().map { ($0.element, $0.offset) })
            let newSectionMap = Dictionary(uniqueKeysWithValues: newList.sections.enumerated().map { ($0.element, $0.offset) })

            for (newIndex, section) in newList.sections.enumerated() {
                if let oldIndex = oldSectionMap[section] {
                    if oldIndex != newIndex {
                        collectionView.moveSection(oldIndex, toSection: newIndex)
                    }
                } else {
                    collectionView.insertSections(IndexSet(integer: newIndex))
                }
            }

            for (oldIndex, section) in oldList.sections.enumerated() where newSectionMap[section] == nil {
                collectionView.deleteSections(IndexSet(integer: oldIndex))
            }

            for (sectionIndex, newSection) in newList.sections.enumerated() {
                guard let oldSection = oldList.sections.first(where: { $0 == newSection }) else {
                    for (rowIndex, _) in newSection.rows.enumerated() {
                        collectionView.insertItems(at: [IndexPath(item: rowIndex, section: sectionIndex)])
                    }
                    continue
                }

                let oldRowMap = Dictionary(uniqueKeysWithValues: oldSection.rows.enumerated().map { ($0.element, $0.offset) })
                let newRowMap = Dictionary(uniqueKeysWithValues: newSection.rows.enumerated().map { ($0.element, $0.offset) })

                for (newIndex, row) in newSection.rows.enumerated() {
                    if let oldIndex = oldRowMap[row] {
                        if oldIndex != newIndex {
                            collectionView.moveItem(at: IndexPath(item: oldIndex, section: sectionIndex),
                                                    to: IndexPath(item: newIndex, section: sectionIndex))
                        }
                    } else {
                        collectionView.insertItems(at: [IndexPath(item: newIndex, section: sectionIndex)])
                    }
                }

                for (oldIndex, row) in oldSection.rows.enumerated() where newRowMap[row] == nil {
                    collectionView.deleteItems(at: [IndexPath(item: oldIndex, section: sectionIndex)])
                }
            }
        }, completion: nil)
    }

    
    // MARK: - LifeCycle
    
    
    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
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
    
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        list.sections.count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let supplementary = (kind == UICollectionView.elementKindSectionHeader)
              ? list.sections[indexPath.section].header
              : list.sections[indexPath.section].footer
        let id = supplementary.collReuseIdentifier
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath)
        if case .view(_, _, let configure) = supplementary.content, let view = view as? BRReusableViewProtocol {
            configure(view)
        } else if case .title(let text) = supplementary.content, let view = view as? BRReusableView {
            view.title = text
        }
        return view
    }
    
    
    @available(iOS 14.0, *)
    public func indexTitles(for collectionView: UICollectionView) -> [String]? {
        sectionIndexTitles
    }
    
    
    // MARK: - Cells
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        list.sections[section].rows.count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = list.sections[indexPath.section].rows[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: row.reuseIdentifier, for: indexPath)
        let isFirst = indexPath.row == 0
        let isLast = indexPath.row  == collectionView.numberOfItems(inSection: indexPath.section) - 1
        
        row.bindCell(cell, isFirst, isLast)
        return cell
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = list.sections[indexPath.section].rows[indexPath.row]
        row.onSelect?()
        didSelectRow?(indexPath, row)
    }
    
    
    // MARK: - Edit
    
    
    @available(iOS 9.0, *)
    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        let row = list.sections[indexPath.section].rows[indexPath.row]
        return row.isMovable && canMoveRows
    }
    
    
    @available(iOS 9.0, *)
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedRow = list.sections[sourceIndexPath.section].rows.remove(at: sourceIndexPath.row)
        list.sections[destinationIndexPath.section].rows.insert(movedRow, at: destinationIndexPath.row)
        didMoveRow?(sourceIndexPath, destinationIndexPath, movedRow)
    }
    
    
    // MARK: - Scroll
    
    
    /// 滾動中
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onScrollViewDidScroll?(scrollView)
    }
    
    
    /// 停止滾動
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        onScrollViewDidEnd?(scrollView)
    }
    
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        onScrollViewDidEndDragging?(scrollView, decelerate)
    }
    
    
}
