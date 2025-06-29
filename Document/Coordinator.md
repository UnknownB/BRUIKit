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

- 遵守 `BRCoordinatorProtocol` 協定的單流程 Coordinator
- 最基本的核心物件，提供 4 個基本功能
    - start()：起始設定
    - goTo(step, from)：從指定步驟持續堆疊頁面
    - pushToNextStep(from)：跳下一頁
    - makeViewController(for)：建立頁面

### BRStepCoordinator

