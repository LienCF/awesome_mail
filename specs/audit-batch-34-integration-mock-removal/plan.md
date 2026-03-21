> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 34 integration mock 清理

## 技術策略

1. 先盤點 `test/integration` 剩餘 `4` 支測試的共用依賴，優先重用既有 `test/support/fakes/` 中的 subscription、OAuth、repository fake。
2. 先處理 `subscription_flow_integration_test.dart` 與 `oauth_migration_integration_test.dart`，因為這兩支主要是 UI flow 與狀態持久化，重構風險較低，也能先穩定 fake API。
3. 再處理 `offline_mode_test.dart` 與 `full_sync_flow_test.dart`，補齊 `OfflineQueueServiceImpl` 與 `EmailSynchronizer` 需要的最小 recorder / in-memory fake。
4. 完成後刪除對應 `.mocks.dart`，執行 targeted tests、搜尋驗證、`flutter analyze --fatal-infos`，最後補跑 Flutter 全量回歸。

## 分組實作

### A. integration 共用 fake

- `awesome_mail_flutter/test/support/fakes/` 下新增或擴充 OAuth storage、sync state recorder、offline queue 依賴 fake

### B. subscription / OAuth flow

- `subscription_flow_integration_test.dart`
- `oauth_migration_integration_test.dart`

### C. offline / full sync flow

- `offline_mode_test.dart`
- `full_sync_flow_test.dart`

### D. generated 檔案清理

- `oauth_migration_integration_test.mocks.dart`
- `subscription_flow_integration_test.mocks.dart`

## 驗證策略

- `flutter test` 執行 batch 34 相關 integration 測試
- `flutter analyze --fatal-infos`
- `rg` 驗證這批檔案已無 `mockito`、`mocktail`、`@GenerateMocks`、`.mocks.dart`
- 完成後更新 `tdd-audit-report.md`
