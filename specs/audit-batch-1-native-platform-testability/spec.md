# 規格：原生平台測試可維護性修復

## 背景

全專案重新審計後，backend、Flutter Dart 與 Python 已經維持綠燈。剩餘問題集中在 Flutter 原生平台層：

- iOS `RunnerTests` 存在 `XCTSkipUnless`
- iOS/macOS 還保留樣板 `testExample()`
- Android OAuth method channel 有兩份重複邏輯，且沒有單元測試

## 目標

我們要把原生平台層修到和主程式相同的合規水位：

1. 不存在 skipped 測試
2. 不保留空白樣板測試
3. 原生平台自有邏輯具備可執行的測試
4. Android OAuth channel 只保留單一實作來源

## 使用情境與驗證

### US1：iOS/macOS 原生測試維持真實驗證

作為維護原生平台程式碼的開發者，我們需要 iOS/macOS RunnerTests 驗證真實邏輯，而不是留下空白樣板或在執行時被跳過，這樣修改原生橋接行為時才會被測試攔住。

驗證方式：

- iOS `RunnerTests` 不再含 `testExample()` 或 `XCTSkipUnless`
- macOS `RunnerTests` 不再含 `testExample()`
- iOS/macOS 原生測試可執行且通過

### US2：Android OAuth 原生橋接只有單一來源

作為維護 Android 原生橋接的開發者，我們需要 OAuth method channel 只有一份實作來源，且核心行為能在 JVM 單元測試中驗證，避免平台邏輯在未跑實機時漂移。

驗證方式：

- Android 不再保留未使用的重複 OAuth helper
- Method channel 的方法分派與 fingerprint 格式化有單元測試
- Android JVM 單元測試可執行且通過

## 功能需求

1. iOS 原生測試不得使用 `XCTSkipUnless`、`XCTSkipIf` 或 `XCTSkip`
2. iOS/macOS `RunnerTests.swift` 必須包含實際斷言的測試案例
3. iOS/macOS Writing Tools 或 App Intent 原生輔助邏輯必須能被單元測試驗證
4. Android OAuth method channel 的行為必須由單一實作負責
5. Android OAuth method channel 至少要驗證支援方法、未知方法與 SHA1 指紋格式化
6. 本批次完成後，相關原生測試與 Flutter 全域驗證必須全部通過

## 成功標準

- 原生測試目錄內 `XCTSkip` 類呼叫數量為 `0`
- `RunnerTests.swift` 不再出現樣板 `testExample()`
- Android OAuth 原生邏輯只剩一條維護路徑
- iOS/macOS/Android 相關測試與既有全量回歸全部通過

## 執行結果

- iOS `RunnerTests.swift` 與 macOS `RunnerTests.swift` 已改成真實測試，`testExample()` 與 `XCTSkip*` 為 `0`
- Android OAuth bridge 已收斂為 `OAuthMethodHandler` 與 `Sha1FingerprintFormatter`，重複 helper 已刪除
- 驗證結果：Android JVM `6` 個、macOS 原生 `5` 個、iOS 原生 `3` 個、Flutter 全量 `8119` 個、backend `1292` 個、Python `2` 個測試全過
