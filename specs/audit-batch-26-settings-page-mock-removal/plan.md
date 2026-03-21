> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 26 settings page mock 清理

## 技術策略

1. 先盤點 settings page 測試共同依賴的 bloc / cubit / service，優先建立可重用的 widget 測試 harness 與 hand-written fake。
2. 先處理 `SettingsBloc` 為主的單頁設定頁，再收斂 `settings_page_test.dart`、`account_settings_page_test.dart` 這類多依賴頁面。
3. 對 `ServiceFactory`、`SettingsBackupService`、`BiometricService`、`PGPService` 建立最小可用假物件，讓互動測試不再靠 mock verify。
4. 完成後刪除對應 `.mocks.dart`，執行 targeted tests、搜尋驗證、`flutter analyze --fatal-infos`，最後補跑 Flutter 全量回歸。

## 分組實作

### A. widget 測試共用 harness / fake

- `awesome_mail_flutter/test/support/fakes/` 下新增或擴充 settings page 專用 bloc / cubit / service fake

### B. 單頁 settings bloc 類測試

- `about_page_test.dart`
- `accessibility_settings_page_test.dart`
- `appearance_settings_page_test.dart`
- `general_settings_page_test.dart`
- `notification_settings_page_test.dart`
- `privacy_settings_page_test.dart`
- `sync_settings_page_test.dart`
- `update_settings_page_test.dart`

### C. 多依賴 settings 頁面與工具頁

- `account_settings_page_test.dart`
- `ai_settings_page_test.dart`
- `backup_settings_page_test.dart`
- `pgp_keys_page_test.dart`
- `security_settings_page_test.dart`
- `settings_page_test.dart`
- `shortcuts_settings_page_test.dart`

### D. generated 檔案清理

- `appearance_settings_page_test.mocks.dart`

## 驗證策略

- `flutter test` 執行 batch 26 相關 settings page 測試
- `flutter analyze --fatal-infos`
- `rg` 驗證這批檔案已無 `mockito`、`mocktail`、`@GenerateMocks`、`.mocks.dart`
- 完成後更新 `tdd-audit-report.md`
