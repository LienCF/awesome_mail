> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 28 account/auth/subscription bloc mock 清理

## 技術策略

1. 先盤點這批 bloc / cubit 測試共同依賴的 service、logger、stream 與 persistence 類型，優先建立可重用的 hand-written fake。
2. 先處理 `app`、`auth`、`settings` 這種狀態轉換較直接的 bloc，再收斂 `subscription`、`account_setup` 這類多步驟流程。
3. 對 stream 型依賴與 service 回傳建立最小可控 fake，改用真實 bloc 事件與 state 序列驗證，不再靠 `verify` 次數。
4. 完成後刪除對應 `.mocks.dart`，執行 targeted tests、搜尋驗證、`flutter analyze --fatal-infos`，最後補跑 Flutter 全量回歸。

## 分組實作

### A. bloc 測試共用 fake

- `awesome_mail_flutter/test/support/fakes/` 下新增或擴充 bloc 專用 service / stream fake

### B. app / auth / settings / account 類 bloc

- `account_management/account_management_cubit_test.dart`
- `account_setup/account_setup_gmail_bloc_test.dart`
- `app/app_bloc_test.dart`
- `auth/auth_bloc_test.dart`
- `settings/pgp_keys_cubit_test.dart`
- `settings/settings_bloc_test.dart`

### C. subscription 類 bloc / cubit

- `subscription/subscription_bloc_test.dart`
- `subscription/subscription_cubit_test.dart`

### D. generated 檔案清理

- `app/app_bloc_test.mocks.dart`
- `auth/auth_bloc_test.mocks.dart`
- `settings/settings_bloc_test.mocks.dart`
- `subscription/subscription_bloc_test.mocks.dart`
- `subscription/subscription_cubit_test.mocks.dart`

## 驗證策略

- `flutter test` 執行 batch 28 相關 bloc / cubit 測試
- `flutter analyze --fatal-infos`
- `rg` 驗證這批檔案已無 `mockito`、`mocktail`、`@GenerateMocks`、`.mocks.dart`
- 完成後更新 `tdd-audit-report.md`
