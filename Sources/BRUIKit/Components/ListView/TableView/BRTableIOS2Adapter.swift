//
//  BRTableIOS2Adapter.swift
//  BRUIKit
//
//  Created by BR on 2025/8/6.
//

import UIKit


open class BRTableIOS2Adapter: NSObject, UITableViewDataSource, UITableViewDelegate, BRTableAdapterProtocol {
    
    
    public let tableView: UITableView
    
    
    private(set) public var list = BRList {}
    
    
    public var canEditRows: Bool = false
    
    
    public var canMoveRows: Bool = true
    
    
    /// 插入動畫
    public var insertAnimate: UITableView.RowAnimation = .automatic
    
    
    /// 刪除動畫
    public var deleteAnimate: UITableView.RowAnimation = .automatic
    
    
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
    
    
    /// 更新清單
    public func update(list newList: BRList, animated: Bool = true) {
        registerAll(in: newList)
        
        if !animated || list.sections.isEmpty {
            list = newList
            tableView.reloadData()
            return
        }
        
        let oldList = list
        list = newList
        
        tableView.performBatchUpdates({
            
            let oldSectionMap = Dictionary(uniqueKeysWithValues: oldList.sections.enumerated().map { ($0.element, $0.offset) })
            let newSectionMap = Dictionary(uniqueKeysWithValues: newList.sections.enumerated().map { ($0.element, $0.offset) })
            
            for (newIndex, section) in newList.sections.enumerated() {
                if let oldIndex = oldSectionMap[section] {
                    if oldIndex != newIndex {
                        tableView.moveSection(oldIndex, toSection: newIndex)
                    }
                } else {
                    tableView.insertSections(IndexSet(integer: newIndex), with: insertAnimate)
                }
            }
            
            for (oldIndex, section) in oldList.sections.enumerated() where newSectionMap[section] == nil {
                tableView.deleteSections(IndexSet(integer: oldIndex), with: deleteAnimate)
            }
            
            for (sectionIndex, newSection) in newList.sections.enumerated() {
                guard let oldSection = oldList.sections.first(where: { $0 == newSection }) else {
                    for (rowIndex, _) in newSection.rows.enumerated() {
                        tableView.insertRows(at: [IndexPath(row: rowIndex, section: sectionIndex)], with: insertAnimate)
                    }
                    continue
                }
                
                let oldRowMap = Dictionary(uniqueKeysWithValues: oldSection.rows.enumerated().map { ($0.element, $0.offset) })
                let newRowMap = Dictionary(uniqueKeysWithValues: newSection.rows.enumerated().map { ($0.element, $0.offset) })
                
                for (newIndex, row) in newSection.rows.enumerated() {
                    if let oldIndex = oldRowMap[row] {
                        if oldIndex != newIndex {
                            tableView.moveRow(at: IndexPath(row: oldIndex, section: sectionIndex),
                                              to: IndexPath(row: newIndex, section: sectionIndex))
                        }
                    } else {
                        tableView.insertRows(at: [IndexPath(row: newIndex, section: sectionIndex)], with: insertAnimate)
                    }
                }
                
                for (oldIndex, row) in oldSection.rows.enumerated() where newRowMap[row] == nil {
                    tableView.deleteRows(at: [IndexPath(row: oldIndex, section: sectionIndex)], with: deleteAnimate)
                }
            }
        }, completion: nil)
    }
    
    
    // MARK: - LifeCycle
    
    
    public init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
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

    
    // MARK: - Sections

    
    public func numberOfSections(in tableView: UITableView) -> Int {
        list.sections.count
    }
    
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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

    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
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
    
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        sectionIndexTitles
    }
    
    
    // MARK: - Rows
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.sections[section].rows.count
    }
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        // 預設估算高度，加速初次載入
        45
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = list.sections[indexPath.section].rows[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier, for: indexPath)
        let isFirst = indexPath.row == 0
        let isLast = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        
        row.bindCell(cell, isFirst, isLast)
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = list.sections[indexPath.section].rows[indexPath.row]
        row.onSelect?()
        didSelectRow?(indexPath, row)
    }
    
    
    // MARK: - Edit
    
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let row = list.sections[indexPath.section].rows[indexPath.row]
        return row.isEditable && canEditRows
    }
    
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        let row = list.sections[indexPath.section].rows[indexPath.row]
        list.sections[indexPath.section].rows.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        didDeleteRow?(indexPath, row)
    }
    
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let row = list.sections[indexPath.section].rows[indexPath.row]
        return row.isMovable && canMoveRows
    }
    
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedRow = list.sections[sourceIndexPath.section].rows.remove(at: sourceIndexPath.row)
        list.sections[destinationIndexPath.section].rows.insert(movedRow, at: destinationIndexPath.row)
        didMoveRow?(sourceIndexPath, destinationIndexPath, movedRow)
    }
    
    
}
