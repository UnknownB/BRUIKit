//
//  BRTableAdapter.swift
//  BRUIKit
//
//  Created by BR on 2025/8/27.
//

import UIKit


open class BRTableAdapter: NSObject, BRListAdapterProtocol, BRTableAdapterProtocol {
    
    
    private var adapter: BRTableAdapterProtocol
    
    
    public var tableView: UITableView {
        adapter.tableView
    }
    
    
    public var list: BRList {
        adapter.list
    }
    
    
    public var canEditRows: Bool {
        get { adapter.canEditRows }
        set { adapter.canEditRows = newValue }
    }
    
    
    public var canMoveRows: Bool {
        get { adapter.canMoveRows }
        set { adapter.canMoveRows = newValue }
    }
    
    
    public var insertAnimate: UITableView.RowAnimation {
        get { adapter.insertAnimate }
        set { adapter.insertAnimate = newValue }
    }
    
    
    public var headerHeight: ((Int) -> CGFloat)? {
        get { adapter.headerHeight }
        set { adapter.headerHeight = newValue }
    }

    
    public var footerHeight: ((Int) -> CGFloat)? {
        get { adapter.footerHeight }
        set { adapter.footerHeight = newValue }
    }

    
    public var sectionIndexTitles: [String]? {
        get { adapter.sectionIndexTitles }
        set { adapter.sectionIndexTitles = newValue }
    }
    
    
    public var didSelectRow: ((IndexPath, BRRow) -> Void)? {
        get { adapter.didSelectRow }
        set { adapter.didSelectRow = newValue }
    }
    
    
    public var didDeleteRow: ((IndexPath, BRRow) -> Void)? {
        get { adapter.didDeleteRow }
        set { adapter.didDeleteRow = newValue }
    }
    
    
    public var didMoveRow: ((IndexPath, IndexPath, BRRow) -> Void)? {
        get { adapter.didMoveRow }
        set { adapter.didMoveRow = newValue }
    }
    
    
    // MARK: - Init
    
    
    public init(tableView: UITableView) {
        if #available(iOS 13.0, *) {
            self.adapter = BRTableIOS13Adapter(tableView: tableView)
        } else {
            self.adapter = BRTableIOS2Adapter(tableView: tableView)
        }
        super.init()
    }
    
    
    // MARK: - Protocol Methods
    
    
    public func update(list: BRList, animated: Bool = true) {
        adapter.update(list: list, animated: animated)
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        adapter.tableView(tableView, didSelectRowAt: indexPath)
    }
    
    
}
