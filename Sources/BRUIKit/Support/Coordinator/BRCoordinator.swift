//
//  BRCoordinator.swift
//  BRUIKit
//
//  Created by BR on 2025/6/17.
//

import UIKit
import BRFoundation


/// 遵守 `BRCoordinatorProtocol` 協定的核心 Coordinator
///
/// - 提供 4 個核心功能
///     - start(animated)：進入起始畫面
///     - goTo(step:animated:)：跳轉到指定步驟
///     - pushToNextStep(from)：跳下一頁
///     - makeViewController(for)：建立頁面
///
/// # Coordinator 範例
///
/// ``` swift
/// enum AuthStep: BRStepFlow {
///     case login
/// }
///
///
/// final class AuthCoordinator<AuthStep>: BRCoordinator {
///
///     override func makeViewController(for step: AuthStep) -> UIViewController {
///         switch step {
///             case .login:
///                 return LoginViewController(coordinator: self)
///         }
///     }
/// }
/// ```
///
/// # ViewController 範例
///
/// ``` swift
/// import BRUIKit
/// import UIKit
///
///
/// final class LoginViewController: BRViewController {
///
///     private let coordinator: BRCoordinator<AuthStep>
///
///     init(coordinator: BRCoordinator<AuthStep>) {
///         self.coordinator = coordinator
///         super.init(nibName: nil, bundle: nil)
///     }
///
///     @MainActor required init?(coder: NSCoder) {
///         fatalError("init(coder:) has not been implemented")
///     }
///
///     @objc private func onLoginTapped() {
///         // 讓 coordinator 跳到下個畫面
///         coordinator.pushToNextStep(from: .login)
///     }
///
/// }
/// ```
open class BRCoordinator<Step: BRStepFlow>: BRCoordinatorProtocol {
    
    public var navigationController: UINavigationController

    
    public required init() {
        self.navigationController = UINavigationController()
    }
    
    
    /// 開啟 coordinator 初始頁面
    open func start(animated: Bool = false) {
        goTo(step: .firstStep, animated: animated)
    }
    
    
    /// UINavigationController 將 viewControllers 調整成 `from` 到 `step`
    @discardableResult
    open func goTo(step: Step, animated: Bool = false) -> (any BRCoordinatorProtocol)? {
        let steps = Step.steps(from: Step.firstStep, to: step)
        let viewControllers = steps.map { makeViewController(for: $0) }
        navigationController.setViewControllers(viewControllers, animated: animated)
        return nil
    }
    
    
    /// push 指定 step
    open func pushTo(step: Step, animated: Bool = true) {
        let viewController = makeViewController(for: step)
        navigationController.pushViewController(viewController, animated: animated)
    }
    

    /// push 下一個 step
    open func pushToNextStep(from step: Step) {
        guard let nextStep = Step.nextStep(from: step) else {
            BRLog.printUI.info("No next step for \(step)")
            return
        }
        let viewController = makeViewController(for: nextStep)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    
    /// 自訂每一個步驟的頁面
    open func makeViewController(for step: Step) -> UIViewController {
        fatalError("Subclasses must override makeViewController(for:)")
    }
    
    
}


/// 遵守 `BRStepCoordinatorProtocol` 協定，支援單步驟跳轉流程
///
/// - 以 `BRCoordinator` 為基礎，加入 didFinishStep()
/// - 提供單流程的跳轉點、邏輯處理接口
///
/// # Coordinator 範例
///
/// ``` swift
/// enum AuthStep: BRStepFlow {
///     case login
/// }
///
/// // 使用 BRStepCoordinator
/// final class AuthCoordinator<AuthStep>: BRStepCoordinator {
///
///     override func makeViewController(for step: AuthStep) -> UIViewController {
///         switch step {
///             case .login:
///                 return LoginViewController(coordinator: self)
///         }
///     }
///
///     override func didFinishStep(_ step: AuthStep) {
///         // 為 step 自訂邏輯行為
///     }
/// }
/// ```
///
/// # ViewController 範例
///
/// ``` swift
/// import BRUIKit
/// import UIKit
///
///
/// final class LoginViewController: BRViewController {
///
///     private let coordinator: BRStepCoordinator<AuthStep>
///
///     init(coordinator: BRStepCoordinator<AuthStep>) {
///         self.coordinator = coordinator
///         super.init(nibName: nil, bundle: nil)
///     }
///
///     @MainActor required init?(coder: NSCoder) {
///         fatalError("init(coder:) has not been implemented")
///     }
///
///     @objc private func onLoginTapped() {
///         // 讓 coordinator 知道這步驟結束了
///         coordinator.didFinishStep(.login)
///     }
///
/// }
/// ```
open class BRStepCoordinator<Step: BRStepFlow>: BRCoordinator<Step>, BRStepCoordinatorProtocol {
    
    /// 自訂頁面完成後的跳轉行為
    open func didFinishStep(_ step: Step) {
        
    }
    
}


/// 遵守 `BREventCoordinatorProtocol` 協定，支援多事件跳轉流程
///
/// - 以 `BRCoordinator` 為基礎，加入 didFinishStep(_ , with event)
/// - 提供多流程的跳轉點、邏輯處理接口
///
/// # Coordinator 範例
///
/// ``` swift
/// enum AuthStep: BRStepFlow {
///     case login
/// }
///
/// // 增加 Event
/// enum AuthEvent: BRStepEvent {
///     case login
///     case signup
/// }
///
/// // 使用 BREventCoordinator
/// final class AuthCoordinator<AuthStep, AuthEvent>: BREventCoordinator {
///
///     override func makeViewController(for step: AuthStep) -> UIViewController {
///         switch step {
///             case .login:
///                 return LoginViewController(coordinator: self)
///         }
///     }
///
///     override func didFinishStep(_ step: AuthStep, with event: AuthEvent?) {
///         // 為 step 自訂邏輯行為
///         // 增加 event 做不同流程跳轉
///     }
/// }
/// ```
///
/// # ViewController 範例
///
/// ``` swift
/// import BRUIKit
/// import UIKit
///
///
/// final class LoginViewController: BRViewController {
///
///     private let coordinator: BREventCoordinator<AuthStep, AuthEvent>
///
///     init(coordinator: BREventCoordinator<AuthStep, AuthEvent>) {
///         self.coordinator = coordinator
///         super.init(nibName: nil, bundle: nil)
///     }
///
///     @MainActor required init?(coder: NSCoder) {
///         fatalError("init(coder:) has not been implemented")
///     }
///
///     @objc private func onLoginTapped() {
///         // 登入現有帳號
///         coordinator.didFinishStep(.login, with: .login)
///     }
///
///     @objc private func onSingupTapped() {
///         // 註冊新使用者
///         coordinator.didFinishStep(.login, with: .signup)
///     }
///
/// }
/// ```
open class BREventCoordinator<Step: BRStepFlow, StepEvent: BRStepEvent>: BRCoordinator<Step>, BREventCoordinatorProtocol {
        
    /// 自訂頁面完成後的跳轉行為
    open func didFinishStep(_ step: Step, with event: StepEvent?) {
        
    }
    
}
