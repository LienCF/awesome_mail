> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 20 HTTP client mock 收尾

## 技術策略

1. 延用 batch 13 已建立的 `FakeHttpClient`，並為協定層保留共用 shim，避免重寫整批 `verify(captureAny())` 驗證邏輯。
2. 先挑一組協定層與一組 service / provider 測試做 red，確認移除 mock framework 後仍能驗證 request URL、headers、body 與錯誤處理。
3. service / provider / core 測試改用 `FakeHttpClient`，協定層測試改用共用 `http_client_mocktail_shim.dart`。
4. 完成後刪除對應 generated `.mocks.dart`，更新審計報告與 batch 狀態。
5. 執行 targeted tests、`flutter analyze --fatal-infos`、搜尋驗證與全量 `flutter test`，確認 batch 9 可正式結案。

## 分組實作

### A. 協定層測試

- `awesome_mail_flutter/test/unit/data/protocols/caldav/caldav_client_test.dart`
- `awesome_mail_flutter/test/unit/data/protocols/carddav/carddav_client_test.dart`
- `awesome_mail_flutter/test/unit/data/protocols/jmap/jmap_client_test.dart`
- `awesome_mail_flutter/test/unit/data/protocols/exchange/ews_client_test.dart`

### B. service / core 測試

- `awesome_mail_flutter/test/unit/data/services/account_config_service_test.dart`
- `awesome_mail_flutter/test/unit/core/remote_config_service_test.dart`
- `awesome_mail_flutter/test/unit/core/update_service_test.dart`

### C. provider 測試

- `awesome_mail_flutter/test/unit/data/providers/outlook/outlook_provider_test.dart`
- `awesome_mail_flutter/test/unit/data/providers/productivity/todoist_provider_test.dart`
- `awesome_mail_flutter/test/unit/data/providers/productivity/notion_provider_test.dart`

## 驗證策略

- `flutter test` 執行 batch 20 相關 10 支測試
- `flutter analyze --fatal-infos`
- `flutter test`
- `rg` 驗證 Flutter 測試中已無 `@GenerateMocks([http.Client])` 與 `MockHttpClient extends Mock implements http.Client`
- 更新 `tdd-audit-report.md` 與 batch 20 `tasks.md`
