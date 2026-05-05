//
//  BRViewController.swift
//  BRUIKit
//
//  Created by BR on 2025/6/28.
//

import UIKit


/// BRViewController 將 viewDidLoad 再次細分
///
/// - setupNavigationBar(): 導覽頁設定
/// - setupUI(): 風格、樣式設定
/// - setupLayout(): 添加子元件、排版設定
/// - setupEvent(): 按鈕事件、子元件的 closure
/// - bindViewModel(): 資料捆綁
open class BRViewController: UIViewController {
    
    private var lastViewBounds: CGRect = .zero
    
    public var onViewBoundsChanged: ((CGRect) -> Void)?
    
    // MARK: - Lifecycle
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupLayout()
        setupEvent()
        bindViewModel()
    }
    
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if lastViewBounds != view.bounds {
            lastViewBounds = view.bounds
            onViewLayoutSubviews()
            onViewBoundsChanged?(view.bounds)
        }
    }
    
    
    // MARK: - NavigationBar

    
    /// 導覽頁設定
    open func setupNavigationBar() {
        
    }

    
    // MARK: - UI
    
    
    /// 風格、樣式設定
    open func setupUI() {
        
    }
    
    
    /// 添加子元件、排版設定
    open func setupLayout() {
        
    }
    
    
    /// 當 view 完成佈局且尺寸發生變化時觸發
    open func onViewLayoutSubviews() {
        
    }
    
    
    // MARK: - Event
    
    
    /// 按鈕事件、子元件的 closure
    open func setupEvent() {
        
    }
    
    
    // MARK: - Data
    
    
    /// 資料捆綁
    open func bindViewModel() {
        
    }
    
    
}

