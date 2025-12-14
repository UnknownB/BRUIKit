//
//  BRTextFieldGroup.swift
//  BRUIKit
//
//  Created by BR on 2025/12/14.
//

import BRFoundation
import UIKit


open class BRTextFieldGroup: ObservableObject {

    public private(set) var textFields: [BRTextField] = []
    
    @Published public var isValid: Bool = false

    
    public init() {}

    
    @discardableResult
    public func add(_ textField: BRTextField) -> Self {
        textFields.append(textField)
        BRTask.bind(to: textField.$fieldState, on: self) { _ in
            self.updateValidState()
        }
        return self
    }
    
    
    private func updateValidState() {
        isValid = textFields.allSatisfy({$0.isValid})
    }
}
