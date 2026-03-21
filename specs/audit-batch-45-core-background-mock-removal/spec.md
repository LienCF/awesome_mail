# Spec: 批次 45 core background mock 清理

## 背景

`awesome_mail_flutter/test/unit/core/background` 還有 2 支測試依賴 `mockito` 或 generated mock，分別是 `background_sync_service_test.dart` 與 `isolate_manager_test.dart`。其中 `background_sync_service_test.dart` 主要驗證背景同步排程、離線佇列與效能指標，適合改成 hand-written fake；`isolate_manager_test.dart` 則只殘留空的 `@GenerateMocks([])`。

## 目標

1. 將下列測試改成不依賴 `mockito`、`@GenerateMocks`、`extends Mock` 或 generated `.mocks.dart`
   - `awesome_mail_flutter/test/unit/core/background/background_sync_service_test.dart`
   - `awesome_mail_flutter/test/unit/core/background/isolate_manager_test.dart`
2. 以 hand-written fake / recorder 取代 `SyncService`、`IsolateManager` 與 `OfflineQueueService` 的 mock framework 依賴
3. 刪除 `awesome_mail_flutter/test/unit/core/background/background_sync_service_test.mocks.dart`
4. 通過 batch 45 targeted tests、搜尋驗證與 `flutter analyze --fatal-infos`

## 非目標

- 不擴大到 `test/unit/core/monitoring`、`test/unit/presentation/services` 或 backend
- 不改動 `BackgroundSyncService`、`IsolateManager` 的既有對外行為，除非測試改寫揭露真實缺陷

## 驗收條件

- `awesome_mail_flutter/test/unit/core/background` 不再出現 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`.mocks.dart`
- batch 45 相關測試全部通過
- `flutter analyze --fatal-infos` 通過且無新增 issue
- `tdd-audit-report.md` 更新本批次結果與剩餘數量
