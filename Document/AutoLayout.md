# AutoLayout 封裝

- 封裝 `UIKit` 系統 coding layout 常用功能
- 支援 DSL 語法
- 支援 __約束__ 動態更新

## 元件

### BRLayout

- 負責管理 `NSLayoutConstraint` 提供相關操作

### BRLayoutAnchor

- 負責以 DSL 語法 產生 `NSLayoutConstraint`
- 支援 `<=`、`==`、`>=`、`+`、`-`、`*`  方式書寫

## 使用方式

### BRLayoutAnchor

``` swift
    // 系統原生語法
    button.bottomAnchor.constraint(equalToSystemSpacingBelow: view.bottomAnchor, multiplier: 0.8)
    button.heightAnchor.constraint(equalToConstant: 34)

    // BRLayoutAnchor
    button.br.bottom == view.br.bottom * 0.8
    button.br.height == 34
```

### BRLayout

#### 初始化

- 在 `ViewController` 建立 `BRLayout` 實體物件

``` swift
import BRUIKit
import UIKit

class ViewController: UIViewController {
    private let layout = BRLayout()
}
```

#### 添加約束

``` swift
// 系統原生
NSLayoutConstraint.activate([
    button.bottomAnchor.constraint(equalToSystemSpacingBelow: view.bottomAnchor, multiplier: 0.8),
    button.heightAnchor.constraint(equalToConstant: 34)
])

// BRLayout
layout.activate {
    button.br.bottom == view.br.bottom * 0.8
    button.br.height == 34
}
```

#### 更新約束

- 透過 `layout.activate` 啟動約束時，會將約束的 `identifier` 儲存管理
- 添加約束時使用 `.br.saved("id")` 即可添加含有 id 的約束
    
``` swift
// 系統原生

class ViewController: UIViewController {
    var constaint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        constaint = button.bottomAnchor.constraint(equalToSystemSpacingBelow: view.bottomAnchor, multiplier: 0.8)
        constaint.isActive = true
    }

    func updateLayout() {
        constaint.isActive = false
        constaint = button.bottomAnchor.constraint(equalToSystemSpacingBelow: view.bottomAnchor, multiplier: 0.6)
        constaint.isActive = true
    }
}

// BRLayout

private extension String {
    static let buttonBottomMultiplier = "buttonBottomMultiplier"
}

class ViewController: UIViewController {
    let layout = BRLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        layout.activate {
            (button.br.bottom == view.br.bottom * 0.8).br.saved(.buttonBottomMultiplier)
        }
    }

    func updateLayout() {
        layout.setMultiplier(0.6, for: .buttonBottomMultiplier)
    }
}
```