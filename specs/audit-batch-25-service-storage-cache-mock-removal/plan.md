> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 25 service storage/cache mock 清理

## 技術策略

1. 優先重用 `test/support/fakes/core_service_infra_fakes.dart` 的 `FakeApiClient`、`FakeFlutterSecureStorage`、`TestLogger`，避免再造一套 API / storage / logger 假物件。
2. 擴充 `test/support/fakes/service_layer_fakes.dart`，讓 `ServiceFakeCacheManager`、`ServiceFakeAppDatabase` 足夠覆蓋 draft、search、unread count 與 cache coordinator 測試。
3. 先改寫 API / storage 類測試，再改寫 cache / DB 類測試，最後清掉 `.mocks.dart` 與註解殘留。
4. 完成後執行 batch 25 targeted tests、搜尋驗證、`flutter analyze --fatal-infos`，並補跑 Flutter 全量回歸。

## 分組實作

### A. 共用 fake 擴充

- `awesome_mail_flutter/test/support/fakes/core_service_infra_fakes.dart`
- `awesome_mail_flutter/test/support/fakes/service_layer_fakes.dart`

### B. API / secure storage 類測試

- `awesome_mail_flutter/test/unit/data/services/email_account_service_test.dart`
- `awesome_mail_flutter/test/unit/data/services/metrics_service_test.dart`
- `awesome_mail_flutter/test/unit/data/services/usage_tracking_service_test.dart`
- `awesome_mail_flutter/test/unit/data/services/subscription_service_test.dart`
- `awesome_mail_flutter/test/unit/data/services/settings_backup_service_test.dart`

### C. cache / database / logger 類測試

- `awesome_mail_flutter/test/unit/data/services/email_cache_service_test.dart`
- `awesome_mail_flutter/test/unit/data/services/email_cache_coordinator_cas_test.dart`
- `awesome_mail_flutter/test/unit/data/services/email_search_service_test.dart`
- `awesome_mail_flutter/test/unit/data/services/unread_count_manager_test.dart`
- `awesome_mail_flutter/test/unit/data/services/draft_service_test.dart`

### D. generated 檔案清理

- `awesome_mail_flutter/test/unit/data/services/usage_tracking_service_test.mocks.dart`
- `awesome_mail_flutter/test/unit/data/services/subscription_service_test.mocks.dart`
- `awesome_mail_flutter/test/unit/data/services/draft_service_test.mocks.dart`
- `awesome_mail_flutter/test/unit/data/services/unread_count_manager_test.mocks.dart`

## 驗證策略

- `flutter test` 執行 batch 25 相關 `data/services` 測試
- `flutter analyze --fatal-infos`
- `rg` 驗證這批檔案已無 `mockito`、`mocktail`、`@GenerateMocks`、`.mocks.dart`
- 完成後更新 `tdd-audit-report.md`
