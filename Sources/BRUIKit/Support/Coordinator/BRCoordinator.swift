//
//  BRCoordinator.swift
//  BRUIKit
//
//  Created by BR on 2025/6/17.
//

import UIKit
import BRFoundation


/// 遵守 `BRCoordinatorProtocol` 協定的單流程 Coordinator
///
/// - 最基本的核心物件，提供 4 個基本功能
///     - start()：起始設定
///     - goTo(step, from)：從指定步驟持續堆疊頁面
///     - pushToNextStep(from)：跳下一頁
///     - makeViewController(for)：建立頁面
///
/// # 範例
///
/// ``` swift
/// enum LoginStep: BRStepFlow {
///     case login
///     case verify
///     case completed
/// }
///
/// final class LoginCoordinator<LoginStep>: BRCoordinator {
///
///     override
/// }
/// ```
open class BRCoordinator<Step: BRStepFlow>: BRCoordinatorProtocol {
    
    public var navigationController: UINavigationController

    
    public required init() {
        self.navigationController = UINavigationController()
    }
    
    
    /// 讓 coordinator 出現在畫面上
    open func start(step: Step = .firstStep) {
        
    }
    
    
    /// UINavigationController 將 viewControllers 調整成 `from` 到 `step`
    open func goTo(step targetStep: Step, from startStep: Step = Step.firstStep) {
        var viewControllers: [UIViewController] = []
        var currentStep: Step? = startStep
        while let step = currentStep {
            let vc = makeViewController(for: step)
            viewControllers.append(vc)
            if step == targetStep {
                break
            }
            currentStep = Step.nextStep(from: step)
        }
        navigationController.setViewControllers(viewControllers, animated: false)
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


/// 以 `BRCoordinator` 為基礎，加入 didFinishStep()
///
/// - 提供單流程的跳轉點、邏輯處理接口
open class BRStepCoordinator<Step: BRStepFlow>: BRCoordinator<Step>, BRStepCoordinatorProtocol {
    
    /// 自訂頁面完成後的跳轉行為
    open func didFinishStep(_ step: Step) {
        
    }
    
}


/// 以 `BRCoordinator` 為基礎，加入 didFinishStep(_ , with event)
///
/// - 提供多流程的跳轉點、邏輯處理接口
open class BREventCoordinator<Step: BRStepFlow, StepEvent: BRStepEvent>: BRCoordinator<Step>, BREventCoordinatorProtocol {
        
    /// 自訂頁面完成後的跳轉行為
    open func didFinishStep(_ step: Step, with event: StepEvent?) {
        
    }
    
}
