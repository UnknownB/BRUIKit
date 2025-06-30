# Coordinator 封裝

- 封裝 `UIKit` MVVMC 架構的 Coordinator 概念
- 以 __Step__ 為核心，提供頁面跳轉封裝

## 元件

### BRStepFlow

- 提供 「步驟流程 (Step)」 的基礎 `protocol`
- 適用於遵守 `CaseIterable`、`Equatable` 的 `enum`
- 實作擴展：
    - 取得第一步
    - 取得當前步驟的下一步

### BRCoordinator

- 遵守 `BRCoordinatorProtocol` 協定的核心 Coordinator
- 提供 4 個核心功能
    - start(step)：設定起始畫面
    - goTo(step, from)：從指定步驟持續堆疊頁面
    - pushToNextStep(from)：跳下一頁
    - makeViewController(for)：建立頁面

### BRStepCoordinator

- 繼承自 `BRCoordinator` 的單流程 Coordinator
- 遵守 `BRStepCoordinatorProtocol` 協定

### BREventCoordinator

- 繼承自 `BRCoordinator` 的多流程 Coordinator
- 遵守 `BREventCoordinatorProtocol` 協定

## 使用範例

### Coordinator

``` swift
enum AuthStep: BRStepFlow {
    case login
}

// 增加 Event
enum AuthEvent: BRStepEvent {
    case login
    case signup
}

// 使用 BREventCoordinator
final class AuthCoordinator<AuthStep, AuthEvent>: BREventCoordinator {

    override func start(step: AuthStep = .firstStep) {
        super.start()
        goTo(step: step)
    }

    override func makeViewController(for step: AuthStep) -> UIViewController {
        switch step {
            case .login:
                return LoginViewController(coordinator: self)
        }
    }

    override func didFinishStep(_ step: AuthStep, with event: AuthEvent?) {
        // 為 step 自訂邏輯行為
        // 增加 event 做不同流程跳轉
    }
}
```

### ViewController

``` swift
import BRUIKit
import UIKit


final class LoginViewController: BRViewController {

    private let coordinator: BREventCoordinator<AuthStep, AuthEvent>

    init(coordinator: BREventCoordinator<AuthStep, AuthEvent>) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func onLoginTapped() {
        // 登入現有帳號
        coordinator.didFinishStep(.login, with: .login)
    }

    @objc private func onSingupTapped() {
        // 註冊新使用者
        coordinator.didFinishStep(.login, with: .signup)
    }

}
```
