//
//  BRTableViewAdapter.swift
//  BRUIKit
//
//  Created by BR on 2025/8/6.
//

import UIKit

open class BRTableViewAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    
    public var sections: [BRTableSection]
    public var didSelect: ((IndexPath) -> Void)?
    
    
    public init(sections: [BRTableSection] = [], didSelect: ((IndexPath) -> Void)? = nil) {
        self.sections = sections
    }
    
    
    // MARK: - UITableViewDataSource

    
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = sections[indexPath.section].rows[indexPath.row]
        let cell = row.dequeueCell(for: tableView, at: indexPath)
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect?(indexPath)
    }
    
    
//    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let row = sections[indexPath.section].rows[indexPath.row]
//        return row.height ?? UITableView.automaticDimension
//    }
    
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "header"
        sections[section].headerTitle
    }

    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "footer"

        sections[section].footerTitle
    }
    
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        sections[section].headerView?()
    }
    

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        sections[section].footerView?()
    }
    
    
}
