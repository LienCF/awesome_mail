# Spec: 批次 24 core service infra mock 清理

## 背景

批次 23 已清掉 Gmail / sync `data/services` 的 12 支 mock-heavy 測試，Flutter mock-heavy 檔案數降到 `179`。目前 `awesome_mail_flutter/test/unit/core/services` 仍是最大群組，共 `20` 支；其中最適合先收斂的是 network / storage / state 類 core service 測試，共 `8` 支：

- `ai_service_test.dart`
- `app_lifecycle_manager_test.dart`
- `biometric_auth_service_test.dart`
- `device_id_service_test.dart`
- `email_service_test.dart`
- `state_persistence_service_test.dart`
- `sync_service_test.dart`
- `token_service_test.dart`

這批測試目前混用了 `mockito` generated mocks、`mocktail Mock implements ...`，但實際上它們大多只需要 `ApiClient`、`FlutterSecureStorage`、`Logger`、`BiometricService` 與少量 domain/service 替身。

## 問題陳述

這批測試目前有四個問題：

1. `ApiClient`、`FlutterSecureStorage` 與 `Logger` 的 stub / verify 模式在多支檔案重複出現，測試焦點落在 mock framework，而不是 request、storage state 與回傳資料。
2. `token_service_test.dart`、`sync_service_test.dart`、`email_service_test.dart` 與 `biometric_auth_service_test.dart` 明明可以直接驗證 request / storage 行為，卻仍依賴 `when` / `verify`。
3. `app_lifecycle_manager_test.dart` 與 `state_persistence_service_test.dart` 只需要記錄 logger / storage 呼叫，但仍保留 generated mocks。
4. 這批檔案對應的 `.mocks.dart` 與 `Mock implements ...` 類別讓 batch 9 持續命中。

## 使用者故事

### US1: 以共用 infra fake 驅動 core service 測試

作為維護者，我們希望 network / storage / state 類 core service 測試改用共用手寫 fake，直接驗證 API request、storage 內容、logger 紀錄與 service 協作結果。

#### 驗收條件

1. 這 8 支測試不再依賴 `mockito` generated mocks 或 `mocktail Mock`。
2. 測試改以 request 記錄、記憶體 storage 與手寫 fake 驗證行為。
3. `ApiClient`、`FlutterSecureStorage`、`Logger`、`BiometricService` 與 AI provider 相關替身集中共用，不再各檔重複宣告。

### US2: 清掉 generated mocks 與 framework mock 依賴

作為維護者，我們希望 batch 24 的 `.mocks.dart` 與 `Mock` 類別全部移除，讓 `test/unit/core/services` 的 infra 類群組不再出現 mock framework 依賴。

#### 驗收條件

1. 這批對應的 `.mocks.dart` 已刪除。
2. batch 24 檔案中不再出現 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`。
3. targeted tests、`flutter analyze --fatal-infos` 與搜尋驗證通過。

## 非目標

- 不修改 production service API。
- 不在本批次處理 OAuth provider / auth delegation 類 core services。
- 不擴大處理 widget / page 或 backend mock-heavy 測試。

## 成功指標

- 這 8 支 core service 測試改由共用手寫 fake / in-memory 替身驅動。
- batch 24 targeted tests 與 `flutter analyze --fatal-infos` 通過。
- Flutter mock-heavy 檔案數在本批次完成後進一步下降。
