//
//  BRTableIOS13Adapter.swift
//  BRUIKit
//
//  Created by BR on 2025/8/25.
//

import UIKit


@available(iOS 13.0, *)
open class BRTableIOS13Adapter: UITableViewDiffableDataSource<BRSection, BRRow>, UITableViewDelegate, BRTableAdapterProtocol {
    
    
    public let tableView: UITableView
    
    
    private(set) public var list = BRList {}
    
    
    public var canEditRows: Bool = false
    
    
    public var canMoveRows: Bool = true
    
    
    /// 插入動畫
    public var insertAnimate: UITableView.RowAnimation {
        get { defaultRowAnimation }
        set { defaultRowAnimation = newValue }
    }
    
    
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
    
    
    public init(tableView: UITableView) {
        self.tableView = tableView
        super.init(tableView: tableView) { tableView, indexPath, row in
            let cell = tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier, for: indexPath)
            let isFirst = indexPath.row == 0
            let isLast = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
            
            row.bindCell(cell, isFirst, isLast)
            return cell
        }
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
