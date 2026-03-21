# Spec: 批次 25 service storage/cache mock 清理

## 背景

批次 24 已清掉 `test/unit/core/services` 的 8 支 infra 類 mock-heavy 測試，Flutter mock-heavy 檔案數降到 `170`。下一個最適合接續的群組，是 `awesome_mail_flutter/test/unit/data/services` 裡依賴 API / secure storage / cache / database / logger 的 10 支測試：

- `email_account_service_test.dart`
- `metrics_service_test.dart`
- `usage_tracking_service_test.dart`
- `subscription_service_test.dart`
- `settings_backup_service_test.dart`
- `email_cache_service_test.dart`
- `email_cache_coordinator_cas_test.dart`
- `email_search_service_test.dart`
- `unread_count_manager_test.dart`
- `draft_service_test.dart`

這批測試目前混用了 `mockito` generated mocks、`mocktail Mock implements ...` 與只有註解沒有實際 mock 使用的 `@GenerateMocks`。其中大多數依賴都可以直接落在既有的 `core_service_infra_fakes.dart` 與 `service_layer_fakes.dart`，不需要再靠 `when` / `verify` 驅動。

## 問題陳述

這批測試目前有四個問題：

1. `ApiClient` 與 `FlutterSecureStorage` 的 request / storage 驗證仍以 `when` / `verify` 表達，測試焦點卡在 mock framework，而不是 payload、快取內容與持久化結果。
2. `CacheManager`、`AppDatabase` 與 `Logger` 的 stub 在多支 `data/services` 測試重複出現，沒有集中成可重用的手寫 fake。
3. `settings_backup_service_test.dart` 只剩空的 `@GenerateMocks([Directory])` 註解，形成純樣板式違規。
4. 對應 `.mocks.dart` 與 `Mock implements ...` 類別持續讓 batch 9 命中，拖慢整體 mock-heavy 清理。

## 使用者故事

### US1: 以共用 fake 驅動 API / storage 類 service 測試

作為維護者，我們希望 `email_account_service`、`metrics_service`、`usage_tracking_service`、`subscription_service` 這類 service 測試改用共用手寫 fake，直接驗證 request、secure storage 與回傳模型。

#### 驗收條件

1. 相關測試不再依賴 `mockito` generated mocks 或 `mocktail Mock`。
2. 測試改以 request 記錄、記憶體 storage 與直接資料驗證表達行為。
3. `ApiClient` / `FlutterSecureStorage` 的 fake 由共用測試替身提供，不在各檔重複宣告。

### US2: 以共用 fake 驅動 cache / database / logger 類 service 測試

作為維護者，我們希望 `email_cache_service`、`email_cache_coordinator_cas`、`email_search_service`、`unread_count_manager`、`draft_service` 這類測試改成手寫 fake / in-memory 驅動，直接驗證 cache key、DB 查詢與狀態變化。

#### 驗收條件

1. 相關測試改以 `ServiceFakeCacheManager`、`ServiceFakeAppDatabase`、`TestLogger` 或擴充後的共用替身表達行為。
2. 測試驗證的是快取結果、資料庫查詢與事件變化，不是 `verify` 次數本身。
3. `settings_backup_service_test.dart` 的空白 mock 註解移除後，仍維持既有行為覆蓋。

### US3: 清掉 generated mocks 與 framework mock 依賴

作為維護者，我們希望 batch 25 的 generated `.mocks.dart`、`@GenerateMocks`、`extends Mock` 類別全部移除，讓這批 `data/services` 測試不再命中 mock-heavy 規則。

#### 驗收條件

1. 這批對應的 `.mocks.dart` 已刪除。
2. batch 25 檔案中不再出現 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`。
3. targeted tests、`flutter analyze --fatal-infos` 與搜尋驗證通過。

## 非目標

- 不修改 production service API。
- 不在本批次處理 `automation/`、`payment/`、`in_app_purchase/`、`template_service` 或 `ai_task_queue_service` 群組。
- 不擴大處理 widget / page 或 backend mock-heavy 測試。

## 成功指標

- 這 10 支 `data/services` 測試改由共用手寫 fake / in-memory 替身驅動。
- batch 25 targeted tests 與 `flutter analyze --fatal-infos` 通過。
- Flutter mock-heavy 檔案數在本批次完成後進一步下降。
