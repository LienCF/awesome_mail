> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 13 provider HTTP fake client 去 mock 化

## 技術策略

1. 先為共用 `FakeHttpClient` 撰寫 red 測試，鎖定 request 記錄、handler 配對與未匹配錯誤。
2. 實作 `FakeHttpClient`，用最小功能支援 provider 測試需要的 HTTP 行為。
3. 逐支把 Google / Microsoft provider 測試從 `mockito` 改成 `FakeHttpClient`，保留既有 happy path 與錯誤路徑驗證。
4. 完成後刪除對應 generated `.mocks.dart`，執行 targeted tests、`flutter analyze` 與全量 `flutter test`。

## 分組實作

### A. 測試基礎設施

- `awesome_mail_flutter/test/support/fakes/fake_http_client.dart`
- `awesome_mail_flutter/test/support/fakes/fake_http_client_test.dart`

### B. Google provider 測試

- `awesome_mail_flutter/test/unit/data/providers/google/google_calendar_provider_test.dart`
- `awesome_mail_flutter/test/unit/data/providers/google/google_tasks_provider_test.dart`

### C. Microsoft provider 測試

- `awesome_mail_flutter/test/unit/data/providers/microsoft/microsoft_calendar_provider_test.dart`
- `awesome_mail_flutter/test/unit/data/providers/microsoft/microsoft_todo_provider_test.dart`

## 驗證策略

- `flutter test test/support/fakes/fake_http_client_test.dart`
- `flutter test` 執行 batch 13 相關 provider 測試
- `flutter analyze --fatal-infos`
- `flutter test`
- 更新 `tdd-audit-report.md` 與 batch 13 `tasks.md`
