//
//  BRKeyboardSession.swift
//  BRUIKit
//
//  Created by BR on 2026/1/2.
//

import BRFoundation
import UIKit


/// 封裝單次焦點響應資訊
public struct BRKeyboardSession {
    
    /// 獲得焦點的輸入框
    public let responder: UIView
    
    
    /// 輸入框獲得焦點時，響應鏈中的頂層 ViewController
    public let viewController: UIViewController

    
    /// 調整排版的容器
    public let containerView: UIView
    
        
    public init(responder: UIView, viewController: UIViewController, containerView: UIView) {
        self.responder = responder
        self.viewController = viewController
        self.containerView = containerView
    }
}
