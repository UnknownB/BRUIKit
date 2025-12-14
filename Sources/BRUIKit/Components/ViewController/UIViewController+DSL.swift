//
//  UIViewController+DSL.swift
//  BRUIKit
//
//  Created by BR on 2025/12/11.
//

import BRFoundation
import UIKit


@MainActor
public extension BRWrapper where Base: UIViewController {
    
    
    /// 設定 NavigationController Title
    @MainActor
    @discardableResult
    func title(_ text: String?) -> Base {
        base.title = text
        return base
    }
    
    
    /// 設定是否隱藏 navigationBar
    @MainActor
    @discardableResult
    func navigationBarHidden(_ hidden: Bool, animated: Bool) -> Base {
        base.navigationController?.setNavigationBarHidden(hidden, animated: animated)
        return base
    }
    
    
    // MARK: - 子元件
    
    
    /// 新增子 UIViewController 並加入到當前控制器
    @MainActor
    @discardableResult
    func addChild(_ child: UIViewController) -> Base {
        base.addChild(child)
        base.view.addSubview(child.view)
        child.didMove(toParent: base)
        return base
    }
    
    
    /// 移除子 UIViewController
    @MainActor
    @discardableResult
    func removeChild(_ child: UIViewController) -> Base {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
        return base
    }
    
    
    // MARK: - modal / presentation
    
    
    /// 設定 modalPresentationStyle
    @MainActor
    @discardableResult
    func modalPresentationStyle(_ style: UIModalPresentationStyle) -> Base {
        base.modalPresentationStyle = style
        return base
    }
    
    
    /// 設定 modalTransitionStyle
    @MainActor
    @discardableResult
    func modalTransitionStyle(_ style: UIModalTransitionStyle) -> Base {
        base.modalTransitionStyle = style
        return base
    }
    
    
    // MARK: - 隱藏 / 顯示
    
    
    /// 設定推入時是否隱藏底部 TabBar
    @MainActor
    @discardableResult
    func hidesBottomBarWhenPushed(_ hide: Bool) -> Base {
        base.hidesBottomBarWhenPushed = hide
        return base
    }
    
    
    /// 更新狀態列外觀，通常搭配 override var preferredStatusBarStyle 使用
    @MainActor
    @discardableResult
    func setNeedsStatusBarAppearanceUpdate() -> Base {
        base.setNeedsStatusBarAppearanceUpdate()
        return base
    }
    
    
    // MARK: - 自訂配置
    
    
    @MainActor
    @discardableResult
    func configure(_ closure: @escaping (Base) -> Void) -> Base {
        closure(base)
        return base
    }

    
}
