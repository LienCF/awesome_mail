> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# 計劃：原生測試替身與 Pod sandbox 清理

## 技術背景

- 審計已確認 backend、Python 與 Flutter analyze 全綠。
- 原生平台剩餘的確定違規集中在兩個 Swift 測試檔的 `Mock*` 自訂替身命名。
- iOS/macOS `xcodebuild test` 目前卡在 `Pods/Manifest.lock` 缺失，不是測試邏輯失敗，而是 Pod sandbox 未同步。
- Android 單元測試失敗主因是本機 `java -version` 為 `25.0.2`，需改用相容 JDK 重跑，這屬於驗證環境設定，不納入程式碼批次修改。

## 實作策略

### Phase 1：收斂原生測試替身命名

- 將 `AppIntentTests.swift` 內的 `MockIntentAIBackend` 改為 `TestIntentAIBackend`。
- 將 `GenerablePayloadTests.swift` 內的 `MockToolInvocationApi` 改為 `TestToolInvocationApi`。
- 保持測試語意與行為不變，只做結構性命名收斂。

### Phase 2：同步 iOS/macOS Pod sandbox

- 執行 `pod install` 產生 iOS/macOS `Pods/Manifest.lock`。
- 重新確認 workspace 與 Podfile.lock 同步。

### Phase 3：回歸驗證

- `rg -n "\bMock[A-Z]" awesome_mail_flutter/ios/RunnerTests awesome_mail_flutter/macos/RunnerTests`
- iOS `xcodebuild test -workspace Runner.xcworkspace -scheme Runner -destination 'platform=iOS Simulator,id=DB8C51E9-146A-49D0-85DE-7AC69B433CE7'`
- macOS `xcodebuild test -workspace Runner.xcworkspace -scheme Runner -destination 'platform=macOS'`
- Android `JAVA_HOME=/Applications/Android Studio.app/Contents/jbr/Contents/Home ./gradlew testProductionDebugUnitTest`
- backend `npm run quality:check`
- Python `python -m pytest python_tests -q`
- Flutter `flutter analyze --fatal-infos`
- Flutter `flutter test`
