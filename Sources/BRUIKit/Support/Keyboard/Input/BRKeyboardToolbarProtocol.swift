//
//  BRKeyboardToolbarProtocol.swift
//  BRUIKit
//
//  Created by BR on 2026/1/16.
//

import UIKit


@MainActor
public protocol BRKeyboardToolbarProtocol {
    

    /// 焦點元件的 inputAccessoryView
    var accessoryView: UIView { get }
    
    
    /// 在 toolbar 背景提供顏色遮罩
    var toolbarMaskView: UIView { get }
    
    
    /// 上一個焦點按鈕
    var prevButton: UIBarButtonItem { get }
    
    
    /// 下一個焦點按鈕
    var nextButton: UIBarButtonItem { get }
    
    
    /// 完成按鈕
    var doneButton: UIBarButtonItem { get }
    
    
    /// 取得焦點元件的 ViewController ，設定 toolbarMask 的外觀
    var onToolbarMaskChange: ((UIViewController) -> Void)? { get set }
    
    
    /// 綁定 prev、next 焦點元件
    func bind(prev: UIResponder?, next: UIResponder?)
    
    
    /// 取得目前頁面的 viewController 更新 ToolbarMask 外觀
    func updateToolbarMaskView(with activateViewController: UIViewController)
}
