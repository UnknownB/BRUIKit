//
//  BRTableRow.swift
//  BRUIKit
//
//  Created by BR on 2025/8/6.
//

import UIKit


@MainActor
public protocol BRTableCellProtocol {
    associatedtype Model
    func bind(with model: Model)
}


@MainActor
public struct BRTableRow {
    let model: Any
    let cellClass: UITableViewCell.Type
    let configure: (UITableViewCell) -> Void
    var didSelect: (() -> Void)?
    var height: CGFloat?
    
    
    @MainActor
    func dequeueCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: cellClass)
        tableView.register(cellClass, forCellReuseIdentifier: identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        configure(cell)
        return cell
    }
    

    public static func of<Cell: UITableViewCell, M>(
        _ model: M,
        cellClass: Cell.Type,
        didSelect: ((M) -> Void)? = nil,
        height: CGFloat? = nil
    ) -> BRTableRow where Cell: BRTableCellProtocol, Cell.Model == M {
        BRTableRow(
            model: model,
            cellClass: cellClass,
            configure: { cell in (cell as? Cell)?.bind(with: model) },
            didSelect: { didSelect },
            height: height
        )
    }
    
    
}
