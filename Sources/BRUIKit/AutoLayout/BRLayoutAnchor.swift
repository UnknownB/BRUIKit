//
//  BRLayoutAnchor.swift
//  BRUIKit
//
//  Created by BR on 2025/3/29.
//

import UIKit
import BRFoundation

/// BRLayoutAnchor - 提供以預算子設定 AutoLayout 的語法功能
///
/// - 限制
///     - 需使用 BRLayoutAnchor 替代 NSLayoutAnchor 建立約束
/// - 語法
///
/// ``` swift
/// // 系統原生
/// NSLayoutConstraint.activate([
///     button.bottomAnchor.constraint(equalToSystemSpacingBelow: view.bottomAnchor, multiplier: 0.8),
///     button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
///     button.widthAnchor.constraint(equalToConstant: 260),
///     button.heightAnchor.constraint(equalToConstant: 34),
/// ])
///
/// // 系統原生 + BRLayoutAnchor
/// NSLayoutConstraint.activate([
///     button.br.bottom == view.br.bottom * 0.8,
///     button.br.centerX == view.br.centerX,
///     button.br.width == 260,
///     button.br.height == 34,
/// ])
///
/// // BRLayout + BRLayoutAnchor
/// layout.activate {
///     button.br.bottom == view.br.bottom * 0.8
///     button.br.centerX == view.br.centerX
///     button.br.width == 260
///     button.br.height == 34
/// }
/// ```
public struct BRLayoutAnchor <AnchorType> {
    var item: AnyObject
    var attribute: NSLayoutConstraint.Attribute
    var constant: CGFloat
    var multiplier: CGFloat
    
    init(item: AnyObject, attribute: NSLayoutConstraint.Attribute, constant: CGFloat = 0, multiplier: CGFloat = 1) {
        self.item = item
        self.attribute = attribute
        self.constant = constant
        self.multiplier = multiplier
    }
}


extension BRWrapper where Base: UIView {
    
    public var top: BRLayoutAnchor<NSLayoutYAxisAnchor> {
        return BRLayoutAnchor.init(item: base, attribute: .top)
    }
    
    public var bottom: BRLayoutAnchor<NSLayoutYAxisAnchor> {
        return BRLayoutAnchor.init(item: base, attribute: .bottom)
    }
    
    public var left: BRLayoutAnchor<NSLayoutXAxisAnchor> {
        return BRLayoutAnchor.init(item: base, attribute: .left)
    }
    
    public var right: BRLayoutAnchor<NSLayoutXAxisAnchor> {
        return BRLayoutAnchor.init(item: base, attribute: .right)
    }
    
    public var leading: BRLayoutAnchor<NSLayoutXAxisAnchor> {
        return BRLayoutAnchor.init(item: base, attribute: .leading)
    }
    
    public var trailing: BRLayoutAnchor<NSLayoutXAxisAnchor> {
        return BRLayoutAnchor.init(item: base, attribute: .trailing)
    }
    
    public var centerX: BRLayoutAnchor<NSLayoutXAxisAnchor> {
        return BRLayoutAnchor.init(item: base, attribute: .centerX)
    }
    
    public var centerY: BRLayoutAnchor<NSLayoutYAxisAnchor> {
        return BRLayoutAnchor.init(item: base, attribute: .centerY)
    }
    
    public var width: BRLayoutAnchor<NSLayoutDimension> {
        return BRLayoutAnchor.init(item: base, attribute: .width)
    }
    
    public var height: BRLayoutAnchor<NSLayoutDimension> {
        return BRLayoutAnchor.init(item: base, attribute: .height)
    }
    
    public var firstBaseline: BRLayoutAnchor<NSLayoutYAxisAnchor> {
        return BRLayoutAnchor.init(item: base, attribute: .firstBaseline)
    }
    
    public var lastBaseline: BRLayoutAnchor<NSLayoutYAxisAnchor> {
        return BRLayoutAnchor.init(item: base, attribute: .lastBaseline)
    }
}


extension BRWrapper where Base: UILayoutGuide {
    public var top: BRLayoutAnchor<NSLayoutYAxisAnchor> {
        return BRLayoutAnchor.init(item: base, attribute: .top)
    }
    
    public var bottom: BRLayoutAnchor<NSLayoutYAxisAnchor> {
        return BRLayoutAnchor.init(item: base, attribute: .bottom)
    }
    
    public var left: BRLayoutAnchor<NSLayoutXAxisAnchor> {
        return BRLayoutAnchor.init(item: base, attribute: .left)
    }
    
    public var right: BRLayoutAnchor<NSLayoutXAxisAnchor> {
        return BRLayoutAnchor.init(item: base, attribute: .right)
    }
    
    public var leading: BRLayoutAnchor<NSLayoutXAxisAnchor> {
        return BRLayoutAnchor.init(item: base, attribute: .leading)
    }
    
    public var trailing: BRLayoutAnchor<NSLayoutXAxisAnchor> {
        return BRLayoutAnchor.init(item: base, attribute: .trailing)
    }
    
    public var centerX: BRLayoutAnchor<NSLayoutXAxisAnchor> {
        return BRLayoutAnchor.init(item: base, attribute: .centerX)
    }
    
    public var centerY: BRLayoutAnchor<NSLayoutYAxisAnchor> {
        return BRLayoutAnchor.init(item: base, attribute: .centerY)
    }
    
    public var width: BRLayoutAnchor<NSLayoutDimension> {
        return BRLayoutAnchor.init(item: base, attribute: .width)
    }
    
    public var height: BRLayoutAnchor<NSLayoutDimension> {
        return BRLayoutAnchor.init(item: base, attribute: .height)
    }
    
    public var firstBaseline: BRLayoutAnchor<NSLayoutYAxisAnchor> {
        return BRLayoutAnchor.init(item: base, attribute: .firstBaseline)
    }
    
    public var lastBaseline: BRLayoutAnchor<NSLayoutYAxisAnchor> {
        return BRLayoutAnchor.init(item: base, attribute: .lastBaseline)
    }
}
