//
//  BRSegmentBar.swift
//  BRUIKit
//
//  Created by BR on 2025/9/9.
//

import UIKit


public final class BRSegmentBar<Button: UIButton>: UIView {

    private let layout = BRLayout()
    private let selectionGroup = BRSingleSelectGroup<Button>()
    
    
    private let scrollView = UIScrollView()
        .br.showsHorizontalIndicator(false)
    
    
    private let stackView = UIStackView()
        .br.axis(.horizontal)
        .br.spacing(8)
        .br.alignment(.fill)
        .br.distribution(.fill)
    
    
    public var buttons: [Button] {
        selectionGroup.buttons
    }
    
    
    public var selectedButton: Button? {
        selectionGroup.selectedButton
    }
    
    
    public var didChangeSelection: ((Button?) -> Void)? {
        get {
            selectionGroup.didChangeSelection
        }
        set {
            selectionGroup.didChangeSelection = newValue
        }
    }
    
    
    // MARK: - LifeCycle
    

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }

    
    // MARK: - UI
    
    
    private func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        layout.activate {
            scrollView.br.left == self.br.left
            scrollView.br.right == self.br.right
            scrollView.br.top == self.br.top
            scrollView.br.bottom == self.br.bottom
            
            stackView.br.left == scrollView.contentLayoutGuide.br.left
            stackView.br.right == scrollView.contentLayoutGuide.br.right
            stackView.br.top == scrollView.contentLayoutGuide.br.top
            stackView.br.bottom == scrollView.contentLayoutGuide.br.bottom
            stackView.br.height == scrollView.frameLayoutGuide.br.height
        }
    }
    

    @MainActor
    public func addButton(_ button: Button) {
        stackView.addArrangedSubview(button)
        selectionGroup.addButton(button)
    }
    

    @MainActor
    public func selectButton(_ button: Button) {
        selectionGroup.selectButton(button)
    }
    

    @MainActor
    public func scrollToButton(_ button: Button, animated: Bool = true) {
        scrollView.scrollRectToVisible(button.frame.insetBy(dx: -16, dy: 0), animated: animated)
    }
    
    
    @MainActor
    public func scrollToButton(at index: Int, animated: Bool = true) {
        guard index >= 0, index < buttons.count else {
            return
        }
        let button = buttons[index]
        scrollToButton(button, animated: animated)
    }
    
    
}
