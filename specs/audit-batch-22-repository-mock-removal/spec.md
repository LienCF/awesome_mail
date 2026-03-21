# Spec: 批次 22 repository mock 清理

## 背景

批次 21 已清掉 `test/unit/data/protocols` 中 6 支 handler 測試與 6 個 generated mocks，Flutter mock-heavy 檔案數從 `297` 降到 `284`。目前下一個最小且邊界清楚的群組是 `awesome_mail_flutter/test/unit/data/repositories`，共 10 個命中：

- `account_repository_test.dart`
- `email_delete_operations_test.dart`
- `email_merge_helpers_test.dart`
- `email_query_operations_test.dart`
- `email_repository_ai_fields_test.dart`
- `email_repository_impl_test.dart`
- `email_repository_test.dart`
- `email_repository_test.mocks.dart`
- `email_save_operations_test.dart`
- `gmail_repository_test.dart`

這些測試大多直接 mock `AppDatabase`、`EmailCacheCoordinator`、`EmailFlagsService`、`AccountRepository` 等內外部相依，且幾支 helper 測試重複宣告了相同的一組 mock 類別。

## 問題陳述

這批測試目前有三個問題：

1. repository / helper 測試大量依賴 `mockito` / `mocktail` 類別，導致測試聚焦在 stub framework，而不是資料流、資料庫結果與協作輸入輸出。
2. 同一組依賴在多支檔案重複宣告 mock 類別，增加維護成本。
3. `email_repository_test.dart` 仍保留 generated `.mocks.dart`，讓審計結果持續命中。

## 使用者故事

### US1: repository 測試改用共用手寫替身

作為維護者，我們希望 repository 相關測試改用共用手寫 fake / in-memory 替身，讓測試以真實資料物件、呼叫紀錄與 in-memory DB 驗證行為，而不是依賴 `when` / `verify`。

#### 驗收條件

1. `account_repository_test.dart`、`email_repository_test.dart`、`email_repository_impl_test.dart` 不再依賴 generated mocks。
2. helper 類測試優先共用一套 repository 測試替身，不再各檔重複宣告大批 mock 類別。
3. 測試仍保留資料讀寫、快取協調、AI 欄位與刪除 / 查詢行為驗證。

### US2: 移除 repository generated mocks 與重複 mock 宣告

作為維護者，我們希望 `data/repositories` 批次不再出現 `email_repository_test.mocks.dart` 與相關 `Mock` 類別宣告，降低批次 9 的剩餘違規數。

#### 驗收條件

1. `email_repository_test.mocks.dart` 已刪除。
2. `data/repositories` 這批檔案中不再出現 `mockito`、`@GenerateMocks` 或不必要的 `extends Mock implements ...`。
3. targeted tests、`flutter analyze --fatal-infos` 與搜尋驗證通過。

## 非目標

- 不修改 repository production API。
- 不擴大處理 `data/services` 或 `data/providers` 的其他 mock-heavy 測試。
- 不在這一批處理 backend mock-heavy 測試。

## 成功指標

- `data/repositories` 批次檔案不再依賴 generated mocks 或 framework-driven mocks。
- 本批次 targeted tests 通過。
- Flutter mock-heavy 檔案數在本批次完成後進一步下降。
