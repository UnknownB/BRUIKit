//
//  BRViewControllerBuilder.swift
//  BRUIKit
//
//  Created by BR on 2025/8/28.
//

import UIKit


@resultBuilder
public enum BRViewControllerBuilder {
    public static func buildBlock(_ components: [UIViewController]...) -> [UIViewController] {
        components.flatMap { $0 }
    }
    
    public static func buildExpression(_ expr: UIViewController) -> [UIViewController] {
        [expr]
    }
    
    public static func buildExpression(_ expr: [UIViewController]) -> [UIViewController] {
        expr
    }
    
    public static func buildArray(_ components: [[UIViewController]]) -> [UIViewController] {
        components.flatMap { $0 }
    }
    
    public static func buildOptional(_ component: [UIViewController]?) -> [UIViewController] {
        component ?? []
    }
    
    public static func buildEither(first component: [UIViewController]) -> [UIViewController] {
        component
    }
    
    public static func buildEither(second component: [UIViewController]) -> [UIViewController] {
        component
    }
}

