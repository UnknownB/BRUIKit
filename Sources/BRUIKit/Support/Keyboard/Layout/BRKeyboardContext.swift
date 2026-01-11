//
//  BRKeyboardContext.swift
//  BRUIKit
//
//  Created by BR on 2025/12/22.
//

import BRFoundation
import UIKit


/// 封裝鍵盤常用資訊
public struct BRKeyboardContext {
    public let frame: CGRect
    public let animationDuration: TimeInterval
    public let animationOptions: UIView.AnimationOptions

    init(_ sender: Notification) {
        let userInfo = sender.userInfo.br.or([:], missing: "[Keyboard] 無法取得 userInfo")
        let curve: UInt = userInfo.br.value(for: UIResponder.keyboardAnimationCurveUserInfoKey, or: 7, missing: "[Keyboard] 無法取得動畫彎度")
        frame = userInfo.br.value(for: UIResponder.keyboardFrameEndUserInfoKey, or: .zero, missing: "[Keyboard] 無法取得鍵盤尺寸")
        animationDuration = userInfo.br.value(for: UIResponder.keyboardAnimationDurationUserInfoKey, or: 0.25, missing: "[Keyboard] 無法取得動畫時間")
        animationOptions = UIView.AnimationOptions(rawValue: curve << 16)
    }
}
