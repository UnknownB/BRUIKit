//
//  BRPageViewAdapter.swift
//  BRUIKit
//
//  Created by BR on 2025/8/28.
//

import UIKit


@MainActor
public final class BRPageViewAdapter: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
        
    private enum SpineState {
        case notSet
        case ready
    }
    

    private var needAnimate: Bool? = nil

    private var hasInsertBlankPage: Bool = false

    
    /// 是否允許開書模式（雙頁）
    public private(set) var isDoubleSided: Bool = false
    
    
    public private(set) var list = BRPageList {}
    
    
    public private(set) var currentIndex: Int = 0
    
    
    /// 是否允許循環翻頁
    public var isPagingLoopEnabled: Bool = false
    
    
    /// 是否顯示內建的頁面控制器
    public var isShowPageControl: Bool = false
    
    
    /// 監聽當前頁面變化
    public var didChangePage: ((Int, UIViewController) -> Void)?
    
    
    /// 書本模式設定完成
    public var didSetSpineState: (() -> Void)?
    
    
    private var spineState: SpineState = .notSet {
        didSet {
            if case .ready = spineState {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) { [self] in
                    self.didSetSpineState?()
                }
            }
        }
    }
    
    
    public weak var pageViewController: UIPageViewController? {
        didSet {
            configurePageViewController()
            
            // 需要小延遲才能正確顯示第一頁
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [self] in
                goToPage(index: currentIndex, animated: false)
            }
        }
    }
    
    
    /// 提供空白頁（預設透明背景）
    public var blankPageProvider: () -> UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        return vc
    }
    
        
    // MARK: - Init
    
    
    public init(with pageViewController: UIPageViewController) {
        self.pageViewController = pageViewController
        super.init()
        configurePageViewController()
    }
    
    
    private func configurePageViewController() {
        pageViewController?.delegate = self
        pageViewController?.dataSource = self
        spineState = pageViewController?.transitionStyle == .scroll ? .ready : .notSet
    }
    
    
    // MARK: - DSL
    
    
    @discardableResult
    public func isPagingLoopEnabled(_ isPagingLoopEnabled: Bool) -> Self {
        self.isPagingLoopEnabled = isPagingLoopEnabled
        return self
    }
    
    
    // MARK: -
    
    
    /// 更新頁面陣列
    public func setPages(startAt index: Int = 0, animated: Bool = false, list: BRPageList) {
        self.list = list
        currentIndex = index
        goToPage(index: index, animated: animated)
    }
    
    
    /// 切換到指定頁面
    public func goToPage(index: Int, animated: Bool = true) {
        guard case .ready = spineState else {
            needAnimate = animated
            return
        }
                
        guard let pageVC = pageViewController,
              (0..<list.pages.count).contains(index) else {
            return
        }
                
        let direction: UIPageViewController.NavigationDirection = (index >= currentIndex) ? .forward : .reverse
        let viewControllers = makeViewControllers(for: index)
        let animated = needAnimate ?? animated
        needAnimate = nil
        
        pageVC.setViewControllers(viewControllers, direction: direction, animated: animated) { [self] _ in
            currentIndex = index
            didChangePage?(index, list.pages[index])
        }
    }
    
    
    // MARK: - DataSource
    
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = list.pages.firstIndex(of: viewController) else {
            return nil
        }
        if index == 0 {
            return isPagingLoopEnabled ? list.pages.last : nil
        }
        return list.pages[index - 1]
    }
    
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = list.pages.firstIndex(of: viewController) else {
            return nil
        }
        if index == list.pages.count - 1 {
            return isPagingLoopEnabled ? list.pages.first : nil
        }
        return list.pages[index + 1]
    }
    
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        isShowPageControl ? list.pages.count : 0
    }
    
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        isShowPageControl ? currentIndex : 0
    }
    
    
    // MARK: - Delegate
    
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentVC = pageViewController.viewControllers?.first,
           let index = list.pages.firstIndex(of: currentVC) {
            currentIndex = index
            didChangePage?(index, currentVC)
        }
    }
    
    
    public func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewController.SpineLocation {
        
        spineState = .ready
        
        if pageViewController.isDoubleSided && pageViewController.transitionStyle == .pageCurl {
            isDoubleSided = true
            if list.pages.count.isMultiple(of: 2) == false {
                list.pages.append(blankPageProvider())
                hasInsertBlankPage = true
            }
            goToPage(index: currentIndex)
            return .mid
        } else {
            isDoubleSided = false
            if hasInsertBlankPage {
                list.pages.removeLast()
                hasInsertBlankPage = false
            }
            goToPage(index: currentIndex, animated: false)
            return .min
        }
    }
    
    
    // MARK: - Helpers
    
    
    private func makeViewControllers(for index: Int) -> [UIViewController] {
        guard isDoubleSided else {
            return [list.pages[index]]
        }
        if index.isMultiple(of: 2) {
            let second = (index + 1 < list.pages.count) ? list.pages[index + 1] : blankPageProvider()
            return [list.pages[index], second]
        } else {
            let first = (index - 1 > 0) ? list.pages[index - 1] : blankPageProvider()
            return [first, list.pages[index]]
        }
    }
    
        
}
