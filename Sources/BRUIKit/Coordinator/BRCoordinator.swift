//
//  BRCoordinator.swift
//  BRUIKit
//
//  Created by BR on 2025/6/17.
//

import UIKit
import BRFoundation


public class BRCoordinator<Step: BRStepFlow>: BRCoordinatorProtocol {
    
    public var rootViewController: UINavigationController

    
    public required init() {
        self.rootViewController = UINavigationController()
    }
    
    
    /// 讓 coordinator 出現在畫面上
    public func start() {
        
    }
    
    
    /// 導航到指定頁面
    public func goTo(step targetStep: Step, from startStep: Step = Step.firstStep) {
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
        rootViewController.setViewControllers(viewControllers, animated: false)
    }
    

    /// push 下一個 step
    public func pushToNextStep(from step: Step) {
        guard let nextStep = Step.nextStep(from: step) else {
            BRLog.printUI.info("No next step for \(step)")
            return
        }
        let viewController = makeViewController(for: nextStep)
        rootViewController.pushViewController(viewController, animated: true)
    }
    
    
    /// 自訂頁面完成後的跳轉行為
    public func didFinishStep(_ step: Step) {
        
    }

    
    /// 自訂每一個步驟的頁面
    public func makeViewController(for step: Step) -> UIViewController {
        fatalError("Subclasses must override makeViewController(for:)")
    }
    
    
}
