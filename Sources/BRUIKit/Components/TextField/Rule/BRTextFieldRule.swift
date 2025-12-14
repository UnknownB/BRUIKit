//
//  BRFieldRule.swift
//  BRUIKit
//
//  Created by BR on 2025/12/4.
//

import BRFoundation
import UIKit


public class BRTextFieldRule {
    
    public typealias Constraint = (String?) async throws -> Status
        
    public enum Status {
        case none
        case success
        case failed
    }
    
    public enum Event {
        case begin
        case change
        case end
    }
    
    public let textField: BRTextField
    public let events: [Event]
    private let constraint: Constraint
    public private(set) var status: Status = .none
    
    public var title: String?
    public var hint: String?
    public var onBeging: ((BRTextField) -> Void)?
    public var onComplete: ((BRTextField) -> Void)?
    
    
    // MARK: - Init

    
    public init(textField: BRTextField, events: [Event], constraint: @escaping Constraint) {
        self.textField = textField
        self.events = events
        self.constraint = constraint
    }
    
    
    @discardableResult
    public func title(_ text: String?) -> Self {
        self.title = text
        return self
    }
    
    
    @discardableResult
    public func hint(_ text: String?) -> Self {
        self.hint = text
        return self
    }
    
    
    @discardableResult
    public func onBeging(_ handler: ((BRTextField) -> Void)?) -> Self {
        self.onBeging = handler
        return self
    }
    

    @discardableResult
    public func onComplete(_ handler: ((BRTextField) -> Void)?) -> Self {
        self.onComplete = handler
        return self
    }
    
    
    // MARK: - API
    
    
    @MainActor
    @discardableResult
    public func validate() async -> Status {
        onBeging?(textField)
        do {
            let text = textField.text
            status = try await constraint(text)
        } catch {
            #BRLog(.library, .error, "TextField 驗證異常終止: \(error)")
            status = .failed
        }
        
        onComplete?(textField)
        return status
    }
    
    
    // MARK: - 快速建立

    
    /// 必填
    public static func required(with textField: BRTextField, events: [Event]) -> BRTextFieldRule {
        BRTextFieldRule(textField: textField, events: events) {
            $0?.isEmpty ?? true ? .failed : .success
        }
    }
    
    
    /// 最小長度
    public static func min(with textField: BRTextField, events: [Event], length: Int) -> BRTextFieldRule {
        BRTextFieldRule(textField: textField, events: events) {
            $0?.count ?? 0 < length ? .failed : .success
        }
    }
    
    
    /// 最大長度
    public static func max(with textField: BRTextField, events: [Event], length: Int) -> BRTextFieldRule {
        BRTextFieldRule(textField: textField, events: events) {
            $0?.count ?? 0 > length ? .failed : .success
        }
    }
    
    
    /// 正規表示法
    public static func regex(with textField: BRTextField, events: [Event], pattern: String) -> BRTextFieldRule {
        let regex = try? NSRegularExpression(pattern: pattern)
        return BRTextFieldRule(textField: textField, events: events) {
            guard let regex else { return .failed }
            guard let text = $0 else { return .failed }
            let range = NSRange(text.startIndex..., in: text)
            return (regex.firstMatch(in: text, range: range) != nil) ? .success : .failed
        }
    }
    
    
}

