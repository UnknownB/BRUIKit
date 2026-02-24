//
//  BRTableView.swift
//  BRUIKit
//
//  Created by BR on 2025/8/27.
//

import UIKit


public class BRTableView: UIView {
    private let layout = BRLayout()

    public let tableView: UITableView
    public let adapter: BRTableAdapter
    
    
    public override var backgroundColor: UIColor? {
        didSet {
            tableView.backgroundColor = backgroundColor
        }
    }
    
    
    // MARK: - LifeCycle
    
    public init(with tableView: UITableView) {
        self.tableView = tableView
        self.adapter = BRTableAdapter(tableView: tableView)
        super.init(frame: .zero)
        setupLayout()
    }
    
    
    public init(style: UITableView.Style) {
        self.tableView = UITableView(frame: .zero, style: style)
        self.adapter = BRTableAdapter(tableView: tableView)
        super.init(frame: .zero)
        setupLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupLayout() {
        self.addSubview(tableView)
        
        layout.activate {
            tableView.br.top == self.br.top
            tableView.br.left == self.br.left
            tableView.br.right == self.br.right
            tableView.br.bottom == self.br.bottom
        }
    }
    
    
}
