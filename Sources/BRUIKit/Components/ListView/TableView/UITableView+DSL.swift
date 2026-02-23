//
//  UITableView+DSL.swift
//  BRUIKit
//
//  Created by BR on 2026/2/23.
//

import BRFoundation
import UIKit


@MainActor
public extension BRWrapper where Base: UITableView {
    
    
    // MARK: - DataSource / Delegate
    
    
    @discardableResult
    func dataSource(_ dataSource: UITableViewDataSource?) -> Base {
        base.dataSource = dataSource
        return base
    }
    
    
    @discardableResult
    func delegate(_ delegate: UITableViewDelegate?) -> Base {
        base.delegate = delegate
        return base
    }
    
    
    // MARK: - Register
    
    
    @discardableResult
    func register(_ cellClass: UITableViewCell.Type) -> Base {
        base.register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
        return base
    }
    
    
    @discardableResult
    func registerHeaderFooter(_ viewClass: UITableViewHeaderFooterView.Type) -> Base {
        base.register(viewClass, forHeaderFooterViewReuseIdentifier: String(describing: viewClass))
        return base
    }
    
    
    // MARK: - Row / Section
    
    
    @discardableResult
    func rowHeight(_ height: CGFloat) -> Base {
        base.rowHeight = height
        return base
    }
    
    
    @discardableResult
    func estimatedRowHeight(_ height: CGFloat) -> Base {
        base.estimatedRowHeight = height
        return base
    }
    
    
    @discardableResult
    func sectionHeaderHeight(_ height: CGFloat) -> Base {
        base.sectionHeaderHeight = height
        return base
    }
    
    
    @discardableResult
    func sectionFooterHeight(_ height: CGFloat) -> Base {
        base.sectionFooterHeight = height
        return base
    }
    
    
    // MARK: - Style
    
    
    @discardableResult
    func separatorStyle(_ style: UITableViewCell.SeparatorStyle) -> Base {
        base.separatorStyle = style
        return base
    }
    
    
    @discardableResult
    func separatorColor(_ color: UIColor?) -> Base {
        base.separatorColor = color
        return base
    }
    
    
    @discardableResult
    func backgroundColor(_ color: UIColor?) -> Base {
        base.backgroundColor = color
        return base
    }
    
    
    // MARK: - Behavior
    
    
    @discardableResult
    func allowsSelection(_ flag: Bool) -> Base {
        base.allowsSelection = flag
        return base
    }
    
    
    @discardableResult
    func allowsMultipleSelection(_ flag: Bool) -> Base {
        base.allowsMultipleSelection = flag
        return base
    }
    
    
    // MARK: - Reload
    
    
    @discardableResult
    func reload() -> Base {
        base.reloadData()
        return base
    }
    
    
    @discardableResult
    func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation = .automatic) -> Base {
        base.reloadSections(sections, with: animation)
        return base
    }
    
    
    @discardableResult
    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation = .automatic) -> Base {
        base.reloadRows(at: indexPaths, with: animation)
        return base
    }
    
    
}
