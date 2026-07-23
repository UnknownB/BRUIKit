//
//  BRKeyboardToolbarConfig.swift
//  BRUIKit
//
//  Created by BR on 2026/7/21.
//

import UIKit


/// 單一焦點元件的鍵盤工具列客製化設定
public class BRKeyboardToolbarConfig {

    public var onPrev: ((_ prevView: UIResponder?) -> Void)? = nil
    public var onNext: ((_ nextView: UIResponder?) -> Void)? = nil
    public var onDone: (() -> Void)? = nil
    
    public var hiddenPrevNext: Bool? = nil

    /// 額外控制項，放在 prev/next 與 done 之間的可水平滾動區域，超出寬度時可滾動檢視
    public var additionalItems: [UIView] = []

    public init() {
    }
}
