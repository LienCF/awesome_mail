> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 37 mailbox bloc mock 清理

## 技術策略

1. 先抽出 mailbox 專用 dependency fake，優先複用既有 `service_layer_fakes.dart`、`repository_dependency_fakes.dart`、`data_service_fakes.dart` 中已成熟的 in-memory recorder。
2. 把 `logger`、`EmailSyncCubit`、`AccountCubit`、`FolderCubit`、`SyncProgressCubit`、`DownloadProgressCubit` 等 bloc 邊界改成 recorder / stream fake。
3. 先讓 `mailbox_bloc_test.dart` 綠燈，再把相同 mailbox dependency bundle 套到 `mailbox_handlers_test.dart`，避免兩邊各自發散。
4. 完成後執行 targeted tests、搜尋驗證與 `flutter analyze --fatal-infos`，再更新 `tdd-audit-report.md`。

## 分組實作

### A. mailbox 共用 dependency fake

- `awesome_mail_flutter/test/support/fakes/mailbox_bloc_dependency_fakes.dart`（必要時新增）

### B. 核心 mailbox state / event 測試

- `awesome_mail_flutter/test/unit/presentation/blocs/mailbox/mailbox_bloc_test.dart`

### C. mailbox handler 行為測試

- `awesome_mail_flutter/test/unit/presentation/blocs/mailbox/mailbox_handlers_test.dart`

## 驗證策略

- `flutter test` 執行 batch 37 相關 mailbox 測試
- `flutter analyze --fatal-infos`
- `rg` 驗證 `test/unit/presentation/blocs/mailbox` 已無 `mocktail`、`extends Mock`、`.mocks.dart`
- 完成後更新 `tdd-audit-report.md`
