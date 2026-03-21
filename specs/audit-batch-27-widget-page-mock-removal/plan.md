> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 27 widget page mock 清理

## 技術策略

1. 先盤點 `widget/presentation/pages` 這 16 支測試共同依賴的 bloc / cubit / service / route harness，優先抽出可重用的 hand-written fake。
2. 先處理依賴最少、只需要固定 state 與簡單導覽的頁面，再收斂 `home`、`compose`、`subscription` 這類多依賴頁面。
3. 對 `ServiceFactory`、page controller、search / template / subscription 相關依賴建立最小可用假物件，避免繼續複製 `Mock implements ...`。
4. 完成後刪除對應 `.mocks.dart`，執行 targeted tests、搜尋驗證、`flutter analyze --fatal-infos`，最後補跑 Flutter 全量回歸。

## 分組實作

### A. widget page 共用 harness / fake

- `awesome_mail_flutter/test/support/fakes/` 下新增或擴充 page 測試專用 bloc / cubit / service / navigation fake

### B. 輕依賴頁面

- `ai/ai_classification_page_test.dart`
- `auth/oauth_login_page_test.dart`
- `automation/automation_page_test.dart`
- `batch/batch_operations_page_test.dart`
- `draft/draft_management_page_test.dart`
- `search/search_page_test.dart`
- `splash/splash_page_test.dart`

### C. 中度依賴頁面

- `account_setup/account_setup_page_test.dart`
- `subscription/subscription_analytics_page_test.dart`
- `subscription/subscription_page_impl_test.dart`
- `subscription/subscription_page_test.dart`
- `templates/advanced_template_management_page_test.dart`
- `templates/templates_page_impl_test.dart`

### D. 高依賴頁面

- `compose/compose_page_test.dart`
- `home/home_page_test.dart`
- `home/macos_home_page_test.dart`

## 驗證策略

- `flutter test` 執行 batch 27 相關 widget/page 測試
- `flutter analyze --fatal-infos`
- `rg` 驗證這批檔案已無 `mockito`、`mocktail`、`@GenerateMocks`、`.mocks.dart`
- 完成後更新 `tdd-audit-report.md`
