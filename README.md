# BRUIKit

BRUIKit - 提供 UIKit 功能擴充

## AutoLayout

### BRLayout

BRLayout - 提供 AutoLayout 功能封裝

- DSL 語法

``` swift
// 系統原生
NSLayoutConstraint.activate([
    button.widthAnchor.constraint(equalToConstant: 260),
    button.heightAnchor.constraint(equalToConstant: 34),
])
// BRLayout
layout.activate {
    button.widthAnchor.constraint(equalToConstant: 260)
    button.heightAnchor.constraint(equalToConstant: 34)
}
```
    
- 約束儲存 / 更新
    - 僅支援透過 BRLayout 啟動約束時使用
    - 啟動約束時添加 `.br.saved("id")` 即可透過 id 獲得儲存的約束
    - 可透過 id 編輯儲存的約束
    
``` swift
private extension String {
    static let identifier = "identifier"
}
let layout = BRLayout
layout.activate {
    button.widthAnchor.constraint(equalToConstant: 260).br.saved(.identifier)
    button.heightAnchor.constraint(equalToConstant: 34)
}
// Content 調整成 250
layout.setContent(250, for: .identifier)
// Multiplier 調整成 0.8
layout.setMultiplier(0.8, for: .identifier)
```

- priority
    - 允許在啟動約束時設定 priority
    
``` swift
layout.activate {
    button.widthAnchor.constraint(equalToConstant: 260).br.priority(.defaultHigh)
    button.heightAnchor.constraint(equalToConstant: 34)
}
```

## BRLayoutAnchor

BRLayoutAnchor - 提供以預算子設定 AutoLayout 的語法功能

- 限制
    - 需使用 BRLayoutAnchor 替代 NSLayoutAnchor 建立約束
- 語法

``` swift
// 系統原生
NSLayoutConstraint.activate([
    button.bottomAnchor.constraint(equalToSystemSpacingBelow: view.bottomAnchor, multiplier: 0.8),
    button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    button.widthAnchor.constraint(equalToConstant: 260),
    button.heightAnchor.constraint(equalToConstant: 34),
])

// 系統原生 + BRLayoutAnchor
NSLayoutConstraint.activate([
    button.br.bottom == view.br.bottom * 0.8,
    button.br.centerX == view.br.centerX,
    button.br.width == 260,
    button.br.height == 34,
])

// BRLayout + BRLayoutAnchor
layout.activate {
    button.br.bottom == view.br.bottom * 0.8
    button.br.centerX == view.br.centerX
    button.br.width == 260
    button.br.height == 34
}
```

