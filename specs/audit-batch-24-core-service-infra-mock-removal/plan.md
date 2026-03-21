> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 24 core service infra mock 清理

## 技術策略

1. 先在 `test/support/fakes/` 建立 core service 共用測試替身，集中處理 `ApiClient`、`FlutterSecureStorage`、`Logger`、`BiometricService` 與 AI provider。
2. 優先改寫 `token_service_test.dart`、`sync_service_test.dart`、`email_service_test.dart` 與 `biometric_auth_service_test.dart`，因為它們最直接依賴 API / storage fake。
3. 再收斂 `device_id_service_test.dart`、`state_persistence_service_test.dart`、`app_lifecycle_manager_test.dart` 與 `ai_service_test.dart`，讓 storage / logger / provider 類測試也共用同一組 fake。
4. 完成後刪除對應 `.mocks.dart`，執行 targeted tests、搜尋驗證與 `flutter analyze --fatal-infos`。

## 分組實作

### A. 建立 core service 共用測試替身

- `awesome_mail_flutter/test/support/fakes/` 下新增 core service infra fake

### B. API / storage orchestration 類測試

- `awesome_mail_flutter/test/unit/core/services/token_service_test.dart`
- `awesome_mail_flutter/test/unit/core/services/sync_service_test.dart`
- `awesome_mail_flutter/test/unit/core/services/email_service_test.dart`
- `awesome_mail_flutter/test/unit/core/services/biometric_auth_service_test.dart`

### C. state / logger / provider 類測試

- `awesome_mail_flutter/test/unit/core/services/device_id_service_test.dart`
- `awesome_mail_flutter/test/unit/core/services/state_persistence_service_test.dart`
- `awesome_mail_flutter/test/unit/core/services/app_lifecycle_manager_test.dart`
- `awesome_mail_flutter/test/unit/core/services/ai_service_test.dart`

### D. generated 檔案清理

- `awesome_mail_flutter/test/unit/core/services/ai_service_test.mocks.dart`
- `awesome_mail_flutter/test/unit/core/services/app_lifecycle_manager_test.mocks.dart`
- `awesome_mail_flutter/test/unit/core/services/device_id_service_test.mocks.dart`
- `awesome_mail_flutter/test/unit/core/services/email_service_test.mocks.dart`
- `awesome_mail_flutter/test/unit/core/services/state_persistence_service_test.mocks.dart`
- `awesome_mail_flutter/test/unit/core/services/sync_service_test.mocks.dart`

## 驗證策略

- `flutter test` 執行 batch 24 相關 core service 測試
- `flutter analyze --fatal-infos`
- `rg` 驗證這批檔案已無 `mockito`、`mocktail`、`@GenerateMocks`、`.mocks.dart`
- 完成後更新 `tdd-audit-report.md`
