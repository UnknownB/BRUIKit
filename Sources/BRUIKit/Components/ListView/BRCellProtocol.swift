//
//  BRCellProtocol.swift
//  BRUIKit
//
//  Created by BR on 2025/8/15.
//

@MainActor
public protocol BRCellProtocol {
    associatedtype Model
    func bind(with model: Model)
}
