// The Swift Programming Language
// https://docs.swift.org/swift-book

@_exported import UIKit
import BRFoundation

extension UIView: @retroactive BRWrapperProtocol {}
extension UIViewController: @retroactive BRWrapperProtocol {}
extension UILayoutGuide: @retroactive BRWrapperProtocol {}
extension NSLayoutConstraint: @retroactive BRWrapperProtocol {}

extension UIImage: @retroactive BRWrapperProtocol {}
extension UIColor: @retroactive BRWrapperProtocol {}
extension UIFont: @retroactive BRWrapperProtocol {}
extension UITableView: @retroactive BRWrapperProtocol {}

extension NSTextAlignment: @retroactive BRWrapperProtocol {}
