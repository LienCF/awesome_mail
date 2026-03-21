# Spec: 批次 31 provider tail mock 清理

## 背景

batch 30 已清掉 provider 介面層與 Apple / iCloud / ProtonMail adapter 測試，`awesome_mail_flutter/test/unit/data/providers` 目前剩餘 `8` 支 mock-heavy 測試檔：

- `foundation/foundation_models_framework_client_test.dart`
- `gmail/gmail_oauth_service_real_test.dart`
- `gmail/gmail_token_refresh_manager_test.dart`
- `gmail/gmail_token_repository_test.dart`
- `gmail/oauth_error_reporter_test.dart`
- `gmail/token_refresh_service_test.dart`
- `oauth/oauth_token_refresh_service_test.dart`
- `yahoo/yahoo_provider_test.dart`

這批測試的依賴集中在 `ApiClient`、`FlutterSecureStorage`、`Dio`、`GoogleSignInManager`、`FoundationModelsFramework`、`IMAPHandler` 與 `SMTPHandler`。其中只有 Yahoo 仍有 generated `.mocks.dart`，其餘多數是 `mocktail` 驅動的互動式測試。

## 問題陳述

這批測試目前有四個主要問題：

1. `token_refresh_service`、`oauth_token_refresh_service`、`gmail_token_repository` 主要驗證 request / persisted payload，卻仍以 mock framework 驅動。
2. `gmail_oauth_service_real` 與 `oauth_error_reporter` 只需要可控的 HTTP 行為與呼叫紀錄，不需要 `mocktail`。
3. `gmail_token_refresh_manager` 與 `foundation_models_framework_client` 的行為核心在排程、stream、dispose 與 failure stream，應該改成 stateful fake 驅動，而不是 `verify` 次數。
4. `test/unit/data/providers` 剩餘 `8` 檔仍命中 mock-heavy 掃描，會拖住 Flutter 最後一批 provider 群組收尾。

## 使用者故事

### US1: OAuth / token 類 provider 測試改用 hand-written fake

作為維護者，我們希望 Gmail / OAuth token 相關測試改成由 hand-written fake 驅動，直接驗證 request payload、儲存結果與 refresh 行為。

#### 驗收條件

1. `token_refresh_service_test.dart`、`oauth_token_refresh_service_test.dart`、`gmail_token_repository_test.dart`、`gmail_token_refresh_manager_test.dart` 不再依賴 `mocktail`、`mockito` 或 generated `.mocks.dart`。
2. 測試直接驗證 fake request / storage / save token / failure stream 的真實狀態變化。
3. 共用 fake 可被後續 core/service 測試重用。

### US2: Gmail OAuth / Yahoo provider / Foundation Models provider 測試改用 hand-written fake

作為維護者，我們希望 Gmail OAuth、Yahoo provider、Foundation Models provider 測試改用手寫 HTTP / auth / stream fake，保留 happy path、錯誤路徑與 dispose 行為驗證。

#### 驗收條件

1. `gmail_oauth_service_real_test.dart`、`oauth_error_reporter_test.dart`、`yahoo_provider_test.dart`、`foundation_models_framework_client_test.dart` 改用最小可控 fake 驅動。
2. Yahoo 對應 generated `.mocks.dart` 依賴完全移除。
3. streaming cancel、error chunk、OAuth error report、request payload 與 token exchange 行為仍被測到。

### US3: 清掉 batch 31 範圍的 mock framework 依賴

作為維護者，我們希望 batch 31 範圍內的 provider 測試不再命中 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`。

#### 驗收條件

1. `yahoo_provider_test.mocks.dart` 已刪除。
2. batch 31 檔案與共用 fake 檔中已無 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`.mocks.dart`。
3. targeted tests、`flutter analyze --fatal-infos`、搜尋驗證與 Flutter 全量回歸通過。

## 非目標

- 不修改 production provider 公開 API。
- 不在本批次處理 `test/unit/core/services` 或 backend mock-heavy 測試。
- 不變更 production OAuth 流程或 Foundation Models plugin 行為。

## 成功指標

- 這 `8` 支剩餘 provider 測試全部改由 hand-written fake / in-memory 驅動。
- `test/unit/data/providers` mock-heavy 群組在本批次完成後降為 `0`。
- batch 31 targeted tests、`flutter analyze --fatal-infos` 與 Flutter 全量回歸通過。
