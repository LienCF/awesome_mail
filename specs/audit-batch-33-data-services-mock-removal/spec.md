# Spec: 批次 33 data services mock 清理

## 背景

batch 32 已清空 `test/unit/core/services` 的 mock-heavy 測試。依同一規則重掃後，Flutter 下一個剩餘群組是 `awesome_mail_flutter/test/unit/data/services`，目前命中的測試檔有 `8` 支：

- `ai_task_queue_service_bulk_security_test.dart`
- `ai_task_queue_service_test.dart`
- `ai_task_scheduler_test.dart`
- `email_flags_service_test.dart`
- `in_app_purchase/subscription_manager_test.dart`
- `productivity_service_test.dart`
- `sync_health_checker_test.dart`
- `vector_search_service_test.dart`

另外同目錄還殘留一個 orphan generated 檔 `settings_backup_service_test.mocks.dart`，雖然主測試檔已不再使用 mock framework，但這個 generated 檔仍應一併清理。

## 問題陳述

這批測試目前有四個主要問題：

1. `ai_task_scheduler_test.dart`、`productivity_service_test.dart`、`subscription_manager_test.dart` 本質上只驗證 delegation 或狀態轉換，卻仍依賴 `mockito` / `mocktail`。
2. `email_flags_service_test.dart`、`vector_search_service_test.dart`、`sync_health_checker_test.dart` 需要的其實是可觀察狀態的 in-memory fake 或 recorder，而不是框架式 mock。
3. `ai_task_queue_service_test.dart` 與 `ai_task_queue_service_bulk_security_test.dart` 驗證的是排程條件、SQL 參數與事件驅動喚醒，目前使用 `mocktail` 將真實行為拆成大量 `when` / `verify`，可讀性差且維護成本高。
4. `test/unit/data/services` 是 Flutter 剩餘 mock-heavy 群組之一，不先清掉會拖住後續 integration / bloc / backend 收尾。

## 使用者故事

### US1: delegation 與狀態型 data service 測試改用手寫 fake

作為維護者，我們希望 delegation 與狀態型 data service 測試改用手寫 fake / recorder 驅動，直接驗證輸入輸出與狀態變化。

#### 驗收條件

1. `ai_task_scheduler_test.dart`、`productivity_service_test.dart`、`in_app_purchase/subscription_manager_test.dart` 不再依賴 `mockito`、`mocktail` 或 generated `.mocks.dart`。
2. 測試直接驗證 fake service / repository 的狀態與呼叫紀錄，而不是只依賴 `verify(...).called(1)`。
3. 共用 fake 能被後續 `data/services` 與 integration 測試重用。

### US2: queue / DB / sync 相關 data service 測試改用 in-memory fake

作為維護者，我們希望 queue / DB / sync 相關測試改成使用最小可控的 in-memory fake，保留 happy path、錯誤路徑與 SQL / call record 驗證。

#### 驗收條件

1. `ai_task_queue_service_test.dart`、`ai_task_queue_service_bulk_security_test.dart`、`email_flags_service_test.dart`、`vector_search_service_test.dart`、`sync_health_checker_test.dart` 改用 hand-written fake 或真實 in-memory 依賴。
2. 需要驗證的 SQL 參數、cache invalidation、sync metadata 更新、auto-repair 呼叫都改成 state capture 或 recorder 驗證。
3. `sync_health_checker_test.mocks.dart` 與 `ai_task_scheduler_test.mocks.dart` 完全移除。

### US3: batch 33 mock framework 依賴清空

作為維護者，我們希望 batch 33 範圍內的 data service 測試不再命中 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`。

#### 驗收條件

1. batch 33 的 8 支測試與共用 fake 檔已無 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`.mocks.dart` 依賴。
2. orphan generated 檔 `settings_backup_service_test.mocks.dart` 一併刪除，且整個 codebase 無引用殘留。
3. targeted tests、`flutter analyze --fatal-infos`、搜尋驗證與 Flutter 全量回歸通過。

## 非目標

- 不修改 production data service 公開 API。
- 不在本批次處理 `test/unit/presentation/blocs`、`test/integration` 或 backend mock-heavy 測試。
- 不重寫 `SyncHealthChecker`、`AiTaskQueueService`、`SubscriptionManager` 的 production 實作。

## 成功指標

- 這 `8` 支 `test/unit/data/services` 測試全部改由 hand-written fake / in-memory 驅動。
- `test/unit/data/services` 這一群在本批次完成後降為 `0`。
- batch 33 targeted tests、`flutter analyze --fatal-infos` 與 Flutter 全量回歸通過。
