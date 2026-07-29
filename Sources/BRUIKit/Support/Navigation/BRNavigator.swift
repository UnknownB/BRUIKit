//
//  BRNavigator.swift
//  BRUIKit
//
//  Created by BR on 2026/7/2.
//

import UIKit


/// 包裝 `UINavigationController`，避免連續觸發造成重複跳轉
///
/// # 範例
///
/// ``` swift
/// enum Router {
///     enum Auth {
///         private static let nav = BRNavigator()
///
///         static func start() {
///             let navigationController = UINavigationController(rootViewController: LoginViewController())
///             nav.attach(navigationController)
///         }
///
///         static func goToSignUp() {
///             nav.push(SignUpViewController())
///         }
///     }
/// }
/// ```
@MainActor
public final class BRNavigator {

    public private(set) weak var navigationController: UINavigationController?
    private var isTransitioning = false


    public init() {}


    public func attach(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }


    public func detach() {
        navigationController = nil
    }
    

    public func push(_ viewController: UIViewController, animated: Bool = true) {
        run(animated: animated) {
            $0.pushViewController(viewController, animated: animated)
            return true
        }
    }


    public func setViewControllers(_ viewControllers: [UIViewController], animated: Bool = true) {
        run(animated: animated) {
            $0.setViewControllers(viewControllers, animated: animated)
            return true
        }
    }
    
    
    public func pop(animated: Bool = true) {
        run(animated: animated) { $0.popViewController(animated: animated) != nil }
    }
    
    
    public func popToRoot(animated: Bool = true) {
        run(animated: animated) { $0.popToRootViewController(animated: animated) != nil }
    }
    
    
    public func popTo(_ type: UIViewController.Type, animated: Bool = true) {
        run(animated: animated) { navigationController in
            guard let target = navigationController.viewControllers.last(where: { $0.isKind(of: type) }) else { return false }
            navigationController.popToViewController(target, animated: animated)
            return true
        }
    }


    /// - Parameter operation: 回傳是否真的觸發了跳轉，`false` 代表沒有變化，不需等待轉場
    private func run(animated: Bool, _ operation: (UINavigationController) -> Bool) {
        guard !isTransitioning, let navigationController else { return }
        isTransitioning = true

        guard operation(navigationController) else {
            isTransitioning = false
            return
        }

        guard animated, let coordinator = navigationController.transitionCoordinator else {
            isTransitioning = false
            return
        }
        coordinator.animate(alongsideTransition: nil) { [weak self] _ in
            self?.isTransitioning = false
        }
    }


}
