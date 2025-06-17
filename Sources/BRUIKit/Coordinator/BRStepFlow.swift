//
//  BRStepFlow.swift
//  BRUIKit
//
//  Created by BR on 2025/6/17.
//

import Foundation


public protocol BRStepFlow: CaseIterable, Equatable {
    static var firstStep: Self { get }
    static func nextStep(from step: Self) -> Self?
}


public extension BRStepFlow {
    
    
    static var firstStep: Self {
        return allCases.first!
    }
    
    
    static func nextStep(from step: Self) -> Self? {
        let cases = Array(allCases)
        guard let index = cases.firstIndex(of: step), index + 1 < cases.count else {
            return nil
        }
        return cases[index + 1]
    }


}
