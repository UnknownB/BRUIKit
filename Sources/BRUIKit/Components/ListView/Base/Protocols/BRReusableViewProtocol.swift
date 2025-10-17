//
//  BRCellReusableViewProtocol.swift
//  BRUIKit
//
//  Created by BR on 2025/8/21.
//

import Foundation


@MainActor
public protocol BRReusableViewProtocol: AnyObject, Sendable {
    var title: String? { get set }
    init()
}
