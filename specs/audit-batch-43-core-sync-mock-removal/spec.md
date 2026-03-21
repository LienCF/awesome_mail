# Spec: 批次 43 core sync mock 清理

## 背景

`awesome_mail_flutter/test/unit/core/sync` 仍有 3 支測試依賴 `mockito` 或 `mocktail`，分別覆蓋 `EmailSynchronizer`、`OfflineQueueServiceImpl` 與 `SyncStateManager`。這些測試主要驗證同步策略、佇列處理與狀態持久化，適合改成 hand-written fake / recorder。

## 目標

1. 將下列 3 支測試改成不依賴 `mockito`、`mocktail`、`@GenerateMocks` 或 generated `.mocks.dart`
   - `awesome_mail_flutter/test/unit/core/sync/email_synchronizer_test.dart`
   - `awesome_mail_flutter/test/unit/core/sync/offline_queue_service_test.dart`
   - `awesome_mail_flutter/test/unit/core/sync/sync_state_manager_test.dart`
2. 以 hand-written fake / recorder 取代同步狀態、Gmail 遠端服務、跨裝置同步服務、快取與 metadata repository 的 mock framework 依賴
3. 刪除對應的 1 個 generated `.mocks.dart`
4. 通過 batch 43 相關測試、搜尋驗證與 `flutter analyze --fatal-infos`

## 非目標

- 不擴大到 `test/unit/core/background`、`test/unit/data/protocols` 或其他資料夾
- 不修改 production sync 流程

## 驗收條件

- `awesome_mail_flutter/test/unit/core/sync` 不再出現 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`.mocks.dart`
- batch 43 相關測試全部通過
- `flutter analyze --fatal-infos` 通過且無新增 issue
- `tdd-audit-report.md` 更新本批次結果與剩餘數量
