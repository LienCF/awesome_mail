> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 35 presentation bloc foundation mock 清理

## 技術策略

1. 先處理 `bloc_manager_test.dart`、`email_sync/email_sync_cubit_test.dart`、`mailbox/mailbox_action_cubit_test.dart`，因為依賴面窄，能先穩定 hand-written recorder 模式。
2. `bloc_factory_test.dart` 則改用手寫 interface fake bloc 型別，保留 `GetIt` factory 驗證，但移除 `mocktail`。
3. 能共用的 fake 優先留在測試檔內，只有跨檔案會重複的替身才擴充到 `test/support/fakes/`。
4. 完成後刪除 `bloc_manager_test.mocks.dart`，執行 targeted tests、搜尋驗證與 `flutter analyze --fatal-infos`。

## 分組實作

### A. 基礎 recorder / interface fake

- `bloc_manager_test.dart`
- `email_sync/email_sync_cubit_test.dart`
- `mailbox/mailbox_action_cubit_test.dart`

### B. `BlocFactory` 型別工廠驗證

- `bloc_factory_test.dart`

### C. generated 檔案清理

- `bloc_manager_test.mocks.dart`

## 驗證策略

- `flutter test` 執行 batch 35 相關 bloc 測試
- `flutter analyze --fatal-infos`
- `rg` 驗證這批檔案已無 `mockito`、`mocktail`、`@GenerateMocks`、`.mocks.dart`
- 完成後更新 `tdd-audit-report.md`
