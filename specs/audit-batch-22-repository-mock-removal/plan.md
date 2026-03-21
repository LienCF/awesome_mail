> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 22 repository mock 清理

## 技術策略

1. 先抽出 `EmailRepositoryImpl` / `AccountRepositoryImpl` 測試共用的手寫替身，包含 cache manager、credential manager、cache coordinator、旗標服務、notifier 與排程器。
2. 優先處理 `account_repository_test.dart` 與 `email_repository_test.dart`，因為它們最直接反映 generated mock 與 framework mock 的問題。
3. 再收斂 `email_repository_impl_test.dart` 與各個 part helper 測試，讓重複宣告的 mock 類別收斂為共用 fake。
4. 完成後刪除 `email_repository_test.mocks.dart`，執行 targeted tests、搜尋驗證與 `flutter analyze --fatal-infos`。

## 分組實作

### A. 建立共用 repository 測試替身

- `awesome_mail_flutter/test/support/fakes/` 下新增 repository 相關 fake

### B. 主 repository 測試

- `awesome_mail_flutter/test/unit/data/repositories/account_repository_test.dart`
- `awesome_mail_flutter/test/unit/data/repositories/email_repository_test.dart`
- `awesome_mail_flutter/test/unit/data/repositories/email_repository_impl_test.dart`

### C. helper / operations 測試

- `awesome_mail_flutter/test/unit/data/repositories/email_delete_operations_test.dart`
- `awesome_mail_flutter/test/unit/data/repositories/email_merge_helpers_test.dart`
- `awesome_mail_flutter/test/unit/data/repositories/email_query_operations_test.dart`
- `awesome_mail_flutter/test/unit/data/repositories/email_repository_ai_fields_test.dart`
- `awesome_mail_flutter/test/unit/data/repositories/email_save_operations_test.dart`
- `awesome_mail_flutter/test/unit/data/repositories/gmail_repository_test.dart`

### D. generated 檔案清理

- `awesome_mail_flutter/test/unit/data/repositories/email_repository_test.mocks.dart`

## 驗證策略

- `flutter test` 執行 batch 22 相關 repository 測試
- `flutter analyze --fatal-infos`
- `rg` 驗證 `data/repositories` 批次已無 `mockito`、`@GenerateMocks`、`.mocks.dart`
- 完成後更新 `tdd-audit-report.md`
