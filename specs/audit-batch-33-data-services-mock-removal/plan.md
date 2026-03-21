> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 33 data services mock 清理

## 技術策略

1. 先盤點 `test/unit/data/services` 剩餘 `8` 支測試的共用依賴，補齊 data service 共用 fake，覆蓋 queue call recorder、subscription 狀態源、repository / DB state、vector similarity 與 sync boundary。
2. 先處理 delegation / 狀態型測試，包含 `ai_task_scheduler`、`productivity_service`、`subscription_manager`，快速把共用 fake 介面穩定下來。
3. 再處理 queue / DB / sync 類測試，包含 `ai_task_queue_service`、`ai_task_queue_service_bulk_security`、`email_flags_service`、`vector_search_service`、`sync_health_checker`。
4. 完成後刪除對應 `.mocks.dart` 與 orphan generated 檔，執行 targeted tests、搜尋驗證、`flutter analyze --fatal-infos`，最後補跑 Flutter 全量回歸。

## 分組實作

### A. data services 共用 fake

- `awesome_mail_flutter/test/support/fakes/` 下新增或擴充 queue、subscription、DB / sync、vector、flags 相關 fake

### B. delegation / 狀態型測試

- `ai_task_scheduler_test.dart`
- `productivity_service_test.dart`
- `in_app_purchase/subscription_manager_test.dart`

### C. queue / DB / sync 測試

- `ai_task_queue_service_test.dart`
- `ai_task_queue_service_bulk_security_test.dart`
- `email_flags_service_test.dart`
- `sync_health_checker_test.dart`
- `vector_search_service_test.dart`

### D. generated 檔案清理

- `ai_task_scheduler_test.mocks.dart`
- `sync_health_checker_test.mocks.dart`
- `settings_backup_service_test.mocks.dart`

## 驗證策略

- `flutter test` 執行 batch 33 相關 data service 測試
- `flutter analyze --fatal-infos`
- `rg` 驗證這批檔案已無 `mockito`、`mocktail`、`@GenerateMocks`、`.mocks.dart`
- 完成後更新 `tdd-audit-report.md`
