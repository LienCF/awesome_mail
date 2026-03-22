# 規格：原生測試替身與 Pod sandbox 清理

## 背景

2026-03-22 的全專案審計重新掃描後，我們確認仍有兩類殘留問題：

1. iOS 與 macOS 原生測試中，仍有少量自訂測試替身沿用 `Mock*` 命名。
2. iOS 與 macOS 的 `Pods/Manifest.lock` 缺失，導致原生 `xcodebuild test` 在 sandbox 檢查階段直接失敗。

這兩項都屬於原生平台測試可維護性與可驗證性的殘留問題，應在同一批次收斂。

## 目標

1. 將原生 Swift 測試內殘留的 `Mock*` 自訂替身改為 `Test*` 或其他測試語意命名。
2. 重新同步 iOS 與 macOS CocoaPods sandbox，補齊 `Pods/Manifest.lock`。
3. 驗證原生測試命令不再因 `Mock*` 命名或 Pod sandbox 不同步而失敗。

## 使用情境與驗證

### US1：原生測試替身語意一致

作為維護 iOS/macOS 原生測試的開發者，我們需要自訂測試替身統一使用 `Test*` 或 `Simulated*` 語意，避免在 fake-first 清理之後仍殘留 `Mock*` 類別名稱。

驗證方式：

- `awesome_mail_flutter/ios/RunnerTests` 與 `awesome_mail_flutter/macos/RunnerTests` 不再包含自訂 `Mock*` 類別命名。
- `GenerablePayloadTests.swift` 與 `AppIntentTests.swift` 仍可正常編譯與通過。

### US2：原生測試 sandbox 可正常啟動

作為執行原生平台測試的開發者，我們需要 iOS/macOS workspace 的 Pod sandbox 保持同步，讓 `xcodebuild test` 不會在測試開始前就因 `Manifest.lock` 缺失而中止。

驗證方式：

- `awesome_mail_flutter/ios/Pods/Manifest.lock` 存在。
- `awesome_mail_flutter/macos/Pods/Manifest.lock` 存在。
- iOS/macOS `xcodebuild test` 不再回報 `The sandbox is not in sync with the Podfile.lock`。

## 成功標準

- `rg -n "\bMock[A-Z]" awesome_mail_flutter/ios/RunnerTests awesome_mail_flutter/macos/RunnerTests` 無結果。
- iOS 與 macOS `Pods/Manifest.lock` 皆存在。
- 原生 `xcodebuild test` 已排除 Pod sandbox 不同步錯誤。
