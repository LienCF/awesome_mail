> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 23 Gmail / sync data services mock 清理

## 技術策略

1. 先抽出 Gmail remote service 共用手寫替身，集中處理 token repository、refresh manager、refresh service 與 HTTP client。
2. 優先處理 `gmail_remote_service_test.dart` 與其 label / message / parser / sync 家族，因為它們共用相同依賴模型。
3. 再收斂 `gmail_attachment_*`、`all_mail_sync_service_test.dart`、`full_content_download_service_test.dart`、`email_sync_service_test.dart`、`attachment_download_manager_test.dart` 與 `email_cache_coordinator_test.dart`，讓 service orchestration 測試改用手寫 fake。
4. 完成後刪除對應 `.mocks.dart`，執行 targeted tests、搜尋驗證與 `flutter analyze --fatal-infos`。

## 分組實作

### A. 建立共用 Gmail service 測試替身

- `awesome_mail_flutter/test/support/fakes/` 下新增 Gmail / sync 服務相關 fake

### B. Gmail remote service 家族

- `awesome_mail_flutter/test/unit/data/services/gmail_remote_service_test.dart`
- `awesome_mail_flutter/test/unit/data/services/gmail_remote_service_label_test.dart`
- `awesome_mail_flutter/test/unit/data/services/gmail_remote_service_message_test.dart`
- `awesome_mail_flutter/test/unit/data/services/gmail_remote_service_parser_test.dart`
- `awesome_mail_flutter/test/unit/data/services/gmail_remote_service_sync_test.dart`
- `awesome_mail_flutter/test/unit/data/services/gmail_attachment_parser_test.dart`
- `awesome_mail_flutter/test/unit/data/services/gmail_attachment_download_test.dart`

### C. sync / coordination 家族

- `awesome_mail_flutter/test/unit/data/services/all_mail_sync_service_test.dart`
- `awesome_mail_flutter/test/unit/data/services/full_content_download_service_test.dart`
- `awesome_mail_flutter/test/unit/data/services/email_sync_service_test.dart`
- `awesome_mail_flutter/test/unit/data/services/attachment_download_manager_test.dart`
- `awesome_mail_flutter/test/unit/data/services/email_cache_coordinator_test.dart`

### D. generated 檔案清理

- `awesome_mail_flutter/test/unit/data/services/gmail_remote_service_test.mocks.dart`
- `awesome_mail_flutter/test/unit/data/services/gmail_remote_service_parser_test.mocks.dart`
- `awesome_mail_flutter/test/unit/data/services/gmail_remote_service_sync_test.mocks.dart`
- `awesome_mail_flutter/test/unit/data/services/gmail_attachment_parser_test.mocks.dart`
- `awesome_mail_flutter/test/unit/data/services/gmail_attachment_download_test.mocks.dart`
- `awesome_mail_flutter/test/unit/data/services/all_mail_sync_service_test.mocks.dart`
- `awesome_mail_flutter/test/unit/data/services/full_content_download_service_test.mocks.dart`

## 驗證策略

- `flutter test` 執行 batch 23 相關 Gmail / sync service 測試
- `flutter analyze --fatal-infos`
- `rg` 驗證這批檔案已無 `mockito`、`mocktail`、`@GenerateMocks`、`.mocks.dart`
- 完成後更新 `tdd-audit-report.md`
