//
//  BRThemeEngine.swift
//  BRUIKit
//
//  Created by BR on 2025/6/23.
//

import UIKit


/// `BRThemeEngine` 提供 Closure 的儲存與重現功能，搭配 DSL 語法建立風格替換系統
///
/// - 特性
///     - 使用 `weakMemory` 安全儲存 `View.br.theme { UI setting... }` Closure 與 View 元件，當 View 釋放時會同時釋放
///     - 呼叫 `applyTheme()` 即可再次實作所有 Closure
///     - 僅提供 Theme 儲存與再現機制，客戶端可自由製作系統
///
/// # UIKit 風格系統範例
///
/// ## 建立風格
///
/// ``` swift
///
/// enum ThemeStyle: String, CaseIterable {
///     case light
///     case dark
/// }
///
///
/// struct ThemeScheme {
///     var backgroundColor: UIColor
/// }
///
///
/// extension ThemeScheme {
///
///
///     static func scheme(for style: ThemeStyle) -> ThemeScheme {
///         switch style {
///         case .light:
///             return ThemeScheme(
///                 backgroundColor: .white
///             )
///         case .dark:
///             return ThemeScheme(
///                 backgroundColor: .gray
///             )
///         }
///     }
///
///
/// }
/// ```
///
/// ## 建立切換器
///
/// ``` swift
/// import BRUIKit
/// import Foundation
///
///
/// final class ThemeProvider {
///     static let shared = ThemeProvider()
///
///
///     private(set) var currentStyle: ThemeStyle = .dark
///
///
///     var current: ThemeScheme {
///         ThemeScheme.scheme(for: currentStyle)
///     }
///
///
///     @MainActor
///     func setTheme(_ style: ThemeStyle) {
///         currentStyle = style
///         BRThemeEngine.shared.applyTheme()
///     }
///
///
/// }
/// ```
///
/// ## 建立使用面板 (可選)
///
/// ``` swift
/// import UIKit
/// import BRUIKit
///
///
/// enum Theme {
///     static var current: ThemeScheme {
///         ThemeProvider.shared.current
///     }
///
///     static var backgroundColor: UIColor { current.backgroundColor }
/// }
///
/// ```
///
/// ## ViewController 實作
///
/// ``` swift
/// import BRFoundation
/// import BRUIKit
/// import UIKit
///
///
/// class ViewController: UIViewController {
///
///     private let layout = BRLayout()
///
///     lazy var button = UIButton(type: .custom)
///         .br.title("done")
///         .br.titleColor(.black)
///         .br.addTarget(self, action: #selector(onDoneTap))
///
///
///     override func viewDidLoad() {
///         super.viewDidLoad()
///
///         self.br.theme {
///             $0.view.backgroundColor = Theme.backgroundColor
///         }
///
///         view.addSubview(button)
///
///         layout.activate {
///             button.br.centerX == view.br.centerX
///             button.br.bottom == view.safeAreaLayoutGuide.br.bottom - 10
///         }
///     }
///
///
///     @objc func onDoneTap() {
///         let theme: ThemeStyle = ThemeProvider.shared.currentStyle == .light ? .dark : .light
///         ThemeProvider.shared.setTheme(theme)
///     }
///
/// }
/// ```
@MainActor
public final class BRThemeEngine {
    public static let shared = BRThemeEngine()

    private let mapTable = NSMapTable<AnyObject, AnyThemeClosure>(keyOptions: .weakMemory, valueOptions: .strongMemory)

    
    private init() {}

    
    public func register<Base: AnyObject>(target: Base, closure: @escaping (Base) -> Void) {
        let box = ThemeClosure(targetType: Base.self, closure: closure)
        mapTable.setObject(box, forKey: target)
        box.apply(to: target)
    }

    
    public func applyTheme() {
        for target in mapTable.keyEnumerator().allObjects.compactMap({ $0 as AnyObject }) {
            mapTable.object(forKey: target)?.apply(to: target)
        }
    }
    
    
}


// MARK: - Help


class AnyThemeClosure: NSObject {
    func apply(to view: AnyObject) {}
}


final class ThemeClosure<Base: AnyObject>: AnyThemeClosure {
    let closure: (Base) -> Void
    let targetType: Base.Type

    init(targetType: Base.Type, closure: @escaping (Base) -> Void) {
        self.targetType = targetType
        self.closure = closure
    }

    override func apply(to target: AnyObject) {
        guard let casted = target as? Base else { return }
        closure(casted)
    }
}

