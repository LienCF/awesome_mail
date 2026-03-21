> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 31 provider tail mock 清理

## 技術策略

1. 先建立 OAuth / provider tail 共用 fake，覆蓋 `ApiClient`、`FlutterSecureStorage`、`Dio`、`GoogleSignInManager`、`FoundationModelsFramework` 與 token repository / refresh service。
2. 先處理 request / storage 類測試，包含 `token_refresh_service`、`oauth_token_refresh_service`、`gmail_token_repository`，快速確認 fake 介面完整。
3. 再處理 stateful 行為測試，包含 `gmail_token_refresh_manager`、`gmail_oauth_service_real`、`oauth_error_reporter`、`yahoo_provider`、`foundation_models_framework_client`。
4. 完成後刪除 Yahoo 對應 `.mocks.dart`，執行 targeted tests、搜尋驗證、`flutter analyze --fatal-infos`，最後補跑 Flutter 全量回歸。

## 分組實作

### A. provider tail 共用 fake

- `awesome_mail_flutter/test/support/fakes/` 下新增或擴充 OAuth / provider tail 專用 fake

### B. token / storage / refresh 類測試

- `gmail/token_refresh_service_test.dart`
- `oauth/oauth_token_refresh_service_test.dart`
- `gmail/gmail_token_repository_test.dart`
- `gmail/gmail_token_refresh_manager_test.dart`

### C. OAuth / provider / stream 類測試

- `gmail/oauth_error_reporter_test.dart`
- `gmail/gmail_oauth_service_real_test.dart`
- `yahoo/yahoo_provider_test.dart`
- `foundation/foundation_models_framework_client_test.dart`

### D. generated 檔案清理

- `yahoo/yahoo_provider_test.mocks.dart`

## 驗證策略

- `flutter test` 執行 batch 31 相關 provider 測試
- `flutter analyze --fatal-infos`
- `rg` 驗證這批檔案已無 `mockito`、`mocktail`、`@GenerateMocks`、`.mocks.dart`
- 完成後更新 `tdd-audit-report.md`
