# TDD Audit Report

**建立時間**: 2026-03-21  
**最後更新**: 2026-03-22  
**範圍**: `awesome-mail/src`、`awesome-mail/tests`、`awesome_mail_flutter/lib`、`awesome_mail_flutter/test`、`awesome_mail_flutter/integration_test`、`awesome_mail_flutter/android`、`awesome_mail_flutter/ios`、`awesome_mail_flutter/macos`、`awesome_mail_flutter/windows`、`python_tests`

## 工具驗證結果

- backend `npm run quality:check`: 通過，`91` 個測試檔、`1292` 個測試全過
- Flutter `flutter analyze --fatal-infos`: 通過，`0` 個 issue
- Flutter `flutter test`: 通過，`8119` 個測試全過
- Python `python -m pytest python_tests -q`: 通過，`2` 個測試全過
- Android `JAVA_HOME=/Applications/Android Studio.app/Contents/jbr/Contents/Home ./gradlew testProductionDebugUnitTest`: 通過，`6` 個測試全過
- macOS `xcodebuild test -workspace Runner.xcworkspace -scheme Runner -destination 'platform=macOS'`: 通過，`5` 個測試全過
- iOS `xcodebuild test -workspace Runner.xcworkspace -scheme Runner -destination 'platform=iOS Simulator,id=DB8C51E9-146A-49D0-85DE-7AC69B433CE7'`: 通過，`3` 個測試全過

## 審計結論

這輪已完成原生平台批次、Flutter 殘留測試替身語意清理、backend 尾端舊命名收尾，以及原生測試殘留 `Mock*` 命名與 Pod sandbox 同步修復。backend、Flutter Dart、Python、Android Kotlin、iOS Swift、macOS Swift 與 Windows runner 重新檢視後，沒有剩餘待修違規。

## 已完成修復

- iOS `RunnerTests.swift` 與 macOS `RunnerTests.swift` 已改成真實斷言測試，覆蓋 Writing Tools 原生純邏輯
- iOS `GenerablePayloadTests.swift` 已移除 `XCTSkipUnless`，改成以可用性宣告直接執行
- Android `MainActivity.kt` 的 OAuth method channel 已收斂到 `OAuthMethodHandler` 與 `Sha1FingerprintFormatter`
- 未使用的 `awesome_mail_flutter/android/app/src/main/kotlin/com/awesomemail/app/OAuthHelper.kt` 已刪除
- Android 已新增 JVM 單元測試，驗證支援方法、未知方法與 SHA1 格式化
- 為了讓 Android 單元測試在目前套件組合可執行，已補上 Gradle namespace 與 Kotlin JVM target 相容性修正，並把 `device_calendar` 升級到 `4.3.3`
- Flutter `test/support/mocks/` 的 home page 共用替身已移到 `test/support/fakes/home_page_test_fakes.dart`，`test_app_shell.dart` 與 `macos_home_page_ai_test.dart` 已改用 `Test*` 替身
- 未使用的 `awesome_mail_flutter/test/support/fakes/http_client_mocktail_shim.dart` 已刪除，局部測試替身改為 `Recording*`、`Test*` 或 `Simulated*`
- Flutter Gmail / OAuth 模擬服務與測試已清掉 `Mock*` 命名，DI 組態同步改為 `Simulated*`
- Flutter `lib/` 與 `test/` 內殘留的 `mock` 識別字、示範字串與註解已全面改為 `test`、`sample` 或 `simulated` 語意
- macOS `AppIntentTests.swift` 的 `MockIntentAIBackend` 已改為 `TestIntentAIBackend`
- iOS `GenerablePayloadTests.swift` 的 `MockToolInvocationApi` 已改為 `TestToolInvocationApi`
- iOS 與 macOS 已重新執行 `pod install`，補齊 `Pods/Manifest.lock` 並讓原生測試 sandbox 回到同步狀態
- backend D1 / KV / OAuth / AI provider 測試替身已改為 `Test*` 或 `Simulated*`，不再保留 `Mock*` 類別命名
- backend `ai-provider-simulated.ts`、`test-d1.ts`、`oauth-simulated-services.ts` 與對應測試檔已完成檔名收斂，檔案路徑不再保留 `mock`
- backend 與 Flutter 內容層搜尋已清到 `mock` 零命中；測試假資料、字串常數、provider 類型與文件措辭已同步收斂
- Flutter 測試文件已更新為 fake-first 測試策略，移除過時的替身框架指引

## 合規搜尋結果

- `rg -n "XCTSkip|testExample\\(" awesome_mail_flutter/ios/RunnerTests awesome_mail_flutter/macos/RunnerTests`: 無結果
- `rg -n "\bMock[A-Z]" awesome_mail_flutter/ios/RunnerTests awesome_mail_flutter/macos/RunnerTests`: 無結果
- `rg -n "mockito|mocktail|@GenerateMocks|support/mocks|http_client_mocktail_shim|^class Mock[A-Z]|\\bMock[A-Z][A-Za-z0-9_]*\\b" awesome_mail_flutter/lib awesome_mail_flutter/test awesome-mail/src awesome-mail/tests`: 無結果
- `rg --files awesome-mail/src awesome-mail/tests | rg "mock|Mock"`: 無結果
- `rg -n "mock" awesome_mail_flutter/lib awesome_mail_flutter/test awesome-mail/src awesome-mail/tests`: 無結果
- `rg -n "\\.skip\\(|\\bskip\\(|\\bskipTest\\(|\\bxit\\(|\\bxdescribe\\(|XCTSkip" awesome-mail/tests awesome_mail_flutter/test awesome_mail_flutter/integration_test awesome_mail_flutter/ios awesome_mail_flutter/macos python_tests`: 唯一命中 `awesome_mail_flutter/test/support/fakes/data_service_fakes.dart:415` 的集合 `skip()` 呼叫，並非 skipped 測試
- Android 原生 OAuth 自有實作只剩 `MainActivity.kt`、`OAuthMethodHandler.kt`、`Sha1FingerprintFormatter.kt`
- `awesome_mail_flutter/android/app/src/main/kotlin/com/awesomemail/app/OAuthHelper.kt`: 已刪除

## 本輪批次

- 批次 1：`specs/audit-batch-1-native-platform-testability/`
  - 狀態：完成
- 批次 2：`specs/audit-batch-2-residual-test-double-cleanup/`
  - 狀態：完成
- 批次 3：`specs/audit-batch-3-backend-residual-path-cleanup/`
  - 狀態：完成
- 批次 4：`specs/audit-batch-4-native-test-double-and-pod-sync/`
  - 狀態：完成

## 備註

- `awesome_mail_flutter/windows/runner` 目前僅見 Flutter runner 啟動樣板與 Win32 外殼程式碼，未發現專案特有商業邏輯，因此這輪不列入修復批次。
- `GeneratedPluginRegistrant*`、`Pods/`、`android/build/` 等產生檔與第三方相依已排除，不納入違規判定。
