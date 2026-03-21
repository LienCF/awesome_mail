> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 36 presentation bloc core mock 清理

## 技術策略

1. 先處理依賴面較窄的 `email_sync_cubit_test.dart`、`search/search_bloc_test.dart`、`sync/sync_bloc_test.dart`，快速建立 recorder / callback fake 模式。
2. `state_persistence_test.dart` 以 in-memory persistence fake 與 logger recorder 驗證 `AuthBloc` 的真實持久化流程。
3. `ai/ai_bloc_test.dart` 使用可注入結果與錯誤的 service / repository / intent / logger fake，直接驗證 recorded calls 與 state。
4. 完成後刪除對應的 `3` 個 generated `.mocks.dart`，執行 targeted tests、搜尋驗證與 `flutter analyze --fatal-infos`。

## 分組實作

### A. 窄依賴 cubit / bloc

- `email_sync_cubit_test.dart`
- `search/search_bloc_test.dart`
- `sync/sync_bloc_test.dart`

### B. 持久化與 AI bloc

- `state_persistence_test.dart`
- `ai/ai_bloc_test.dart`

### C. generated 檔案清理

- `ai/ai_bloc_test.mocks.dart`
- `state_persistence_test.mocks.dart`
- `sync/sync_bloc_test.mocks.dart`

## 驗證策略

- `flutter test` 執行 batch 36 相關 bloc 測試
- `flutter analyze --fatal-infos`
- `rg` 驗證這批檔案已無 `mockito`、`mocktail`、`@GenerateMocks`、`.mocks.dart`
- 完成後更新 `tdd-audit-report.md`
