//
//  BRPageViewController.swift
//  BRUIKit
//
//  Created by BR on 2025/8/29.
//

import UIKit


open class BRPageViewController: UIViewController {
    
    private let layout = BRLayout()
    
    private var pageViewController: UIPageViewController
    
    public let adapter: BRPageViewAdapter
    
    
    public var isDoubleSided: Bool {
        didSet {
            guard oldValue != isDoubleSided else {
                return
            }
            rebuildPageViewController()
        }
    }
    
    
    public var transitionStyle: UIPageViewController.TransitionStyle {
        didSet {
            guard oldValue != transitionStyle else {
                return
            }
            rebuildPageViewController()
        }
    }
    
    
    public var navigationOrientation: UIPageViewController.NavigationOrientation {
        didSet {
            guard oldValue != navigationOrientation else {
                return
            }
            rebuildPageViewController()
        }
    }
    
    
    // MARK: - LifeCycle
    
    
    public init(transitionStyle: UIPageViewController.TransitionStyle = .scroll, navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal, isDoubleSided: Bool = false) {
        self.pageViewController = UIPageViewController(transitionStyle: transitionStyle, navigationOrientation: navigationOrientation)
        self.pageViewController.isDoubleSided = isDoubleSided
        self.transitionStyle = transitionStyle
        self.navigationOrientation = navigationOrientation
        self.isDoubleSided = isDoubleSided
        self.adapter = BRPageViewAdapter(with: pageViewController)
        super.init(nibName: nil, bundle: nil)
        setupLayout()
    }
    
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func rebuildPageViewController() {
        let oldPageVC = pageViewController
        
        let newPageVC = UIPageViewController(transitionStyle: transitionStyle, navigationOrientation: navigationOrientation)
        newPageVC.isDoubleSided = isDoubleSided
        adapter.pageViewController = newPageVC
        
        addChild(newPageVC)
        transition(from: oldPageVC, to: newPageVC, duration: 0.25, options: [.transitionCrossDissolve]) { [weak self] in
            oldPageVC.removeFromParent()
            newPageVC.didMove(toParent: self)
            self?.pageViewController = newPageVC
            self?.setupLayout()
        }
    }
    
    
    private func setupLayout() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
                
        layout.activate {
            pageViewController.view.br.top == view.br.top
            pageViewController.view.br.left == view.br.left
            pageViewController.view.br.right == view.br.right
            pageViewController.view.br.bottom == view.br.bottom
        }

        pageViewController.didMove(toParent: self)
    }
    
    
}
