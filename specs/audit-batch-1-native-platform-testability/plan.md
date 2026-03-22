> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# 計劃：原生平台測試可維護性修復

## 技術背景

- Flutter 主程式已通過 `flutter analyze --fatal-infos`
- backend 已通過 `npm run quality:check`
- Python 已通過 `python -m pytest python_tests -q`
- 待修區域限於 `awesome_mail_flutter/android`、`awesome_mail_flutter/ios`、`awesome_mail_flutter/macos`

## 實作策略

### Phase 1：先補紅燈測試

- iOS `RunnerTests.swift` 改成真實測試，覆蓋 Writing Tools 或 App Intent 原生邏輯
- macOS `RunnerTests.swift` 改成真實測試，覆蓋 Writing Tools 原生邏輯
- Android 新增 JVM 單元測試，先描述 OAuth method channel 與 SHA1 格式化行為

### Phase 2：最小實作讓測試轉綠

- iOS/macOS 將 AppDelegate 中可測的純邏輯抽成可被測試使用的 internal 型別
- Android 將 OAuth method channel 收斂成單一 handler，刪除未使用的重複 helper
- iOS 將 `GenerablePayloadTests` 的 skipped 路徑移除，改用可直接執行的可用性宣告

### Phase 3：回歸驗證

- Android JVM 測試
- iOS/macOS 原生測試
- Flutter `flutter analyze --fatal-infos`
- Flutter `flutter test`
- backend `npm run quality:check`
- Python `python -m pytest python_tests -q`

## 驗證結果

- Android `./gradlew testProductionDebugUnitTest`：`6` 個測試全過
- macOS `xcodebuild test -workspace Runner.xcworkspace -scheme Runner -destination 'platform=macOS'`：`5` 個測試全過
- iOS `xcodebuild test -workspace Runner.xcworkspace -scheme Runner -destination 'platform=iOS Simulator,id=DB8C51E9-146A-49D0-85DE-7AC69B433CE7'`：`3` 個測試全過
- Flutter `flutter analyze --fatal-infos`：`0` 個 issue
- Flutter `flutter test`：`8119` 個測試全過
- backend `npm run quality:check`：`91` 個測試檔、`1292` 個測試全過，coverage 為 Statements `90.59%`、Branches `85.84%`、Functions `95.26%`、Lines `90.59%`
- Python `python -m pytest python_tests -q`：`2` 個測試全過
