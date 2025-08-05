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
    static func steps(from: Self, to: Self) -> [Self]
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
    
    
    /// 產生從起始步驟到終點步驟的步驟陣列
    ///
    /// - 參數:
    ///     - from: 起始步驟
    ///     - to: 終點步驟
    /// - 回傳
    ///     - 起始至終點的步驟列表，若順序不合法則回傳空陣列
    static func steps(from: Self, to: Self) -> [Self] {
        let cases = Array(allCases)
        let fromIndex = cases.firstIndex(of: from)!
        let toIndex = cases.firstIndex(of: to)!
        guard fromIndex <= toIndex else {
            return []
        }
        let steps = Array(cases[fromIndex...toIndex])
        return steps
    }


}


// MARK: - StepEvent


public protocol BRStepEvent: Equatable {}
