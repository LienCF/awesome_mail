> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Spec: 批次 61 Flutter 最終 mock framework 歸零

## 背景

batch 60 完成後，Flutter app 與內嵌 package 還殘留最後一小段 testing-only mock framework 足跡。主體集中在 `foundation_models_framework` package 的 `mock()` 工廠與 `testing.dart` 出口、`auth_flow_integration_test.dart` 內的 `mocktail` 依賴，以及 app `pubspec.yaml` 中已不再需要的 `mockito` / `mocktail` dev dependency。

## 目標

1. 移除 `foundation_models_framework` package 的 mock-only API，改用顯式 testing factory。
2. 讓 `auth_flow_integration_test.dart` 改由 hand-written fake 與真實狀態持久層驅動。
3. 刪除 app 中不再需要的 `mockito` / `mocktail` 依賴，並確認程式與測試目錄內 mock framework 實際使用歸零。
4. 完成 package targeted tests、整合測試、`flutter analyze --fatal-infos` 與 Flutter 全量回歸。

## 非目標

1. 不清理歷史文件中的舊關鍵字文字敘述。
2. 不改寫 backend 測試或未納入本批次的 Flutter 舊檔。

## 驗收標準

1. `awesome_mail_flutter/lib`、`test`、`integration_test` 與 `packages/foundation_models_framework/lib`、`test` 中，不再出現 `package:mocktail`、`package:mockito`、`class .* extends Mock`、`@GenerateMocks`、`FoundationModelsFramework.mock()`、`foundation_models_framework/testing.dart`。
2. `packages/foundation_models_framework/test/foundation_models_framework_test.dart` 與 `integration_test/auth_flow_integration_test.dart` 全部通過。
3. `awesome_mail_flutter` 的 `flutter analyze --fatal-infos` 與全量 `flutter test` 全部通過。
