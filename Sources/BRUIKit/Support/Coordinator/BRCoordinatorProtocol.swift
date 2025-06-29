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

    var navigationController: UINavigationController { get set }

    init()
    
    func start()
    func goTo(step targetStep: Step, from startStep: Step)
    func pushToNextStep(from step: Step)
    func makeViewController(for step: Step) -> UIViewController
}


@MainActor
public protocol BRStepCoordinatorProtocol: BRCoordinatorProtocol {
    func didFinishStep(_ step: Step)
}


@MainActor
public protocol BREventCoordinatorProtocol: BRCoordinatorProtocol {
    associatedtype StepEvent: BRStepEvent

    func didFinishStep(_ step: Step, with event: StepEvent?)
}
