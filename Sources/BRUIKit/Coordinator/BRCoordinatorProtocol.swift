//
//  BRCoordinatorProtocol.swift
//  BRUIKit
//
//  Created by BR on 2025/6/17.
//

import UIKit
import BRFoundation


@MainActor
public protocol BRCoordinatorProtocol: AnyObject {
    associatedtype Step: BRStepFlow

    var rootViewController: UINavigationController { get set }

    init()
    
    func start()
    func goTo(step targetStep: Step, from startStep: Step)
    func pushToNextStep(from step: Step)
    func didFinishStep(_ step: Step)
    func makeViewController(for step: Step) -> UIViewController
}
