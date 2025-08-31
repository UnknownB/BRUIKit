//
//  BRPageList.swift
//  BRUIKit
//
//  Created by BR on 2025/8/29.
//

import UIKit


public struct BRPageList {
    public var pages: [UIViewController]

    public init(@BRViewControllerBuilder _ builder: () -> [UIViewController]) {
        self.pages = builder()
    }
}
