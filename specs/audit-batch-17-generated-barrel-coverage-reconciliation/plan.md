> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 17 generated / barrel / example coverage 對齊

## 技術策略

1. 以檔案內容本身證明 generated / barrel / example 身分：
   - `firebase_options.dart` 為 FlutterFire CLI 產生。
   - `injection.config.dart` 為 Injectable generated code，且 `coverage:ignore-file`。
   - `macos_components.dart` 為 barrel file。
   - `awesome_design_example.dart` 為設計範例頁。
2. 重新執行 `foundation_ai_provider_test.dart`，作為 `_foundation_ai_provider_operations.dart` 的整體行為 coverage 依據。
3. 更新 `tdd-audit-report.md` 與 batch 17 `tasks.md`，移除這 5 個假陽性並下修 Flutter 缺測數。

## 驗證策略

- `flutter test test/unit/data/providers/foundation_ai_provider_test.dart`
- 更新 `tdd-audit-report.md` 與 batch 17 `tasks.md`
