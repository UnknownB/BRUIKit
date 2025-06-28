//
//  NSLayout+DSL.swift
//  BRUIKit
//
//  Created by BR on 2025/3/29.
//

import UIKit


public func * <T>(multipier: CGFloat, anchor: BRLayoutAnchor<T>) -> BRLayoutAnchor<T> {
    var builder = anchor
    builder.multiplier *= multipier
    return builder
}


public func * <T>(anchor: BRLayoutAnchor<T>, multipier: CGFloat) -> BRLayoutAnchor<T> {
    var builder = anchor
    builder.multiplier *= multipier
    return builder
}


public func + <T>(anchor: BRLayoutAnchor<T>, constant: CGFloat) -> BRLayoutAnchor<T> {
    var builder = anchor
    builder.constant += constant
    return builder
}


public func - <T>(anchor: BRLayoutAnchor<T>, constant: CGFloat) -> BRLayoutAnchor<T> {
    var builder = anchor
    builder.constant -= constant
    return builder
}


@MainActor public func == <T>(lhs: BRLayoutAnchor<T>, rhs: BRLayoutAnchor<T>) -> NSLayoutConstraint {
    return NSLayoutConstraint.init(item: lhs.item,
                                   attribute: lhs.attribute,
                                   relatedBy: .equal,
                                   toItem: rhs.item,
                                   attribute: rhs.attribute,
                                   multiplier: rhs.multiplier / lhs.multiplier,
                                   constant: rhs.constant - lhs.constant)
}


@MainActor public func >= <T>(lhs: BRLayoutAnchor<T>, rhs: BRLayoutAnchor<T>) -> NSLayoutConstraint {
    return NSLayoutConstraint.init(item: lhs.item,
                                   attribute: lhs.attribute,
                                   relatedBy: .greaterThanOrEqual,
                                   toItem: rhs.item,
                                   attribute: rhs.attribute,
                                   multiplier: rhs.multiplier / lhs.multiplier,
                                   constant: rhs.constant - lhs.constant)
}


@MainActor public func <= <T>(lhs: BRLayoutAnchor<T>, rhs: BRLayoutAnchor<T>) -> NSLayoutConstraint {
    return NSLayoutConstraint.init(item: lhs.item,
                                   attribute: lhs.attribute,
                                   relatedBy: .lessThanOrEqual,
                                   toItem: rhs.item,
                                   attribute: rhs.attribute,
                                   multiplier: rhs.multiplier / lhs.multiplier,
                                   constant: rhs.constant - lhs.constant)
}


@MainActor public func == <T>(lhs: BRLayoutAnchor<T>, rhs: CGFloat) -> NSLayoutConstraint {
    return NSLayoutConstraint.init(item: lhs.item,
                                   attribute: lhs.attribute,
                                   relatedBy: .equal,
                                   toItem: nil,
                                   attribute: lhs.attribute,
                                   multiplier: 1,
                                   constant: rhs)
}


@MainActor public func >= <T>(lhs: BRLayoutAnchor<T>, rhs: CGFloat) -> NSLayoutConstraint {
    return NSLayoutConstraint.init(item: lhs.item,
                                   attribute: lhs.attribute,
                                   relatedBy: .greaterThanOrEqual,
                                   toItem: nil,
                                   attribute: lhs.attribute,
                                   multiplier: 1,
                                   constant: rhs)
}


@MainActor public func <= <T>(lhs: BRLayoutAnchor<T>, rhs: CGFloat) -> NSLayoutConstraint {
    return NSLayoutConstraint.init(item: lhs.item,
                                   attribute: lhs.attribute,
                                   relatedBy: .lessThanOrEqual,
                                   toItem: nil,
                                   attribute: lhs.attribute,
                                   multiplier: 1,
                                   constant: rhs)
}
