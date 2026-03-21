> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 29 data services mock 清理

## 技術策略

1. 先盤點這批測試共同依賴的 `EmailService`、`AIService` 與 payment provider，建立可重用的 hand-written fake。
2. 先處理 `automation`、`batch_operations` 這類流程單純、可直接驗證操作記錄的 service，再收斂 `template`、`payment`。
3. 對會產生副作用的方法改以記錄呼叫參數、可設定錯誤與固定回傳值的 fake 驅動，不再靠 `verify` 次數。
4. 完成後刪除對應 `.mocks.dart`，執行 targeted tests、搜尋驗證、`flutter analyze --fatal-infos`，最後補跑 Flutter 全量回歸。

## 分組實作

### A. data service 測試共用 fake

- `awesome_mail_flutter/test/support/fakes/` 下新增或擴充 data service 專用 fake

### B. automation / batch operation 類 service

- `automation/email_rule_engine_simple_test.dart`
- `automation/email_rule_engine_test.dart`
- `batch_operations/batch_operation_service_simple_test.dart`
- `batch_operations/batch_operation_service_test.dart`

### C. template / payment 類 service

- `template_service_simple_test.dart`
- `template_service_test.dart`
- `payment/payment_service_test.dart`

### D. generated 檔案清理

- `automation/email_rule_engine_simple_test.mocks.dart`
- `automation/email_rule_engine_test.mocks.dart`
- `batch_operations/batch_operation_service_simple_test.mocks.dart`
- `batch_operations/batch_operation_service_test.mocks.dart`
- `template_service_simple_test.mocks.dart`
- `template_service_test.mocks.dart`
- `payment/payment_service_test.mocks.dart`

## 驗證策略

- `flutter test` 執行 batch 29 相關 data service 測試
- `flutter analyze --fatal-infos`
- `rg` 驗證這批檔案已無 `mockito`、`mocktail`、`@GenerateMocks`、`.mocks.dart`
- 完成後更新 `tdd-audit-report.md`
