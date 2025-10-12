//
//  BRJSAlertData.swift
//  BRUIKit
//
//  Created by BR on 2025/10/9.
//

import WebKit


public struct BRJSAlertData {
    public let message: String
    public let frame: WKFrameInfo
}


public struct BRJSConfirmData {
    public let message: String
    public let frame: WKFrameInfo
}


public struct BRJSPromptData {
    public let message: String
    public let defaultText: String?
    public let frame: WKFrameInfo
}
