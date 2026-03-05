//
//  BRTableIOS13Adapter.swift
//  BRUIKit
//
//  Created by BR on 2025/8/25.
//

import BRFoundation
import UIKit


@available(iOS 13.0, *)
open class BRTableIOS13Adapter: NSObject, BRTableAdapterProtocol {
    
    
    private let dataSource: BRTableViewDiffableDataSource
    
    
    private var snapshot: NSDiffableDataSourceSnapshot<BRSection, BRRow> = .init()
    
    
    public let tableView: UITableView
    
    
    public var list: BRList {
        dataSource.list
    }
    
    
    public var canEditRows: Bool {
        get { dataSource.canEditRows }
        set { dataSource.canEditRows = newValue }
    }
    
    
    public var canMoveRows: Bool {
        get { dataSource.canMoveRows }
        set { dataSource.canMoveRows = newValue }
    }
    
    
    /// 插入動畫
    public var insertAnimate: UITableView.RowAnimation {
        get { dataSource.defaultRowAnimation }
        set { dataSource.defaultRowAnimation = newValue }
    }
    
    
    /// 指定 section header 高度
    public var headerHeight: ((Int) -> CGFloat)? {
        get { dataSource.headerHeight }
        set { dataSource.headerHeight = newValue }
    }
    
    
    /// 指定 section footer 高度
    public var footerHeight: ((Int) -> CGFloat)? {
        get { dataSource.footerHeight }
        set { dataSource.footerHeight = newValue }
    }
    
    
    /// tableView 右邊的索引列
    public var sectionIndexTitles: [String]? {
        get { dataSource.sectionIndexTitles }
        set { dataSource.sectionIndexTitles = newValue }
    }
    
    
    /// 選中 cell 的回調
    public var didSelectRow: ((IndexPath, BRRow) -> Void)? {
        get { dataSource.didSelectRow }
        set { dataSource.didSelectRow = newValue }
    }
    
    
    /// 完成刪除後的回調
    public var didDeleteRow: ((IndexPath, BRRow) -> Void)? {
        get { dataSource.didDeleteRow }
        set { dataSource.didDeleteRow = newValue }
    }
    
    
    /// 完成移動後的回調
    public var didMoveRow: ((IndexPath, IndexPath, BRRow) -> Void)? {
        get { dataSource.didMoveRow }
        set { dataSource.didMoveRow = newValue }
    }
    
    
    // MARK: - LifeCycle
    
    
    public init(tableView: UITableView) {
        self.tableView = tableView
        self.dataSource = .init(tableView: tableView) { tableView, indexPath, row in
            let cell = tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier, for: indexPath)
            let isFirst = indexPath.row == 0
            let isLast = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
            
            row.bindCell(cell, isFirst, isLast)
            return cell
        }
        tableView.dataSource = self.dataSource
        tableView.delegate = self.dataSource
    }
    
    
    // MARK: - Register
    
    
    private func registerAll(in list: BRList) {
        for section in list.sections {
            
            if let headerType = section.header.tableReusableType {
                let headerID = section.header.tableReusableID
                tableView.register(headerType, forHeaderFooterViewReuseIdentifier: headerID)
            }
            
            if let footerType = section.footer.tableReusableType {
                let footerID = section.footer.tableReusableID
                tableView.register(footerType, forHeaderFooterViewReuseIdentifier: footerID)
            }
            
            for row in section.rows {
                tableView.register(row.viewType, forCellReuseIdentifier: row.reuseIdentifier)
            }
        }
    }
    
    
    // MARK: - Update
    
    
    /// 更新清單
    open func update(list: BRList, animated: Bool = true, completion: (() -> Void)? = nil) {
        registerAll(in: list)
        dataSource.list = list
        
        var snapshot = NSDiffableDataSourceSnapshot<BRSection, BRRow>()
        for section in list.sections {
            snapshot.appendSections([section])
            snapshot.appendItems(section.rows, toSection: section)
        }
        self.snapshot = snapshot
        dataSource.apply(snapshot, animatingDifferences: animated, completion: completion)
    }
    
    
    /// 添加 Sections
    open func appendSections(_ sections: [BRSection]) {
        snapshot.appendSections(sections)
        dataSource.list.sections.append(contentsOf: sections)
    }
    
    
    /// 添加 Items 到指定的 Section
    open func appendItems(_ rows: [BRRow], toSection section: BRSection) {
        guard let index = dataSource.list.sections.firstIndex(of: section) else {
            #BRLog(.library, .error, "insertItems but section not exist")
            return
        }
        if let row = rows.first {
            tableView.register(row.viewType, forCellReuseIdentifier: row.reuseIdentifier)
        }
        snapshot.appendItems(rows, toSection: section)
        dataSource.list.sections[index].rows.append(contentsOf: rows)
    }
    
    
    /// 添加 Items 到指定的 Section 索引值
    open func appendItems(_ rows: [BRRow], toSection sectionIndex: Int = 0) {
        if let row = rows.first {
            tableView.register(row.viewType, forCellReuseIdentifier: row.reuseIdentifier)
        }
        snapshot.appendItems(rows, toSection: dataSource.list.sections[sectionIndex])
        dataSource.list.sections[sectionIndex].rows.append(contentsOf: rows)
    }
    
    
    /// 插入 Sections 到指定的 Section 之前
    open func insertSections(_ sections: [BRSection], beforeSection: BRSection) {
        snapshot.insertSections(sections, beforeSection: beforeSection)
        dataSource.list.sections.insert(contentsOf: sections, at: dataSource.list.sections.firstIndex(of: beforeSection)!)
    }
    
    
    /// 插入 Sections 到指定的 Section 之後
    open func insertSections(_ sections: [BRSection], afterSection: BRSection) {
        snapshot.insertSections(sections, afterSection: afterSection)
        dataSource.list.sections.insert(contentsOf: sections, at: dataSource.list.sections.firstIndex(of: afterSection)! + 1)
    }
    
    
    /// 插入 Items 到指定的 Item 之前
    open func insertItems(_ rows: [BRRow], beforeItem: BRRow) {
        snapshot.insertItems(rows, beforeItem: beforeItem)
        list.sections.indices.forEach {
            if let index = dataSource.list.sections[$0].rows.firstIndex(of: beforeItem) {
                dataSource.list.sections[$0].rows.insert(contentsOf: rows, at: index)
            }
        }
    }
    
    
    /// 插入 Items 到指定的 Items 之後
    open func insertItems(_ rows: [BRRow], afterItem: BRRow) {
        snapshot.insertItems(rows, afterItem: afterItem)
        list.sections.indices.forEach {
            if let index = dataSource.list.sections[$0].rows.firstIndex(of: afterItem) {
                dataSource.list.sections[$0].rows.insert(contentsOf: rows, at: index + 1)
            }
        }
    }
    
    
    /// 刪除指定的 Sections
    open func deleteSections(_ sections: [BRSection]) {
        snapshot.deleteSections(sections)
        dataSource.list.sections.removeAll(where: { sections.contains($0) })
    }
    
    
    /// 刪除指定的 Items
    open func deleteItems(_ rows: [BRRow]) {
        snapshot.deleteItems(rows)
        list.sections.indices.forEach {
            dataSource.list.sections[$0].rows.removeAll(where: { rows.contains($0) })
        }
    }
    
    
    /// 套用 snapshot 差異
    open func applySnapshot(animated: Bool = true, completion: (() -> Void)? = nil) {
        dataSource.apply(snapshot, animatingDifferences: animated, completion: completion)
    }
    
    
    /// 刷新指定的 Sections
    open func reloadSections(_ sections: [BRSection]) {
        snapshot.reloadSections(sections)
    }
    
    
    /// 刷新指定的 Items
    open func reloadItems(_ rows: [BRRow]) {
        snapshot.reloadItems(rows)
    }
    
    
    // MARK: - Event
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource.tableView(tableView, didSelectRowAt: indexPath)
    }

    
}


private class BRTableViewDiffableDataSource: UITableViewDiffableDataSource<BRSection, BRRow>, UITableViewDelegate {
    
    
    public var list = BRList {}
    
    
    public var canEditRows: Bool = false
    
    
    public var canMoveRows: Bool = true
    
    
    /// 指定 section header 高度
    public var headerHeight: ((Int) -> CGFloat)?
    
    
    /// 指定 section footer 高度
    public var footerHeight: ((Int) -> CGFloat)?
    
    
    /// tableView 右邊的索引列
    public var sectionIndexTitles: [String]?
    
    
    /// 選中 cell 的回調
    public var didSelectRow: ((IndexPath, BRRow) -> Void)?
    
    
    /// 完成刪除後的回調
    public var didDeleteRow: ((IndexPath, BRRow) -> Void)?
    
    
    /// 完成移動後的回調
    public var didMoveRow: ((IndexPath, IndexPath, BRRow) -> Void)?

    
    // MARK: - Sections
    
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if case .title(let title) = list.sections[section].header.content?.storage {
            return title
        }
        return nil
    }
    
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        list.sections[section].header.tableReusableView(with: tableView)
    }
    
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if list.sections[section].header.content != nil {
            return headerHeight?(section) ?? UITableView.automaticDimension
        }
        return headerHeight?(section) ?? 0.01
    }
    
    
    public override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if case .title(let title) = list.sections[section].footer.content?.storage {
            return title
        }
        return nil
    }
    
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        list.sections[section].footer.tableReusableView(with: tableView)
    }


    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if list.sections[section].footer.content != nil {
            return footerHeight?(section) ?? UITableView.automaticDimension
        }
        return footerHeight?(section) ?? 0.01
    }

    
    public override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        sectionIndexTitles
    }
    
    
    // MARK: - Rows

    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        // 預設估算高度，加速初次載入
        45
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = list.sections[indexPath.section].rows[indexPath.row]
        row.onSelect?()
        didSelectRow?(indexPath, row)
    }

    
    // MARK: - Edit
    
    
    public override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let row = list.sections[indexPath.section].rows[indexPath.row]
        return row.isEditable && canEditRows
    }
    
    
    public override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        let row = list.sections[indexPath.section].rows[indexPath.row]
        list.sections[indexPath.section].rows.remove(at: indexPath.row)
        
        var snapshot = self.snapshot()
        snapshot.deleteItems([row])
        apply(snapshot, animatingDifferences: true)

        didDeleteRow?(indexPath, row)
    }
    
    
    public override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let row = list.sections[indexPath.section].rows[indexPath.row]
        return row.isMovable && canMoveRows
    }
    
    
    public override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
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
}
