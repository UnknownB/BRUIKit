//
//  BRStepFlow.swift
//  BRUIKit
//
//  Created by BR on 2025/6/17.
//

import Foundation


/// 提供 「步驟流程 (Step)」 的基礎 `protocol`
///
/// - 適用於遵守 `CaseIterable`、`Equatable` 的 `enum`
/// - 實作擴展：
///    - 取得第一步
///    - 取得當前步驟的下一步
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
/// let first = LoginStep.firstStep // .login
/// let next = LoginStep.nextStep(from: .login) // .verify
/// ```
public protocol BRStepFlow: CaseIterable, Equatable {
    static var firstStep: Self { get }
    static func nextStep(from step: Self) -> Self?
}


public extension BRStepFlow {
    
    
    /// 流程中的第一個步驟
    static var firstStep: Self {
        return allCases.first!
    }
    
    
    /// 根據目前步驟推導下一個步驟
    ///
    /// - 參數
    ///     - step: 當前的步驟
    /// - 回傳
    ///     - 下一個步驟，若為最後一步則回傳 `nil`
    static func nextStep(from step: Self) -> Self? {
        let cases = Array(allCases)
        guard let index = cases.firstIndex(of: step), index + 1 < cases.count else {
            return nil
        }
        return cases[index + 1]
    }


}


// MARK: - StepEvent


public protocol BRStepEvent: Equatable {}
