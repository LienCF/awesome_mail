> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 32 core OAuth service mock 清理

## 技術策略

1. 先盤點 `test/unit/core/services` 剩餘 `12` 支測試的共用依賴，建立 auth / OAuth core service 共用 fake，覆蓋 provider availability、sign-in result、token store、API client、logger 與簡化 bloc recorder。
2. 先處理 orchestration 類測試，包含 `auth_service_oauth`、`auth_service`、`oauth_auth_service`、`oauth_onboarding_service`，快速把 fake 能力補齊。
3. 再處理 provider / error handling 類測試，包含 `apple_oauth_service`、`google_oauth_service`、`base_oauth_service`、`oauth_error_handling`、`oauth_integration`、`oauth_security`、`unified_oauth_service`、`menu_service`。
4. 完成後刪除對應 `.mocks.dart`，執行 targeted tests、搜尋驗證、`flutter analyze --fatal-infos`，最後補跑 Flutter 全量回歸。

## 分組實作

### A. core OAuth 共用 fake

- `awesome_mail_flutter/test/support/fakes/` 下新增或擴充 auth / OAuth core service 專用 fake

### B. auth / orchestration 類測試

- `auth_service_oauth_test.dart`
- `auth_service_test.dart`
- `oauth_auth_service_test.dart`
- `oauth_onboarding_service_test.dart`

### C. provider / error handling 類測試

- `apple_oauth_service_test.dart`
- `base_oauth_service_test.dart`
- `google_oauth_service_test.dart`
- `menu_service_test.dart`
- `oauth_error_handling_test.dart`
- `oauth_integration_test.dart`
- `oauth_security_test.dart`
- `unified_oauth_service_test.dart`

### D. generated 檔案清理

- `apple_oauth_service_test.mocks.dart`
- `auth_service_oauth_test.mocks.dart`
- `auth_service_test.mocks.dart`
- `base_oauth_service_test.mocks.dart`
- `google_oauth_service_test.mocks.dart`
- `oauth_auth_service_test.mocks.dart`
- `oauth_error_handling_test.mocks.dart`
- `oauth_integration_test.mocks.dart`
- `oauth_onboarding_service_test.mocks.dart`
- `oauth_security_test.mocks.dart`
- `unified_oauth_service_test.mocks.dart`

## 驗證策略

- `flutter test` 執行 batch 32 相關 core service 測試
- `flutter analyze --fatal-infos`
- `rg` 驗證這批檔案已無 `mockito`、`mocktail`、`@GenerateMocks`、`.mocks.dart`
- 完成後更新 `tdd-audit-report.md`
