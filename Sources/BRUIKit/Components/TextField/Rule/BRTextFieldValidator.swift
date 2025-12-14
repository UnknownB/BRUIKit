//
//  BRFieldValidator.swift
//  BRUIKit
//
//  Created by BR on 2025/12/4.
//

import BRFoundation
import UIKit


public final class BRTextFieldValidator {
    
    private var beginTask: Task<Void, Never>?
    private var changeTask: Task<Void, Never>?
    private var endTask: Task<Void, Never>?
    private var validateAllTask: Task<Void, Never>?


    init() {}
    
    
    @MainActor func onBeging(with rules: [BRTextFieldRule], completion: @escaping () -> Void) {
        beginTask?.cancel()
        beginTask = BRTask.run(operation: {
            try await self.runValidation(rules: rules, event: .begin)
        }, onSuccess: { _ in
            completion()
        })
    }

    
    @MainActor func onChange(with rules: [BRTextFieldRule], debounce: TimeInterval, completion: @escaping () -> Void) {
        changeTask?.cancel()
        changeTask = BRTask.run(operation: {
            try await Task.sleep(nanoseconds: UInt64(debounce * 1_000_000_000))
            try await self.runValidation(rules: rules, event: .change)
        }, onSuccess: { _ in
            completion()
        })
    }

    
    @MainActor func onEnd(with rules: [BRTextFieldRule], completion: @escaping () -> Void) {
        endTask?.cancel()
        endTask = BRTask.run(operation: {
            try await self.runValidation(rules: rules, event: .end)
        }, onSuccess: { _ in
            completion()
        })
    }
    
    
    @MainActor func validateAll(with rules: [BRTextFieldRule], completion: @escaping () -> Void) {
        validateAllTask?.cancel()
        validateAllTask = BRTask.run(operation: {
            for rule in rules {
                await rule.validate()
                try Task.checkCancellation()
            }
        }, onSuccess: {
            completion()
        })
    }
    
    
    @MainActor private func runValidation(rules: [BRTextFieldRule], event: BRTextFieldRule.Event) async throws {
        for rule in rules where rule.events.contains(event) {
            await rule.validate()
            try Task.checkCancellation()
        }
    }
    
    
}
