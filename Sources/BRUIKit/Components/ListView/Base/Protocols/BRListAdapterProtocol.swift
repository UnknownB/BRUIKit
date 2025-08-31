//
//  BRListAdapterProtocol.swift
//  BRUIKit
//
//  Created by BR on 2025/8/25.
//

import UIKit


@MainActor
public protocol BRListAdapterProtocol: AnyObject {
    
    func update(list: BRList, animated: Bool)

    var didSelectRow: ((IndexPath, BRRow) -> Void)? { get set }
    var didMoveRow: ((IndexPath, IndexPath, BRRow) -> Void)? { get set }
}
