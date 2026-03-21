# Spec: 批次 29 data services mock 清理

## 背景

batch 28 已清掉 `test/unit/presentation/blocs` 的第一組 mock-heavy 測試，接下來 Flutter 剩餘最大的 mock-heavy 群組是 `awesome_mail_flutter/test/unit/data/services`。其中 `automation`、`batch_operations`、`template`、`payment` 這四類 service 測試目前有 `14` 個檔案仍依賴 `mockito`、generated `.mocks.dart` 或大量 `when` / `verify`：

- `automation/email_rule_engine_simple_test.dart`
- `automation/email_rule_engine_simple_test.mocks.dart`
- `automation/email_rule_engine_test.dart`
- `automation/email_rule_engine_test.mocks.dart`
- `batch_operations/batch_operation_service_simple_test.dart`
- `batch_operations/batch_operation_service_simple_test.mocks.dart`
- `batch_operations/batch_operation_service_test.dart`
- `batch_operations/batch_operation_service_test.mocks.dart`
- `payment/payment_service_test.dart`
- `payment/payment_service_test.mocks.dart`
- `template_service_simple_test.dart`
- `template_service_simple_test.mocks.dart`
- `template_service_test.dart`
- `template_service_test.mocks.dart`

這批測試都屬於 data service 層，依賴型態集中在 `EmailService`、`AIService`、付款 provider 與 logger，適合先收斂成共用 hand-written fake。

## 問題陳述

這批 data service 測試目前有四個問題：

1. 大量用 `when`、`thenAnswer`、`verify` 腳本驅動，測試重心落在 mock 框架行為，而不是 service 真正輸出與狀態變化。
2. `EmailService`、`AIService`、付款 provider 的 generated mock 在多個檔案重複出現，維護成本高，介面變更時容易連鎖破壞。
3. `.mocks.dart` 讓測試耦合到 codegen 與 mock framework，而不是用最小可控 fake 驗證真實行為。
4. `test/unit/data/services` 是目前 Flutter 最大的 mock-heavy 群組，若不先清掉這批，後續 service 測試仍會持續複製相同 boilerplate。

## 使用者故事

### US1: 以 hand-written fake 驅動 automation / batch operation service 測試

作為維護者，我們希望 email rule 與 batch operation 類 service 測試改用 hand-written fake email service 驅動，直接驗證規則比對、動作執行、批次結果與錯誤處理。

#### 驗收條件

1. `automation` 與 `batch_operations` 測試不再依賴 `mockito`、`@GenerateMocks` 或 generated `.mocks.dart`。
2. 測試直接驗證 service 結果、history、錯誤與 email 操作記錄，而不是 `verify` 次數。
3. 相關 fake 可重用於其他 data service 測試。

### US2: 以 hand-written fake 驅動 template / payment service 測試

作為維護者，我們希望 `TemplateService` 與 `PaymentService` 改以 hand-written fake AI service 與付款 provider 驅動，直接驗證變數套用、建議、付款流程與錯誤處理。

#### 驗收條件

1. `template` 與 `payment` 測試改用最小可控 fake。
2. 測試保留 happy path、錯誤路徑與邏輯分支驗證。
3. 這批對應 `.mocks.dart` 依賴完全移除。

### US3: 清掉 batch 29 範圍的 mock framework 依賴

作為維護者，我們希望 batch 29 範圍內的 data service 測試不再命中 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`。

#### 驗收條件

1. 這批對應 `.mocks.dart` 已刪除。
2. batch 29 檔案與共用 fake 檔中已無 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`。
3. targeted tests、`flutter analyze --fatal-infos`、搜尋驗證與 Flutter 全量回歸通過。

## 非目標

- 不修改 production service 公開 API。
- 不在本批次處理 `ai_task_queue`、`ai_task_scheduler`、`email_cache_service`、`vector_search_service`。
- 不擴大處理 backend mock-heavy 測試。

## 成功指標

- 這 `14` 個 data service 測試檔案改由 hand-written fake 驅動。
- batch 29 targeted tests 與 `flutter analyze --fatal-infos` 通過。
- `test/unit/data/services` mock-heavy 群組在本批次完成後進一步下降。
