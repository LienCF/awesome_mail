# Spec: 批次 32 core OAuth service mock 清理

## 背景

batch 31 已清空 `test/unit/data/providers` 的 provider tail mock-heavy 測試。依同一規則重掃後，Flutter 目前剩餘最大的 mock-heavy 群組是 `awesome_mail_flutter/test/unit/core/services`，共有 `12` 支測試檔：

- `apple_oauth_service_test.dart`
- `auth_service_oauth_test.dart`
- `auth_service_test.dart`
- `base_oauth_service_test.dart`
- `google_oauth_service_test.dart`
- `menu_service_test.dart`
- `oauth_auth_service_test.dart`
- `oauth_error_handling_test.dart`
- `oauth_integration_test.dart`
- `oauth_onboarding_service_test.dart`
- `oauth_security_test.dart`
- `unified_oauth_service_test.dart`

其中 `11` 支仍帶有 generated `.mocks.dart`，其餘 `menu_service_test.dart` 雖然沒有 generated 檔，但仍直接 `extends Mock implements MailboxBloc`。

## 問題陳述

這批測試目前有四個主要問題：

1. `auth_service`、`auth_service_oauth`、`oauth_auth_service`、`oauth_onboarding_service` 主要驗證的是 token、provider list、sign-in / sign-out 的狀態轉換，卻仍依賴 `mockito` 的 `when` / `verify`。
2. `google_oauth_service`、`apple_oauth_service`、`unified_oauth_service`、`oauth_integration`、`oauth_error_handling`、`oauth_security` 多半只需要可控的 provider availability、sign-in 結果與 logger 觀察點，適合改成 stateful fake。
3. `base_oauth_service_test` 與 `menu_service_test` 仍以 mock logger / mock bloc 驗證互動次數，沒有直接驗證真實輸入輸出狀態。
4. `test/unit/core/services` 是目前 Flutter 剩餘最大群組，不先清掉會拖住後續 core / auth / integration 收尾。

## 使用者故事

### US1: auth / token orchestration 測試改用手寫 fake

作為維護者，我們希望 auth / token orchestration 測試改用手寫 fake 驅動，直接驗證登入結果、token 儲存與登出後狀態。

#### 驗收條件

1. `auth_service_oauth_test.dart`、`auth_service_test.dart`、`oauth_auth_service_test.dart`、`oauth_onboarding_service_test.dart` 不再依賴 `mockito`、`mocktail` 或 generated `.mocks.dart`。
2. 測試直接驗證 fake service / token store / API client 的狀態變化，而不是只驗證 `verify(...).called(1)`。
3. 共用 fake 可供後續 core service / bloc / integration 測試重用。

### US2: OAuth provider / error handling 測試改用手寫 fake

作為維護者，我們希望 OAuth provider / error handling 測試改成由手寫 fake 驅動，保留 availability、happy path、failure path 與 sign-out 行為驗證。

#### 驗收條件

1. `apple_oauth_service_test.dart`、`google_oauth_service_test.dart`、`base_oauth_service_test.dart`、`oauth_error_handling_test.dart`、`oauth_integration_test.dart`、`oauth_security_test.dart`、`unified_oauth_service_test.dart` 改用最小可控 fake 驅動。
2. logger、provider service 與 sign-in account 相關驗證改成 state capture，不依賴 mock framework。
3. generated `.mocks.dart` 完全移除。

### US3: 剩餘 core service mock framework 依賴清空

作為維護者，我們希望 batch 32 範圍內的 core service 測試不再命中 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`。

#### 驗收條件

1. `menu_service_test.dart` 改成手寫 fake bloc 或 recorder，不再直接 `extends Mock`。
2. batch 32 檔案與共用 fake 檔已無 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`.mocks.dart`。
3. targeted tests、`flutter analyze --fatal-infos`、搜尋驗證與 Flutter 全量回歸通過。

## 非目標

- 不修改 production OAuth / auth service 公開 API。
- 不在本批次處理 `test/unit/data/services` 或 backend mock-heavy 測試。
- 不變更實際 Google / Apple / platform OAuth 流程。

## 成功指標

- 這 `12` 支 `test/unit/core/services` 測試全部改由 hand-written fake / in-memory 驅動。
- `test/unit/core/services` mock-heavy 群組在本批次完成後降為 `0`。
- batch 32 targeted tests、`flutter analyze --fatal-infos` 與 Flutter 全量回歸通過。
