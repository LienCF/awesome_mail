> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 30 provider adapter mock 清理

## 技術策略

1. 先盤點這批測試共同依賴的 provider 抽象介面、CalDAV / IMAP / SMTP handler 與 http client，建立可重用的 hand-written fake。
2. 先處理 `ai_provider`、`email_provider`、`calendar_provider` 這種介面層測試，再收斂 Apple / iCloud / ProtonMail adapter。
3. 對協定型依賴改以記錄請求參數、可設定固定結果與錯誤的 fake 驅動，不再依賴 `verify` 次數。
4. 完成後刪除對應 `.mocks.dart`，執行 targeted tests、搜尋驗證、`flutter analyze --fatal-infos`，最後補跑 Flutter 全量回歸。

## 分組實作

### A. provider 測試共用 fake

- `awesome_mail_flutter/test/support/fakes/` 下新增或擴充 provider adapter 專用 fake

### B. provider 介面層

- `ai_provider_test.dart`
- `calendar_provider_test.dart`
- `email_provider_test.dart`

### C. Apple / iCloud / ProtonMail adapter

- `apple/apple_calendar_provider_test.dart`
- `apple/apple_reminders_provider_test.dart`
- `icloud/icloud_provider_test.dart`
- `protonmail/protonmail_provider_test.dart`

### D. generated 檔案清理

- `ai_provider_test.mocks.dart`
- `calendar_provider_test.mocks.dart`
- `email_provider_test.mocks.dart`
- `apple/apple_calendar_provider_test.mocks.dart`
- `apple/apple_reminders_provider_test.mocks.dart`
- `icloud/icloud_provider_test.mocks.dart`
- `protonmail/protonmail_provider_test.mocks.dart`

## 驗證策略

- `flutter test` 執行 batch 30 相關 provider 測試
- `flutter analyze --fatal-infos`
- `rg` 驗證這批檔案已無 `mockito`、`mocktail`、`@GenerateMocks`、`.mocks.dart`
- 完成後更新 `tdd-audit-report.md`
