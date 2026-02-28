//
//  BRTableAdapterProtocol.swift
//  BRUIKit
//
//  Created by BR on 2025/8/27.
//

import UIKit


@MainActor
public protocol BRTableAdapterProtocol {
    var tableView: UITableView { get }
    var list: BRList { get }
    var canEditRows: Bool { get set }
    var canMoveRows: Bool { get set }
    var insertAnimate: UITableView.RowAnimation { get set }
    var headerHeight: ((Int) -> CGFloat)? { get set }
    var footerHeight: ((Int) -> CGFloat)? { get set }
    var sectionIndexTitles: [String]? { get set }
    var didSelectRow: ((IndexPath, BRRow) -> Void)? { get set }
    var didDeleteRow: ((IndexPath, BRRow) -> Void)? { get set }
    var didMoveRow: ((IndexPath, IndexPath, BRRow) -> Void)? { get set }
    
    func update(list: BRList, animated: Bool)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}
