//
//  BRAlertController.swift
//  BRUIKit
//
//  Created by BR on 2026/8/25.
//

import UIKit


public protocol BRAlertControllerDSL: AnyObject {
}


/// BRAlertController 提供仿系統 Alert、Sheet 兩種顯示風格的核心框架，透過繼承複寫來客製化風格
open class BRAlertController: BRViewController, BRAlertControllerDSL {
    
    public enum Style {
        case alert
        case sheet
    }
    
    public enum ButtonLayout {
        case horizontal(doneMultiple: CGFloat = 1)
        case vertical
    }
    
    public let layout = BRLayout()
    
    private lazy var sheet = Sheet(alert: self)
    
    private var doneWidthConstraint: NSLayoutConstraint?
    
    
    // MARK: - 設定
    
    
    public var style: Style = .alert
    public var dimAlpha = 0.4
    public var dimColor: UIColor { UIColor.black.withAlphaComponent(dimAlpha) }
    
    public var isEnableClose: Bool = false
    
    public var titleText: String = ""
    public var message: String? = nil
    public var cancelTitle: String? = nil
    public var doneTitle: String? = nil
    
    public var buttonLayout: ButtonLayout = .horizontal()
    public var buttonHeight: CGFloat = 44
    
    public var onDone: ((BRAlertController) -> Void)? = nil
    public var onCancel: ((BRAlertController) -> Void)? = nil
    public var onClose: ((BRAlertController) -> Void)? = nil
    
    
    // MARK: - UI元件
    
    
    public let alertStack = UIStackView()
        .br.theme {
            $0.br.backgroundColor(.secondarySystemBackground)
        }
    
    
    public lazy var closeButton = UIButton()
        .br.image(UIImage(systemName: "xmark"))
        .br.addTarget(self, action: #selector(onCloseTapped))
    
    
    public let dragBar = UIView()
        .br.cornerRadius(2)
        .br.backgroundColor(.secondaryLabel)
    
    
    public let topStack = UIStackView()
        .br.backgroundColor(.clear)
    
    
    public let navStack = UIStackView()
        .br.backgroundColor(.clear)
    
    
    public let titleLabel = BRLabel()
        .br.lines(0)
        .br.font(.preferredFont(forTextStyle: .title2))
    
    
    public let contentStack = BRListView()
        .br.backgroundColor(.clear)
    
    
    public let messageLabel = BRLabel()
        .br.lines(0)
        .br.font(.preferredFont(forTextStyle: .body))
        .br.color(UIColor.secondaryLabel)
    
    
    public let bottomStack = UIStackView()
        .br.backgroundColor(.clear)
    
    
    public let cancelButton: BRButton
    
    
    public let doneButton: BRButton
    
    
    // MARK: - LifeCycle
    
    
    public init(doneButton: BRButton = BRButton(type: .system), cancelButton: BRButton = BRButton(type: .system)) {
        self.cancelButton = cancelButton
        self.doneButton = doneButton
        super.init(nibName: nil, bundle: nil)
    }
    
    
    @MainActor required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if style == .sheet {
            sheet.onViewDidAppear()
        }
    }
    
    
    // MARK: - UI
    
    
    open override func setupUI() {
        super.setupUI()
        view.backgroundColor = dimColor
    }
    
    
    open override func setupLayout() {
        super.setupLayout()
        
        view.addSubview(alertStack)
        
        alertStack
            .br.axis(.vertical)
            .br.cornerRadius(32)
            .br.spacing(12)
            .br.addArranged(topStack)
            .br.addArranged(contentStack)
            .br.addArranged(bottomStack)
        
        topStack
            .br.axis(.vertical)
            .br.margins(.init(top: 24, left: 32, bottom: 0, right: 32))
            .br.spacing(12)
            .br.addArranged(
                UIStackView()
                    .br.axis(.vertical)
                    .br.alignment(.center)
                    .br.addArranged(dragBar))
            .br.addArranged(navStack)
        
        navStack
            .br.axis(.horizontal)
            .br.distribution(.equalSpacing)
            .br.spacing(20)
            .br.addArranged(titleLabel)
            .br.addArranged(closeButton)
        
        contentStack
            .br.margins(.init(top: 0, left: 32, bottom: 0, right: 32))
            .br.spacing(5)
            .br.addArranged(messageLabel)
        
        setupAlertStackLayout()
        setupBottomStack()
    }
    
    
    open func setupAlertStackLayout() {
        switch style {
        case .alert:
            layout.activate {
                alertStack.br.centerY == view.br.centerY
                alertStack.br.centerX == view.br.centerX
                alertStack.br.height <= view.br.height * 0.8
                
                alertStack.br.left >= view.safeAreaLayoutGuide.br.left + alertMargin
                alertStack.br.right <= view.safeAreaLayoutGuide.br.right - alertMargin
                (alertStack.br.width == view.safeAreaLayoutGuide.br.width).br.priority(.defaultHigh)
                alertStack.br.width <= alertWidth
            }
        case .sheet:
            layout.activate {
                alertStack.br.left == view.br.left
                alertStack.br.right == view.br.right
                alertStack.br.bottom == view.br.bottom
                alertStack.br.top >= view.safeAreaLayoutGuide.br.top
                
                dragBar.br.width == dropBarWidth
                dragBar.br.height == 4
            }
        }
    }
    
    
    open func setupBottomStack() {
        layout.activate {
            doneButton.br.height == buttonHeight
            cancelButton.br.height == buttonHeight
        }
        
        switch buttonLayout {
        case .horizontal(let doneMultiple):
            bottomStack
                .br.axis(.horizontal)
                .br.spacing(12)
                .br.distribution(.fill)
                .br.addArranged(cancelButton)
                .br.addArranged(doneButton)
            doneWidthConstraint = doneButton.br.width == cancelButton.br.width * doneMultiple
            
        case .vertical:
            bottomStack
                .br.axis(.vertical)
                .br.spacing(20)
                .br.distribution(.fillEqually)
                .br.addArranged(doneButton)
                .br.addArranged(cancelButton)
        }
    }
    
    
    open var dropBarWidth: CGFloat {
        40
    }
    
    
    open var alertWidth: CGFloat {
        600
    }
    
    
    open var alertMargin: CGFloat {
        16
    }
    
    
    // MARK: - Data
    
    
    override open func bindViewModel() {
        super.bindViewModel()
        
        titleLabel.text = titleText
        messageLabel.text = message
        
        messageLabel.isHidden = message == nil
        
        cancelButton.setTitle(cancelTitle, for: .normal)
        doneButton.setTitle(doneTitle, for: .normal)
        
        cancelButton.isHidden = cancelTitle == nil
        bottomStack.isHidden = doneTitle == nil
        
        doneWidthConstraint?.isActive = !cancelButton.isHidden
        
        switch style {
        case .alert:
            closeButton.isHidden = !isEnableClose
            dragBar.isHidden = true
        case .sheet:
            dragBar.isHidden = !isEnableClose
            closeButton.isHidden = true
        }
    }
    
    
    // MARK: - Event
    
    
    open override func setupEvent() {
        super.setupEvent()
        cancelButton.br.addTarget(self, action: #selector(onCancelTapped))
        doneButton.br.addTarget(self, action: #selector(onDoneTapped))
        
        if style == .sheet {
            sheet.onSetupEvent()
        }
    }
    
    
    @objc open func onCloseTapped() {
        close {
            self.onClose?(self)
        }
    }
    
    
    @objc open func onDoneTapped() {
        close {
            self.onDone?(self)
        }
    }
    
    
    @objc open func onCancelTapped() {
        close {
            self.onCancel?(self)
        }
    }
    
    
    // MARK: - DSL
    
    
    @discardableResult
    open func style(_ style: Style) -> Self {
        self.style = style
        return self
    }
    
    
    @discardableResult
    open func dimAlpha(_ alpha: CGFloat) -> Self {
        self.dimAlpha = alpha
        return self
    }
    
    
    @discardableResult
    open func isEnableClose(_ isEnable: Bool) -> Self {
        self.isEnableClose = isEnable
        return self
    }
    
    
    @discardableResult
    open func title(_ text: String) -> Self {
        self.titleText = text
        return self
    }
    
    
    @discardableResult
    open func message(_ text: String?) -> Self {
        self.message = text
        return self
    }
    
    
    @discardableResult
    open func cancelTitle(_ text: String?) -> Self {
        self.cancelTitle = text
        return self
    }
    
    
    @discardableResult
    open func doneTitle(_ text: String?) -> Self {
        self.doneTitle = text
        return self
    }
    
    
    @discardableResult
    open func buttonLayout(_ layout: ButtonLayout) -> Self {
        self.buttonLayout = layout
        return self
    }
    
    
    @discardableResult
    open func buttonHeight(_ height: CGFloat) -> Self {
        self.buttonHeight = height
        return self
    }
    
    
    // MARK: - Show
    
    
    open func show(in viewController: UIViewController?) {
        switch style {
        case .alert:
            self.modalPresentationStyle = .overFullScreen
            self.modalTransitionStyle = .crossDissolve
            self.br.show(in: viewController)
        case .sheet:
            view.layoutIfNeeded()
            view.backgroundColor = .clear
            alertStack.transform = sheet.hiddenTransform
            self.modalPresentationStyle = .overFullScreen
            self.br.show(in: viewController, animated: false)
        }
    }
    
    
    open func close(completion: (() -> Void)?) {
        switch style {
        case .alert:
            dismiss(animated: true, completion: completion)
        case .sheet:
            sheet.onClose(completion: completion)
        }
    }
    
    
}


@MainActor
public extension BRAlertControllerDSL where Self: BRAlertController {
    
    
    @discardableResult
    func onDone(_ handle: ((Self) -> Void)?) -> Self {
        setHandle(handle, to: \.onDone)
    }
    
    
    @discardableResult
    func onCancel(_ handle: ((Self) -> Void)?) -> Self {
        setHandle(handle, to: \.onCancel)
    }
    
    
    @discardableResult
    func onClose(_ handle: ((Self) -> Void)?) -> Self {
        setHandle(handle, to: \.onClose)
    }
    
    
    private func setHandle(_ handle: ((Self) -> Void)?, to keyPath: ReferenceWritableKeyPath<BRAlertController, ((BRAlertController) -> Void)?>) -> Self {
        let base: BRAlertController = self
        
        guard let handle = handle else {
            base[keyPath: keyPath] = nil
            return self
        }
        
        base[keyPath: keyPath] = { alert in
            guard let alert = alert as? Self else {
                return
            }
            handle(alert)
        }
        return self
    }
    
    
}


@MainActor class Sheet {
    weak var alert: BRAlertController?
    var presentDuration: TimeInterval = 0.5
    var dismissDuration: TimeInterval = 0.35
    
    var dismissRatio: CGFloat = 0.3
    var dismissVelocity: CGFloat = 800
    
    var dragZoneHeight: CGFloat = 60
    
    var isDragging = false
    
    
    init(alert: BRAlertController) {
        self.alert = alert
    }
    
    
    func onViewDidAppear() {
        guard let alert else { return }
        UIViewPropertyAnimator(duration: presentDuration, dampingRatio: 1) {
            alert.view.backgroundColor = alert.dimColor
            alert.alertStack.transform = .identity
        }.startAnimation()
    }
    
    
    func onSetupEvent() {
        guard let alert else { return }
        alert.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackgroundTapped)))
        alert.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onPanned)))
    }
    
    
    func onClose(completion: (() -> Void)?) {
        guard let alert else { return }
        let animator = UIViewPropertyAnimator(duration: dismissDuration, dampingRatio: 1) {
            alert.view.backgroundColor = .clear
            alert.alertStack.transform = self.hiddenTransform
        }
        animator.addCompletion { _ in
            alert.dismiss(animated: false, completion: completion)
        }
        animator.startAnimation()
    }
    
    
    @objc private func onBackgroundTapped(_ sender: UITapGestureRecognizer) {
        guard let alert, alert.isEnableClose else { return }
        
        let location = sender.location(in: alert.view)
        
        if !alert.alertStack.frame.contains(location) {
            alert.onCloseTapped()
        }
    }
    
    
    @objc private func onPanned(_ sender: UIPanGestureRecognizer) {
        guard let alert, alert.isEnableClose else { return }
        
        switch sender.state {
        case .began:
            isDragging = sender.location(in: alert.alertStack).y <= dragZoneHeight
            
        case .changed:
            guard isDragging else { return }
            let offset = max(0, sender.translation(in: alert.view).y)
            alert.alertStack.transform = .init(translationX: 0, y: offset)
            alert.view.backgroundColor = UIColor.black.withAlphaComponent(alert.dimAlpha * (1 - progress(of: offset)))
            
        case .ended:
            guard isDragging else { return }
            isDragging = false
            
            let offset = max(0, sender.translation(in: alert.view).y)
            let velocity = sender.velocity(in: alert.view).y
            
            if progress(of: offset) > dismissRatio || velocity > dismissVelocity {
                alert.onCloseTapped()
            } else {
                resetAnimated()
            }
            
        default:
            guard isDragging else { return }
            isDragging = false
            resetAnimated()
        }
    }
    
    
    var hiddenTransform: CGAffineTransform {
        .init(translationX: 0, y: alert?.alertStack.bounds.height ?? 0)
    }
    
    
    private func resetAnimated() {
        guard let alert else { return }
        UIViewPropertyAnimator(duration: dismissDuration, dampingRatio: 1) {
            alert.view.backgroundColor = alert.dimColor
            alert.alertStack.transform = .identity
        }.startAnimation()
    }
    
    
    private func progress(of offset: CGFloat) -> CGFloat {
        guard let alert else { return 0 }
        guard alert.alertStack.bounds.height > 0 else { return 0 }
        return min(1, offset / alert.alertStack.bounds.height)
    }
    
    
}
